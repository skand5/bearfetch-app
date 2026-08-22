import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class ParentProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get authUserId => text().nullable()();
  TextColumn get displayName => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  @override
  Set<Column<Object>> get primaryKey => {id};
}

class ConsentRecords extends Table {
  TextColumn get id => text()();
  TextColumn get parentId => text()();
  TextColumn get status => text()();
  TextColumn get version => text().nullable()();
  DateTimeColumn get consentedAt => dateTime().nullable()();
  DateTimeColumn get withdrawnAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  @override
  Set<Column<Object>> get primaryKey => {id};
}

class LearnerProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get parentId => text()();
  TextColumn get nickname => text()();
  TextColumn get avatarId => text()();
  TextColumn get ageBand => text()();
  TextColumn get language => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  @override
  Set<Column<Object>> get primaryKey => {id};
}

class ActivityProgress extends Table {
  TextColumn get learnerId => text()();
  TextColumn get activityId => text()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  @override
  Set<Column<Object>> get primaryKey => {learnerId, activityId};
}

class RewardTransactions extends Table {
  TextColumn get id => text()();
  TextColumn get learnerId => text()();
  TextColumn get kind => text()();
  IntColumn get amount => integer()();
  TextColumn get reasonType => text()();
  TextColumn get reasonId => text()();
  TextColumn get idempotencyKey => text().unique()();
  DateTimeColumn get occurredAt => dateTime()();
  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Achievements extends Table {
  TextColumn get learnerId => text()();
  TextColumn get achievementId => text()();
  DateTimeColumn get earnedAt => dateTime()();
  @override
  Set<Column<Object>> get primaryKey => {learnerId, achievementId};
}

class OwnedAccessories extends Table {
  TextColumn get learnerId => text()();
  TextColumn get accessoryId => text()();
  DateTimeColumn get purchasedAt => dateTime()();
  @override
  Set<Column<Object>> get primaryKey => {learnerId, accessoryId};
}

class EquippedAccessories extends Table {
  TextColumn get learnerId => text()();
  TextColumn get slot => text()();
  TextColumn get accessoryId => text()();
  DateTimeColumn get equippedAt => dateTime()();
  @override
  Set<Column<Object>> get primaryKey => {learnerId, slot};
}

class SyncOutbox extends Table {
  TextColumn get id => text()();
  TextColumn get eventId => text().unique()();
  TextColumn get operation => text()();
  TextColumn get payloadJson => text()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  DateTimeColumn get nextAttemptAt => dateTime().nullable()();
  TextColumn get lastError => text().nullable()();
  DateTimeColumn get syncedAt => dateTime().nullable()();
  @override
  Set<Column<Object>> get primaryKey => {id};
}

class SyncMetadata extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  DateTimeColumn get updatedAt => dateTime()();
  @override
  Set<Column<Object>> get primaryKey => {key};
}

class DeletionRequests extends Table {
  TextColumn get id => text()();
  TextColumn get target => text()();
  TextColumn get status => text()();
  DateTimeColumn get requestedAt => dateTime()();
  DateTimeColumn get scheduledFor => dateTime()();
  DateTimeColumn get cancelledAt => dateTime().nullable()();
  @override
  Set<Column<Object>> get primaryKey => {id};
}

class AppMetadata extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  DateTimeColumn get updatedAt => dateTime()();
  @override
  Set<Column<Object>> get primaryKey => {key};
}

@DriftDatabase(
  tables: [
    ParentProfiles,
    ConsentRecords,
    LearnerProfiles,
    ActivityProgress,
    RewardTransactions,
    Achievements,
    OwnedAccessories,
    EquippedAccessories,
    SyncOutbox,
    SyncMetadata,
    DeletionRequests,
    AppMetadata,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    onUpgrade: (migrator, from, to) async {
      if (from == 1) await _migrateV1ToV2(migrator);
      if (from == 2) await migrator.createTable(deletionRequests);
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  Future<void> _migrateV1ToV2(Migrator migrator) async {
    await customStatement(
      'ALTER TABLE child_profiles RENAME TO child_profiles_v1',
    );
    await customStatement(
      'ALTER TABLE activity_progress RENAME TO activity_progress_v1',
    );
    await customStatement(
      'ALTER TABLE reward_transactions RENAME TO reward_transactions_v1',
    );
    await customStatement(
      'ALTER TABLE owned_accessories RENAME TO owned_accessories_v1',
    );
    await customStatement('ALTER TABLE sync_queue RENAME TO sync_queue_v1');
    await migrator.createAll();

    final now = DateTime.now().millisecondsSinceEpoch;
    await customStatement(
      'INSERT INTO parent_profiles '
      '(id, auth_user_id, display_name, created_at, updated_at) '
      "SELECT 'legacy-parent', NULL, 'Parent', MIN(created_at), ? "
      'FROM child_profiles_v1 HAVING COUNT(*) > 0',
      [now],
    );
    await customStatement(
      'INSERT INTO learner_profiles '
      '(id, parent_id, nickname, avatar_id, age_band, language, created_at, updated_at, is_deleted) '
      "SELECT id, 'legacy-parent', COALESCE(display_name, 'Max'), "
      "'astronaut-bear', '6–11 yr', 'English', created_at, ?, is_deleted "
      'FROM child_profiles_v1 ORDER BY created_at, id LIMIT 1',
      [now],
    );
    await customStatement(
      'INSERT INTO activity_progress '
      '(learner_id, activity_id, completed_at, retry_count) '
      'SELECT child_id, activity_id, completed_at, retry_count '
      'FROM activity_progress_v1 WHERE child_id = '
      '(SELECT id FROM child_profiles_v1 ORDER BY created_at, id LIMIT 1)',
    );
    await customStatement(
      'INSERT INTO reward_transactions '
      '(id, learner_id, kind, amount, reason_type, reason_id, idempotency_key, occurred_at) '
      "SELECT id, child_id, kind, amount, 'legacy', "
      "COALESCE(activity_id, item_id, id), 'legacy:' || id, occurred_at "
      'FROM reward_transactions_v1 WHERE child_id = '
      '(SELECT id FROM child_profiles_v1 ORDER BY created_at, id LIMIT 1)',
    );
    await customStatement(
      'INSERT INTO owned_accessories (learner_id, accessory_id, purchased_at) '
      'SELECT child_id, accessory_id, purchased_at FROM owned_accessories_v1 '
      'WHERE child_id = '
      '(SELECT id FROM child_profiles_v1 ORDER BY created_at, id LIMIT 1)',
    );
    await customStatement(
      'INSERT INTO sync_outbox '
      '(id, event_id, operation, payload_json, created_at, attempts, next_attempt_at, last_error, synced_at) '
      'SELECT id, id, operation, payload_json, created_at, attempts, NULL, NULL, NULL '
      'FROM sync_queue_v1',
    );

    for (final table in const [
      'child_profiles_v1',
      'activity_progress_v1',
      'reward_transactions_v1',
      'owned_accessories_v1',
      'sync_queue_v1',
    ]) {
      await customStatement('DROP TABLE $table');
    }
  }
}

LazyDatabase _openConnection() => LazyDatabase(() async {
  final directory = await getApplicationDocumentsDirectory();
  return NativeDatabase.createInBackground(
    File(path.join(directory.path, 'bearfetch.sqlite')),
  );
});
