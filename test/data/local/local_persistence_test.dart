import 'dart:io';

import 'package:bearfetch_app/data/local/app_database.dart';
import 'package:bearfetch_app/data/repositories/local_app_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'profile, progress, rewards, and equipment survive database restart',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'bearfetch-restart-',
      );
      addTearDown(() => directory.delete(recursive: true));
      final file = File('${directory.path}/bearfetch.sqlite');

      var database = AppDatabase.forTesting(NativeDatabase(file));
      var repository = LocalAppRepository(database);
      await repository.ensureSeeded(development: true);
      await repository.saveLearner(
        nickname: 'Maya',
        ageBand: '6–11 yr',
        language: 'English',
      );
      await repository.completeActivity(
        activityId: 'unit-01-01',
        rewardId: 'activity-unit-01-01',
      );
      await repository.purchase(accessoryId: 'Star Cap', price: 25);
      await repository.equip(accessoryId: 'Star Cap', slot: 'featured');
      await database.close();

      database = AppDatabase.forTesting(NativeDatabase(file));
      repository = LocalAppRepository(database);
      addTearDown(database.close);
      await repository.ensureSeeded(development: true);

      expect((await repository.getLearner())?.nickname, 'Maya');
      expect(await repository.completedActivityIds(), {'unit-01-01'});
      expect(await repository.balance('xp'), 350);
      expect(await repository.balance('honey'), 108);
      expect(await repository.ownedAccessoryIds(), contains('Star Cap'));
      expect(await repository.equippedAccessories(), {'featured': 'Star Cap'});
    },
  );
}
