import 'dart:convert';

import 'package:bearfetch_app/data/local/app_database.dart';
import 'package:bearfetch_app/data/repositories/local_app_repository.dart';
import 'package:bearfetch_app/domain/repositories/app_repositories.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late LocalAppRepository repository;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = LocalAppRepository(database);
    await repository.ensureSeeded(development: true);
  });

  tearDown(() => database.close());

  test(
    'development fixture seeds once with approved prototype values',
    () async {
      await repository.ensureSeeded(development: true);
      expect((await repository.getLearner())?.nickname, 'Max');
      expect(await repository.balance('xp'), 340);
      expect(await repository.balance('honey'), 128);
      expect(await repository.ownedAccessoryIds(), {
        'Moon Glasses',
        'Rocket Pack',
      });
      expect(await repository.equippedAccessories(), {
        'featured': 'Rocket Pack',
      });
    },
  );

  test('production seed creates no family profile or rewards', () async {
    await database.close();
    database = AppDatabase.forTesting(NativeDatabase.memory());
    final productionRepository = LocalAppRepository(database);
    await productionRepository.ensureSeeded(development: false);
    expect(await productionRepository.getParent(), isNull);
    expect(await productionRepository.getLearner(), isNull);
    expect(await productionRepository.balance('xp'), 0);
    expect(await productionRepository.balance('honey'), 0);
    expect(await productionRepository.ownedAccessoryIds(), isEmpty);
  });

  test('onboarding profile and consent persist locally', () async {
    await repository.saveParentName('Priya Kumar');
    await repository.saveLearner(
      nickname: 'Aarav',
      ageBand: '6–11 yr',
      language: 'English',
    );
    await repository.approveLocalConsent();
    expect((await repository.getParent())?.displayName, 'Priya Kumar');
    expect((await repository.getLearner())?.nickname, 'Aarav');
    expect(await repository.hasActiveConsent(), isTrue);
  });

  test('activity completion and rewards are idempotent', () async {
    expect(
      await repository.completeActivity(
        activityId: 'unit-01-01',
        rewardId: 'activity-unit-01-01',
      ),
      isTrue,
    );
    expect(
      await repository.completeActivity(
        activityId: 'unit-01-01',
        rewardId: 'activity-unit-01-01',
      ),
      isFalse,
    );
    expect(await repository.completedActivityIds(), {'unit-01-01'});
    expect(await repository.balance('xp'), 350);
    expect(await repository.balance('honey'), 133);
    expect(await repository.pendingEventCount(), 1);
  });

  test('retry stores only count and outbox contains no answer data', () async {
    await repository.recordRetry('unit-01-02');
    await repository.recordRetry('unit-01-02');
    expect((await repository.retryCounts())['unit-01-02'], 2);

    await repository.completeActivity(
      activityId: 'unit-01-02',
      rewardId: 'activity-unit-01-02',
    );
    final columns = await database
        .customSelect("PRAGMA table_info('activity_progress')")
        .get();
    expect(
      columns.map((row) => row.read<String>('name')),
      isNot(contains('first_answer_json')),
    );
    final event = await database.select(database.syncOutbox).getSingle();
    expect(jsonDecode(event.payloadJson), {
      'activityId': 'unit-01-02',
      'rewardId': 'activity-unit-01-02',
    });
  });

  test('purchase is atomic and equipment requires ownership', () async {
    expect(
      await repository.equip(accessoryId: 'Galaxy Helm', slot: 'featured'),
      isFalse,
    );
    expect(
      await repository.purchase(accessoryId: 'Star Cap', price: 25),
      PurchaseResult.purchased,
    );
    expect(await repository.balance('honey'), 103);
    expect(
      await repository.purchase(accessoryId: 'Star Cap', price: 25),
      PurchaseResult.alreadyOwned,
    );
    expect(await repository.balance('honey'), 103);
    expect(
      await repository.equip(accessoryId: 'Star Cap', slot: 'featured'),
      isTrue,
    );
    expect(await repository.equippedAccessories(), {'featured': 'Star Cap'});
  });

  test('insufficient honey does not grant accessory or write ledger', () async {
    expect(
      await repository.purchase(accessoryId: 'Galaxy Helm', price: 180),
      PurchaseResult.insufficientHoney,
    );
    expect(await repository.balance('honey'), 128);
    expect(
      await repository.ownedAccessoryIds(),
      isNot(contains('Galaxy Helm')),
    );
  });

  test('course rewards and achievements are idempotent', () async {
    expect(await repository.completeCourse('course-ai-01-complete'), isTrue);
    expect(await repository.completeCourse('course-ai-01-complete'), isFalse);
    expect(await repository.balance('xp'), 440);
    expect(await repository.balance('honey'), 178);
    expect(await repository.achievementIds(), {
      'ai-explorer-badge',
      'llm-starter-certificate',
    });
  });

  test(
    'consent withdrawal is queued and blocks active consent locally',
    () async {
      await repository.withdrawConsent();

      expect(await repository.hasActiveConsent(), isFalse);
      expect(await repository.consentStatus(), 'withdrawn');
      final event = await database.select(database.syncOutbox).getSingle();
      expect(event.operation, 'withdraw_consent');
      expect(jsonDecode(event.payloadJson), isEmpty);
    },
  );

  test(
    'deletion is restricted locally for 30 days and can be cancelled',
    () async {
      final request = await repository.scheduleDeletion(DeletionTarget.learner);

      expect(request.isPending, isTrue);
      expect(request.scheduledFor, isNotNull);
      expect(
        request.scheduledFor!.difference(DateTime.now()).inDays,
        inInclusiveRange(29, 30),
      );
      expect(
        (await repository.deletionRequestState()).requestId,
        request.requestId,
      );

      await repository.cancelDeletion(request.requestId!);
      expect((await repository.deletionRequestState()).status, 'none');
      final operations = (await database.select(database.syncOutbox).get()).map(
        (event) => event.operation,
      );
      expect(operations, containsAll(['schedule_deletion', 'cancel_deletion']));
    },
  );

  test('failed sync events use bounded exponential retry metadata', () async {
    await repository.completeActivity(
      activityId: 'unit-01-01',
      rewardId: 'activity-unit-01-01',
    );
    final pending = await repository.pendingSyncEvents();
    final before = DateTime.now();

    await repository.markSyncEventFailed(pending.single.eventId, 'offline');
    final failed = await database.select(database.syncOutbox).getSingle();
    expect(failed.attempts, 1);
    expect(failed.nextAttemptAt, isNotNull);
    expect(
      failed.nextAttemptAt!.difference(before).inMinutes,
      inInclusiveRange(1, 2),
    );
  });
}
