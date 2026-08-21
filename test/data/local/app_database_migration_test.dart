import 'dart:io';

import 'package:bearfetch_app/data/local/app_database.dart';
import 'package:bearfetch_app/data/repositories/local_app_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  test('v1 database migrates profiles, progress, rewards, and accessories', () async {
    final directory = await Directory.systemTemp.createTemp('bearfetch-v1-');
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}/bearfetch.sqlite');
    final legacy = sqlite3.open(file.path);
    legacy.execute('''
      CREATE TABLE child_profiles (
        id TEXT NOT NULL PRIMARY KEY,
        parent_id TEXT NULL,
        display_name TEXT NULL,
        created_at INTEGER NOT NULL,
        is_deleted INTEGER NOT NULL DEFAULT 0
      );
      CREATE TABLE activity_progress (
        child_id TEXT NOT NULL,
        activity_id TEXT NOT NULL,
        completed_at INTEGER NULL,
        retry_count INTEGER NOT NULL DEFAULT 0,
        first_answer_json TEXT NULL,
        PRIMARY KEY (child_id, activity_id)
      );
      CREATE TABLE reward_transactions (
        id TEXT NOT NULL PRIMARY KEY,
        child_id TEXT NOT NULL,
        kind TEXT NOT NULL,
        amount INTEGER NOT NULL,
        activity_id TEXT NULL,
        item_id TEXT NULL,
        occurred_at INTEGER NOT NULL
      );
      CREATE TABLE owned_accessories (
        child_id TEXT NOT NULL,
        accessory_id TEXT NOT NULL,
        purchased_at INTEGER NOT NULL,
        PRIMARY KEY (child_id, accessory_id)
      );
      CREATE TABLE sync_queue (
        id TEXT NOT NULL PRIMARY KEY,
        operation TEXT NOT NULL,
        payload_json TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        attempts INTEGER NOT NULL DEFAULT 0
      );
    ''');
    final now = DateTime(2026, 1, 1).millisecondsSinceEpoch;
    legacy.execute(
      "INSERT INTO child_profiles VALUES ('child-1', NULL, 'Maya', $now, 0)",
    );
    legacy.execute(
      "INSERT INTO activity_progress VALUES ('child-1', 'unit-01-01', $now, 2, '{\"discard\":true}')",
    );
    legacy.execute(
      "INSERT INTO reward_transactions VALUES ('reward-1', 'child-1', 'xp', 10, 'unit-01-01', NULL, $now)",
    );
    legacy.execute(
      "INSERT INTO owned_accessories VALUES ('child-1', 'Moon Glasses', $now)",
    );
    legacy.execute(
      "INSERT INTO sync_queue VALUES ('event-1', 'complete_activity', '{}', $now, 1)",
    );
    legacy.execute('PRAGMA user_version = 1');
    legacy.close();

    final database = AppDatabase.forTesting(NativeDatabase(file));
    addTearDown(database.close);
    expect(
      (await database.select(database.learnerProfiles).getSingle()).nickname,
      'Maya',
    );
    final progress = await database
        .select(database.activityProgress)
        .getSingle();
    expect(progress.retryCount, 2);
    expect(progress.completedAt, isNotNull);
    expect(
      (await database.select(database.rewardTransactions).getSingle()).amount,
      10,
    );
    expect(
      (await database.select(database.ownedAccessories).getSingle())
          .accessoryId,
      'Moon Glasses',
    );
    expect(
      (await database.select(database.syncOutbox).getSingle()).attempts,
      1,
    );
    final columns = await database
        .customSelect("PRAGMA table_info('activity_progress')")
        .get();
    expect(
      columns.map((row) => row.read<String>('name')),
      isNot(contains('first_answer_json')),
    );

    final repository = LocalAppRepository(database);
    await repository.ensureSeeded(development: true);
    expect(await database.select(database.learnerProfiles).get(), hasLength(1));
    expect(await repository.balance('xp'), 10);
  });
}
