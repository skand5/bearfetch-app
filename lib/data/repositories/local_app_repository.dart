import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/repositories/app_repositories.dart';
import '../local/app_database.dart';

const _localParentId = 'local-parent';
const _localLearnerId = 'local-learner';
const _seedVersionKey = 'development-seed-version';
const _seedVersion = '1';

class LocalAppRepository
    implements
        AuthRepository,
        ParentRepository,
        LearnerRepository,
        ConsentRepository,
        ProgressRepository,
        RewardsRepository,
        ShopRepository,
        SyncRepository,
        PrivacyRepository {
  LocalAppRepository(this.database, {Uuid? uuid})
    : _uuid = uuid ?? const Uuid();

  final AppDatabase database;
  final Uuid _uuid;

  @override
  bool get hasSession => false;

  Future<void> ensureSeeded({required bool development}) async {
    await database.transaction(() async {
      final seed = await (database.select(
        database.appMetadata,
      )..where((row) => row.key.equals(_seedVersionKey))).getSingleOrNull();
      if (seed != null) return;
      final now = DateTime.now();
      final existingLearner = await (database.select(
        database.learnerProfiles,
      )..limit(1)).getSingleOrNull();
      if (development && existingLearner == null) {
        await database
            .into(database.parentProfiles)
            .insert(
              ParentProfilesCompanion.insert(
                id: _localParentId,
                displayName: 'Parent',
                createdAt: now,
                updatedAt: now,
              ),
            );
        await database
            .into(database.learnerProfiles)
            .insert(
              LearnerProfilesCompanion.insert(
                id: _localLearnerId,
                parentId: _localParentId,
                nickname: 'Max',
                avatarId: 'astronaut-bear',
                ageBand: '6–11 yr',
                language: 'English',
                createdAt: now,
                updatedAt: now,
              ),
            );
        await _insertReward(
          learnerId: _localLearnerId,
          kind: 'xp',
          amount: 340,
          reasonType: 'development_seed',
          reasonId: _seedVersion,
          idempotencyKey: 'seed:xp:$_seedVersion',
          occurredAt: now,
        );
        await _insertReward(
          learnerId: _localLearnerId,
          kind: 'honey',
          amount: 128,
          reasonType: 'development_seed',
          reasonId: _seedVersion,
          idempotencyKey: 'seed:honey:$_seedVersion',
          occurredAt: now,
        );
        for (final accessory in const ['Moon Glasses', 'Rocket Pack']) {
          await database
              .into(database.ownedAccessories)
              .insert(
                OwnedAccessoriesCompanion.insert(
                  learnerId: _localLearnerId,
                  accessoryId: accessory,
                  purchasedAt: now,
                ),
              );
        }
        await database
            .into(database.equippedAccessories)
            .insert(
              EquippedAccessoriesCompanion.insert(
                learnerId: _localLearnerId,
                slot: 'featured',
                accessoryId: 'Rocket Pack',
                equippedAt: now,
              ),
            );
      }
      await database
          .into(database.appMetadata)
          .insert(
            AppMetadataCompanion.insert(
              key: _seedVersionKey,
              value: development ? _seedVersion : 'production-none',
              updatedAt: now,
            ),
          );
    });
  }

  @override
  Future<ParentProfile?> getParent() =>
      (database.select(database.parentProfiles)..limit(1)).getSingleOrNull();

  @override
  Future<void> saveParentName(String name) async {
    final now = DateTime.now();
    final existing = await getParent();
    await database
        .into(database.parentProfiles)
        .insertOnConflictUpdate(
          ParentProfilesCompanion.insert(
            id: existing?.id ?? _localParentId,
            authUserId: Value(existing?.authUserId),
            displayName: name.trim(),
            createdAt: existing?.createdAt ?? now,
            updatedAt: now,
          ),
        );
  }

  @override
  Future<LearnerProfile?> getLearner() =>
      (database.select(database.learnerProfiles)
            ..where((row) => row.isDeleted.equals(false))
            ..limit(1))
          .getSingleOrNull();

  @override
  Future<void> saveLearner({
    required String nickname,
    required String ageBand,
    required String language,
  }) async {
    final now = DateTime.now();
    var parent = await getParent();
    if (parent == null) {
      await saveParentName('Parent');
      parent = await getParent();
    }
    final existing = await getLearner();
    await database
        .into(database.learnerProfiles)
        .insertOnConflictUpdate(
          LearnerProfilesCompanion.insert(
            id: existing?.id ?? _localLearnerId,
            parentId: parent!.id,
            nickname: nickname.trim(),
            avatarId: existing?.avatarId ?? 'astronaut-bear',
            ageBand: ageBand,
            language: language,
            createdAt: existing?.createdAt ?? now,
            updatedAt: now,
            isDeleted: const Value(false),
          ),
        );
  }

  @override
  Future<bool> hasActiveConsent() async {
    final row =
        await (database.select(database.consentRecords)
              ..orderBy([(row) => OrderingTerm.desc(row.updatedAt)])
              ..limit(1))
            .getSingleOrNull();
    return row?.status == 'active';
  }

  @override
  Future<void> approveLocalConsent() async {
    final parent = await getParent();
    if (parent == null) throw StateError('Parent profile is required.');
    final now = DateTime.now();
    await database
        .into(database.consentRecords)
        .insertOnConflictUpdate(
          ConsentRecordsCompanion.insert(
            id: 'local-consent',
            parentId: parent.id,
            status: 'active',
            version: const Value('local-section-2'),
            consentedAt: Value(now),
            createdAt: now,
            updatedAt: now,
          ),
        );
  }

  @override
  Future<Set<String>> completedActivityIds() async =>
      (await (database.select(
            database.activityProgress,
          )..where((row) => row.completedAt.isNotNull())).get())
          .map((row) => row.activityId)
          .toSet();

  @override
  Future<Map<String, int>> retryCounts() async => {
    for (final row in await database.select(database.activityProgress).get())
      row.activityId: row.retryCount,
  };

  @override
  Future<bool> completeActivity({
    required String activityId,
    required String rewardId,
  }) => database.transaction(() async {
    final learner = await _requireLearner();
    final current =
        await (database.select(database.activityProgress)..where(
              (row) =>
                  row.learnerId.equals(learner.id) &
                  row.activityId.equals(activityId),
            ))
            .getSingleOrNull();
    if (current?.completedAt != null) return false;

    final now = DateTime.now();
    await database
        .into(database.activityProgress)
        .insertOnConflictUpdate(
          ActivityProgressCompanion.insert(
            learnerId: learner.id,
            activityId: activityId,
            completedAt: Value(now),
            retryCount: Value(current?.retryCount ?? 0),
          ),
        );
    await _insertReward(
      learnerId: learner.id,
      kind: 'xp',
      amount: 10,
      reasonType: 'activity',
      reasonId: rewardId,
      idempotencyKey: 'activity:$activityId:xp',
      occurredAt: now,
    );
    await _insertReward(
      learnerId: learner.id,
      kind: 'honey',
      amount: 5,
      reasonType: 'activity',
      reasonId: rewardId,
      idempotencyKey: 'activity:$activityId:honey',
      occurredAt: now,
    );
    await _queueEvent(
      eventId: 'complete:$activityId',
      operation: 'complete_activity',
      payload: {'activityId': activityId, 'rewardId': rewardId},
      now: now,
    );
    return true;
  });

  @override
  Future<bool> completeCourse(String completionRewardId) =>
      database.transaction(() async {
        final learner = await _requireLearner();
        final existing =
            await (database.select(database.rewardTransactions)..where(
                  (row) => row.idempotencyKey.equals(
                    'course:$completionRewardId:xp',
                  ),
                ))
                .getSingleOrNull();
        if (existing != null) return false;
        final now = DateTime.now();
        await _insertReward(
          learnerId: learner.id,
          kind: 'xp',
          amount: 100,
          reasonType: 'course',
          reasonId: completionRewardId,
          idempotencyKey: 'course:$completionRewardId:xp',
          occurredAt: now,
        );
        await _insertReward(
          learnerId: learner.id,
          kind: 'honey',
          amount: 50,
          reasonType: 'course',
          reasonId: completionRewardId,
          idempotencyKey: 'course:$completionRewardId:honey',
          occurredAt: now,
        );
        for (final achievementId in const [
          'ai-explorer-badge',
          'llm-starter-certificate',
        ]) {
          await database
              .into(database.achievements)
              .insert(
                AchievementsCompanion.insert(
                  learnerId: learner.id,
                  achievementId: achievementId,
                  earnedAt: now,
                ),
                mode: InsertMode.insertOrIgnore,
              );
        }
        await _queueEvent(
          eventId: 'complete-course:$completionRewardId',
          operation: 'complete_course',
          payload: {'completionRewardId': completionRewardId},
          now: now,
        );
        return true;
      });

  @override
  Future<void> recordRetry(String activityId) => database.transaction(() async {
    final learner = await _requireLearner();
    final current =
        await (database.select(database.activityProgress)..where(
              (row) =>
                  row.learnerId.equals(learner.id) &
                  row.activityId.equals(activityId),
            ))
            .getSingleOrNull();
    await database
        .into(database.activityProgress)
        .insertOnConflictUpdate(
          ActivityProgressCompanion.insert(
            learnerId: learner.id,
            activityId: activityId,
            completedAt: Value(current?.completedAt),
            retryCount: Value((current?.retryCount ?? 0) + 1),
          ),
        );
  });

  @override
  Future<int> balance(String kind) async =>
      (await (database.select(
        database.rewardTransactions,
      )..where((row) => row.kind.equals(kind))).get()).fold<int>(
        0,
        (total, row) => total + row.amount,
      );

  @override
  Future<Set<String>> achievementIds() async =>
      (await database.select(database.achievements).get())
          .map((row) => row.achievementId)
          .toSet();

  @override
  Future<Set<String>> ownedAccessoryIds() async =>
      (await database.select(database.ownedAccessories).get())
          .map((row) => row.accessoryId)
          .toSet();

  @override
  Future<Map<String, String>> equippedAccessories() async => {
    for (final row in await database.select(database.equippedAccessories).get())
      row.slot: row.accessoryId,
  };

  @override
  Future<PurchaseResult> purchase({
    required String accessoryId,
    required int price,
  }) => database.transaction(() async {
    final learner = await _requireLearner();
    final owned =
        await (database.select(database.ownedAccessories)..where(
              (row) =>
                  row.learnerId.equals(learner.id) &
                  row.accessoryId.equals(accessoryId),
            ))
            .getSingleOrNull();
    if (owned != null) return PurchaseResult.alreadyOwned;
    if (await balance('honey') < price) return PurchaseResult.insufficientHoney;

    final now = DateTime.now();
    await _insertReward(
      learnerId: learner.id,
      kind: 'honey',
      amount: -price,
      reasonType: 'accessory_purchase',
      reasonId: accessoryId,
      idempotencyKey: 'purchase:$accessoryId:honey',
      occurredAt: now,
    );
    await database
        .into(database.ownedAccessories)
        .insert(
          OwnedAccessoriesCompanion.insert(
            learnerId: learner.id,
            accessoryId: accessoryId,
            purchasedAt: now,
          ),
        );
    await _queueEvent(
      eventId: 'purchase:$accessoryId',
      operation: 'purchase_accessory',
      payload: {'accessoryId': accessoryId},
      now: now,
    );
    return PurchaseResult.purchased;
  });

  @override
  Future<bool> equip({required String accessoryId, required String slot}) =>
      database.transaction(() async {
        final learner = await _requireLearner();
        final owned =
            await (database.select(database.ownedAccessories)..where(
                  (row) =>
                      row.learnerId.equals(learner.id) &
                      row.accessoryId.equals(accessoryId),
                ))
                .getSingleOrNull();
        if (owned == null) return false;
        final now = DateTime.now();
        await database
            .into(database.equippedAccessories)
            .insertOnConflictUpdate(
              EquippedAccessoriesCompanion.insert(
                learnerId: learner.id,
                slot: slot,
                accessoryId: accessoryId,
                equippedAt: now,
              ),
            );
        await _queueEvent(
          eventId: 'equip:$slot:$accessoryId:${now.microsecondsSinceEpoch}',
          operation: 'equip_accessory',
          payload: {'accessoryId': accessoryId, 'slot': slot},
          now: now,
        );
        return true;
      });

  @override
  Future<int> pendingEventCount() async => (await (database.select(
    database.syncOutbox,
  )..where((row) => row.syncedAt.isNull())).get()).length;

  @override
  Future<String?> lastRecoverableError() async {
    final metadata =
        await (database.select(database.syncMetadata)
              ..where((row) => row.key.equals('last_recoverable_error')))
            .getSingleOrNull();
    return metadata?.value;
  }

  @override
  Future<Map<String, Object?>> exportLocalData() async => {
    'parent': (await getParent())?.displayName,
    'learner': (await getLearner())?.nickname,
    'completedActivityIds': (await completedActivityIds()).toList()..sort(),
    'xp': await balance('xp'),
    'honey': await balance('honey'),
    'achievements': (await achievementIds()).toList()..sort(),
    'ownedAccessories': (await ownedAccessoryIds()).toList()..sort(),
    'equippedAccessories': await equippedAccessories(),
  };

  Future<LearnerProfile> _requireLearner() async {
    final learner = await getLearner();
    if (learner == null) throw StateError('Learner profile is required.');
    return learner;
  }

  Future<void> _insertReward({
    required String learnerId,
    required String kind,
    required int amount,
    required String reasonType,
    required String reasonId,
    required String idempotencyKey,
    required DateTime occurredAt,
  }) => database
      .into(database.rewardTransactions)
      .insert(
        RewardTransactionsCompanion.insert(
          id: _uuid.v4(),
          learnerId: learnerId,
          kind: kind,
          amount: amount,
          reasonType: reasonType,
          reasonId: reasonId,
          idempotencyKey: idempotencyKey,
          occurredAt: occurredAt,
        ),
        mode: InsertMode.insertOrIgnore,
      );

  Future<void> _queueEvent({
    required String eventId,
    required String operation,
    required Map<String, Object?> payload,
    required DateTime now,
  }) => database
      .into(database.syncOutbox)
      .insert(
        SyncOutboxCompanion.insert(
          id: _uuid.v4(),
          eventId: eventId,
          operation: operation,
          payloadJson: jsonEncode(payload),
          createdAt: now,
        ),
        mode: InsertMode.insertOrIgnore,
      );
}
