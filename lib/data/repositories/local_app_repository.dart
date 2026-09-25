import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/repositories/app_repositories.dart';
import '../local/app_database.dart';

const _localParentId = 'local-parent';
const _localLearnerId = 'local-learner';
const _seedVersionKey = 'development-seed-version';
const _seedVersion = '2';

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
  bool get requiresAuthentication => false;

  @override
  bool get supportsDemoLogin => false;

  @override
  bool get hasSession => false;

  @override
  String? get currentUserId => null;

  @override
  String? get currentEmail => null;

  @override
  Stream<AuthSessionStatus> get sessionChanges => const Stream.empty();

  @override
  Future<void> requestEmailOtp(String email) async {}

  @override
  Future<void> verifyEmailOtp({
    required String email,
    required String token,
  }) async {}

  @override
  Future<void> signInDemo() async {}

  @override
  Future<void> signOut() async {}

  Future<void> ensureSeeded({required bool development}) async {
    await database.transaction(() async {
      final seed = await (database.select(
        database.appMetadata,
      )..where((row) => row.key.equals(_seedVersionKey))).getSingleOrNull();
      if (seed != null) {
        if (!development || seed.value == _seedVersion) return;
        await _clearDevelopmentDemoData();
        final now = DateTime.now();
        await _createFreshDevelopmentFamily(now);
        await (database.update(
          database.appMetadata,
        )..where((row) => row.key.equals(_seedVersionKey))).write(
          AppMetadataCompanion(
            value: Value(_seedVersion),
            updatedAt: Value(now),
          ),
        );
        return;
      }
      final now = DateTime.now();
      final existingLearner = await (database.select(
        database.learnerProfiles,
      )..limit(1)).getSingleOrNull();
      if (development && existingLearner == null) {
        await _createFreshDevelopmentFamily(now);
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

  /// Restores the development demo to the beginning of the course.
  ///
  /// This deliberately has no remote equivalent. It is called only by the
  /// development-only demo authentication repository before each demo sign-in.
  Future<void> resetDevelopmentDemo() => database.transaction(() async {
    await _clearDevelopmentDemoData();
    await _createFreshDevelopmentFamily(DateTime.now());
  });

  Future<void> _clearDevelopmentDemoData() async {
    await database.delete(database.syncOutbox).go();
    await database.delete(database.syncMetadata).go();
    await database.delete(database.deletionRequests).go();
    await database.delete(database.equippedAccessories).go();
    await database.delete(database.ownedAccessories).go();
    await database.delete(database.achievements).go();
    await database.delete(database.rewardTransactions).go();
    await database.delete(database.activityProgress).go();
    await database.delete(database.consentRecords).go();
    await database.delete(database.learnerProfiles).go();
    await database.delete(database.parentProfiles).go();
  }

  Future<void> _createFreshDevelopmentFamily(DateTime now) async {
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
    final row = await _latestConsent();
    return row?.status == 'active';
  }

  @override
  Future<String> consentStatus() async =>
      (await _latestConsent())?.status ?? 'none';

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
  Future<bool> unequip({required String slot}) =>
      database.transaction(() async {
        final learner = await _requireLearner();
        final deleted =
            await (database.delete(database.equippedAccessories)..where(
                  (row) =>
                      row.learnerId.equals(learner.id) & row.slot.equals(slot),
                ))
                .go();
        if (deleted == 0) return false;
        final now = DateTime.now();
        await _queueEvent(
          eventId: 'unequip:$slot:${now.microsecondsSinceEpoch}',
          operation: 'unequip_accessory',
          payload: {'slot': slot},
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
  Future<SyncRunResult> syncNow() async => const SyncRunResult(
    status: SyncRunStatus.skipped,
    message: 'Remote sync is not configured.',
  );

  Future<List<SyncOutboxData>> pendingSyncEvents({DateTime? now}) async {
    final cutoff = now ?? DateTime.now();
    return (database.select(database.syncOutbox)
          ..where(
            (row) =>
                row.syncedAt.isNull() &
                (row.nextAttemptAt.isNull() |
                    row.nextAttemptAt.isSmallerOrEqualValue(cutoff)),
          )
          ..orderBy([(row) => OrderingTerm.asc(row.createdAt)]))
        .get();
  }

  Future<void> markSyncEventSucceeded(String eventId) => database.transaction(
    () async {
      final now = DateTime.now();
      await (database.update(
        database.syncOutbox,
      )..where((row) => row.eventId.equals(eventId))).write(
        SyncOutboxCompanion(
          syncedAt: Value(now),
          lastError: const Value(null),
          nextAttemptAt: const Value(null),
        ),
      );
      await _setSyncMetadata('last_successful_sync_at', now.toIso8601String());
      await _setSyncMetadata('last_recoverable_error', '');
    },
  );

  Future<void> markSyncEventFailed(String eventId, Object error) =>
      database.transaction(() async {
        final current = await (database.select(
          database.syncOutbox,
        )..where((row) => row.eventId.equals(eventId))).getSingleOrNull();
        if (current == null) return;
        final attempts = current.attempts + 1;
        final minutes = 1 << attempts.clamp(0, 8).toInt();
        final retryAt = DateTime.now().add(Duration(minutes: minutes));
        final message = _safeSyncError(error);
        await (database.update(
          database.syncOutbox,
        )..where((row) => row.eventId.equals(eventId))).write(
          SyncOutboxCompanion(
            attempts: Value(attempts),
            nextAttemptAt: Value(retryAt),
            lastError: Value(message),
          ),
        );
        await _setSyncMetadata('last_recoverable_error', message);
      });

  Future<void> replaceWithRemoteSnapshot({
    required Map<String, Object?> parent,
    required Map<String, Object?> learner,
    required List<Map<String, Object?>> consents,
    required List<Map<String, Object?>> progress,
    required List<Map<String, Object?>> rewards,
    required List<Map<String, Object?>> achievements,
    required List<Map<String, Object?>> ownedAccessories,
    required List<Map<String, Object?>> equippedAccessories,
    required List<Map<String, Object?>> deletionRequests,
  }) => database.transaction(() async {
    final localRetries = {
      for (final row in await database.select(database.activityProgress).get())
        row.activityId: row.retryCount,
    };
    await database.delete(database.equippedAccessories).go();
    await database.delete(database.ownedAccessories).go();
    await database.delete(database.achievements).go();
    await database.delete(database.rewardTransactions).go();
    await database.delete(database.activityProgress).go();
    await database.delete(database.consentRecords).go();
    await database.delete(database.deletionRequests).go();
    await database.delete(database.learnerProfiles).go();
    await database.delete(database.parentProfiles).go();

    final parentId = parent['id']! as String;
    final learnerId = learner['id']! as String;
    await database
        .into(database.parentProfiles)
        .insert(
          ParentProfilesCompanion.insert(
            id: parentId,
            authUserId: Value(parentId),
            displayName: parent['display_name']! as String,
            createdAt: _readTimestamp(parent['created_at']),
            updatedAt: _readTimestamp(parent['updated_at']),
          ),
        );
    await database
        .into(database.learnerProfiles)
        .insert(
          LearnerProfilesCompanion.insert(
            id: learnerId,
            parentId: parentId,
            nickname: learner['nickname']! as String,
            avatarId: learner['avatar_id']! as String,
            ageBand: learner['age_band']! as String,
            language: learner['language']! as String,
            createdAt: _readTimestamp(learner['created_at']),
            updatedAt: _readTimestamp(learner['updated_at']),
            isDeleted: Value(learner['deleted_at'] != null),
          ),
        );
    for (final row in consents) {
      await database
          .into(database.consentRecords)
          .insert(
            ConsentRecordsCompanion.insert(
              id: row['id']! as String,
              parentId: parentId,
              status: row['status']! as String,
              version: Value(row['consent_version'] as String?),
              consentedAt: Value(_readNullableTimestamp(row['consented_at'])),
              withdrawnAt: Value(_readNullableTimestamp(row['withdrawn_at'])),
              createdAt: _readTimestamp(row['created_at']),
              updatedAt: _readTimestamp(row['updated_at']),
            ),
          );
    }
    for (final row in progress) {
      final activityId = row['activity_id']! as String;
      await database
          .into(database.activityProgress)
          .insert(
            ActivityProgressCompanion.insert(
              learnerId: learnerId,
              activityId: activityId,
              completedAt: Value(_readNullableTimestamp(row['completed_at'])),
              retryCount: Value(localRetries[activityId] ?? 0),
            ),
          );
    }
    for (final row in rewards) {
      await database
          .into(database.rewardTransactions)
          .insert(
            RewardTransactionsCompanion.insert(
              id: row['id']! as String,
              learnerId: learnerId,
              kind: row['kind']! as String,
              amount: row['amount']! as int,
              reasonType: row['reason_type']! as String,
              reasonId: row['reason_id']! as String,
              idempotencyKey: row['idempotency_key']! as String,
              occurredAt: _readTimestamp(row['occurred_at']),
            ),
          );
    }
    for (final row in achievements) {
      await database
          .into(database.achievements)
          .insert(
            AchievementsCompanion.insert(
              learnerId: learnerId,
              achievementId: row['achievement_id']! as String,
              earnedAt: _readTimestamp(row['earned_at']),
            ),
          );
    }
    for (final row in ownedAccessories) {
      await database
          .into(database.ownedAccessories)
          .insert(
            OwnedAccessoriesCompanion.insert(
              learnerId: learnerId,
              accessoryId: row['accessory_id']! as String,
              purchasedAt: _readTimestamp(row['purchased_at']),
            ),
          );
    }
    for (final row in equippedAccessories) {
      await database
          .into(database.equippedAccessories)
          .insert(
            EquippedAccessoriesCompanion.insert(
              learnerId: learnerId,
              slot: row['slot']! as String,
              accessoryId: row['accessory_id']! as String,
              equippedAt: _readTimestamp(row['equipped_at']),
            ),
          );
    }
    for (final row in deletionRequests) {
      await database
          .into(database.deletionRequests)
          .insert(
            DeletionRequestsCompanion.insert(
              id: row['id']! as String,
              target: row['target']! as String,
              status: row['status']! as String,
              requestedAt: _readTimestamp(row['requested_at']),
              scheduledFor: _readTimestamp(row['scheduled_for']),
              cancelledAt: Value(_readNullableTimestamp(row['cancelled_at'])),
            ),
          );
    }
    await _setSyncMetadata(
      'last_reconciled_at',
      DateTime.now().toIso8601String(),
    );
  });

  @override
  Future<void> withdrawConsent() => database.transaction(() async {
    final parent = await getParent();
    if (parent == null) throw StateError('Parent profile is required.');
    final now = DateTime.now();
    final existing = await _latestConsent();
    await database
        .into(database.consentRecords)
        .insertOnConflictUpdate(
          ConsentRecordsCompanion.insert(
            id: existing?.id ?? 'local-consent',
            parentId: parent.id,
            status: 'withdrawn',
            version: Value(existing?.version),
            consentedAt: Value(existing?.consentedAt),
            withdrawnAt: Value(now),
            createdAt: existing?.createdAt ?? now,
            updatedAt: now,
          ),
        );
    await _queueEvent(
      eventId: 'withdraw-consent:${now.microsecondsSinceEpoch}',
      operation: 'withdraw_consent',
      payload: const {},
      now: now,
    );
  });

  @override
  Future<DeletionRequestState> deletionRequestState() async {
    final row =
        await (database.select(database.deletionRequests)
              ..where((row) => row.status.equals('pending'))
              ..orderBy([(row) => OrderingTerm.desc(row.requestedAt)])
              ..limit(1))
            .getSingleOrNull();
    return row == null
        ? const DeletionRequestState(status: 'none')
        : DeletionRequestState(
            status: row.status,
            requestId: row.id,
            scheduledFor: row.scheduledFor,
          );
  }

  @override
  Future<DeletionRequestState> scheduleDeletion(DeletionTarget target) =>
      database.transaction(() async {
        final pending = await deletionRequestState();
        if (pending.isPending) return pending;
        final now = DateTime.now();
        final id = _uuid.v4();
        final scheduledFor = now.add(const Duration(days: 30));
        await database
            .into(database.deletionRequests)
            .insert(
              DeletionRequestsCompanion.insert(
                id: id,
                target: target.name,
                status: 'pending',
                requestedAt: now,
                scheduledFor: scheduledFor,
              ),
            );
        await _queueEvent(
          eventId: 'schedule-deletion:$id',
          operation: 'schedule_deletion',
          payload: {'target': target.name, 'requestId': id},
          now: now,
        );
        return DeletionRequestState(
          status: 'pending',
          requestId: id,
          scheduledFor: scheduledFor,
        );
      });

  @override
  Future<void> cancelDeletion(String requestId) => database.transaction(
    () async {
      final now = DateTime.now();
      final updated =
          await (database.update(database.deletionRequests)..where(
                (row) =>
                    row.id.equals(requestId) & row.status.equals('pending'),
              ))
              .write(
                DeletionRequestsCompanion(
                  status: const Value('cancelled'),
                  cancelledAt: Value(now),
                ),
              );
      if (updated == 0) throw StateError('No pending deletion request found.');
      await _queueEvent(
        eventId: 'cancel-deletion:$requestId:${now.microsecondsSinceEpoch}',
        operation: 'cancel_deletion',
        payload: {'requestId': requestId},
        now: now,
      );
    },
  );

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
    'consentStatus': (await _latestConsent())?.status ?? 'none',
    'deletionRequest': {
      'status': (await deletionRequestState()).status,
      'scheduledFor': (await deletionRequestState()).scheduledFor
          ?.toIso8601String(),
    },
  };

  Future<ConsentRecord?> _latestConsent() =>
      (database.select(database.consentRecords)
            ..orderBy([(row) => OrderingTerm.desc(row.updatedAt)])
            ..limit(1))
          .getSingleOrNull();

  Future<void> _setSyncMetadata(String key, String value) => database
      .into(database.syncMetadata)
      .insertOnConflictUpdate(
        SyncMetadataCompanion.insert(
          key: key,
          value: value,
          updatedAt: DateTime.now(),
        ),
      );

  String _safeSyncError(Object error) {
    final text = error.toString().replaceAll(RegExp(r'\s+'), ' ').trim();
    return text.length <= 180 ? text : text.substring(0, 180);
  }

  DateTime _readTimestamp(Object? value) {
    final parsed = _readNullableTimestamp(value);
    if (parsed == null) throw StateError('Remote timestamp was missing.');
    return parsed;
  }

  DateTime? _readNullableTimestamp(Object? value) => switch (value) {
    null => null,
    DateTime value => value,
    String value => DateTime.parse(value),
    _ => throw StateError('Remote timestamp was invalid.'),
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
