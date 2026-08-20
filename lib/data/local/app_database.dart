import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class ChildProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get parentId => text().nullable()();
  TextColumn get displayName => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  @override
  Set<Column<Object>> get primaryKey => {id};
}

class ActivityProgress extends Table {
  TextColumn get childId => text()();
  TextColumn get activityId => text()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get firstAnswerJson => text().nullable()();
  @override
  Set<Column<Object>> get primaryKey => {childId, activityId};
}

class RewardTransactions extends Table {
  TextColumn get id => text()();
  TextColumn get childId => text()();
  TextColumn get kind => text()();
  IntColumn get amount => integer()();
  TextColumn get activityId => text().nullable()();
  TextColumn get itemId => text().nullable()();
  DateTimeColumn get occurredAt => dateTime()();
  @override
  Set<Column<Object>> get primaryKey => {id};
}

class OwnedAccessories extends Table {
  TextColumn get childId => text()();
  TextColumn get accessoryId => text()();
  DateTimeColumn get purchasedAt => dateTime()();
  @override
  Set<Column<Object>> get primaryKey => {childId, accessoryId};
}

class SyncQueue extends Table {
  TextColumn get id => text()();
  TextColumn get operation => text()();
  TextColumn get payloadJson => text()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    ChildProfiles,
    ActivityProgress,
    RewardTransactions,
    OwnedAccessories,
    SyncQueue,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() => LazyDatabase(() async {
  final directory = await getApplicationDocumentsDirectory();
  return NativeDatabase.createInBackground(
    File(path.join(directory.path, 'bearfetch.sqlite')),
  );
});
