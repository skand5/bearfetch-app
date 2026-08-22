import 'package:bearfetch_app/data/local/app_database.dart';
import 'package:bearfetch_app/data/repositories/local_app_repository.dart';
import 'package:bearfetch_app/domain/content/course_catalog.dart';
import 'package:bearfetch_app/domain/repositories/app_repositories.dart';
import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestHarness {
  TestHarness({
    required this.database,
    required this.repository,
    required this.catalog,
  });

  final AppDatabase database;
  final LocalAppRepository repository;
  final CourseCatalog catalog;

  static Future<TestHarness> create({bool development = true}) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = LocalAppRepository(database);
    await repository.ensureSeeded(development: development);
    return TestHarness(
      database: database,
      repository: repository,
      catalog: await CourseCatalog.loadFromAssets(),
    );
  }

  Widget wrap(Widget child, {AuthRepository? authRepository}) => ProviderScope(
    overrides: [
      appDatabaseProvider.overrideWithValue(database),
      courseCatalogProvider.overrideWithValue(catalog),
      authRepositoryProvider.overrideWithValue(authRepository ?? repository),
      parentRepositoryProvider.overrideWithValue(repository),
      learnerRepositoryProvider.overrideWithValue(repository),
      consentRepositoryProvider.overrideWithValue(repository),
      progressRepositoryProvider.overrideWithValue(repository),
      rewardsRepositoryProvider.overrideWithValue(repository),
      shopRepositoryProvider.overrideWithValue(repository),
      syncRepositoryProvider.overrideWithValue(repository),
      privacyRepositoryProvider.overrideWithValue(repository),
    ],
    child: child,
  );

  Future<void> dispose() => database.close();
}
