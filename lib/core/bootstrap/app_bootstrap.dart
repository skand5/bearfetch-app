import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/app_database.dart';
import '../../data/repositories/local_app_repository.dart';
import '../../domain/content/course_catalog.dart';
import '../../domain/repositories/app_repositories.dart';
import '../config/app_config.dart';
import '../theme/bearfetch_theme.dart';
import '../../app.dart';

enum StartupStatus { ready, recoverableSyncFailure, expiredSession }

enum BootstrapFailureKind { contentValidation, localMigration }

class BootstrapFailure implements Exception {
  const BootstrapFailure(this.kind, this.cause);
  final BootstrapFailureKind kind;
  final Object cause;
}

class BootstrapDependencies {
  const BootstrapDependencies({
    required this.database,
    required this.repository,
    required this.catalog,
    required this.status,
    this.syncWarning,
  });

  final AppDatabase database;
  final LocalAppRepository repository;
  final CourseCatalog catalog;
  final StartupStatus status;
  final String? syncWarning;
}

final bootstrapDependenciesProvider = FutureProvider<BootstrapDependencies>((
  ref,
) async {
  late final CourseCatalog catalog;
  try {
    catalog = await CourseCatalog.loadFromAssets();
  } catch (error) {
    throw BootstrapFailure(BootstrapFailureKind.contentValidation, error);
  }

  final database = AppDatabase();
  final repository = LocalAppRepository(database);
  try {
    await repository.ensureSeeded(
      development: AppConfig.environment == AppEnvironment.development,
    );
    final syncWarning = await repository.lastRecoverableError();
    return BootstrapDependencies(
      database: database,
      repository: repository,
      catalog: catalog,
      status: syncWarning == null
          ? StartupStatus.ready
          : StartupStatus.recoverableSyncFailure,
      syncWarning: syncWarning,
    );
  } catch (error) {
    await database.close();
    throw BootstrapFailure(BootstrapFailureKind.localMigration, error);
  }
});

class BearfetchBootstrapApp extends ConsumerWidget {
  const BearfetchBootstrapApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bootstrap = ref.watch(bootstrapDependenciesProvider);
    return bootstrap.when(
      loading: () =>
          const _StartupFrame(child: CircularProgressIndicator.adaptive()),
      error: (error, stackTrace) => _StartupFailure(error: error),
      data: (dependencies) {
        if (dependencies.status == StartupStatus.expiredSession) {
          return const _StartupFrame(
            child: Text('Your session expired. Sign in again.'),
          );
        }
        return ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(dependencies.database),
            courseCatalogProvider.overrideWithValue(dependencies.catalog),
            authRepositoryProvider.overrideWithValue(dependencies.repository),
            parentRepositoryProvider.overrideWithValue(dependencies.repository),
            learnerRepositoryProvider.overrideWithValue(
              dependencies.repository,
            ),
            consentRepositoryProvider.overrideWithValue(
              dependencies.repository,
            ),
            progressRepositoryProvider.overrideWithValue(
              dependencies.repository,
            ),
            rewardsRepositoryProvider.overrideWithValue(
              dependencies.repository,
            ),
            shopRepositoryProvider.overrideWithValue(dependencies.repository),
            syncRepositoryProvider.overrideWithValue(dependencies.repository),
            privacyRepositoryProvider.overrideWithValue(
              dependencies.repository,
            ),
          ],
          child: BearfetchApp(syncWarning: dependencies.syncWarning),
        );
      },
    );
  }
}

class _StartupFailure extends ConsumerWidget {
  const _StartupFailure({required this.error});
  final Object error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final failure = error is BootstrapFailure
        ? error as BootstrapFailure
        : BootstrapFailure(BootstrapFailureKind.localMigration, error);
    final message = switch (failure.kind) {
      BootstrapFailureKind.contentValidation =>
        'Course content could not be loaded.',
      BootstrapFailureKind.localMigration =>
        'Local learning data could not be opened.',
    };
    return _StartupFrame(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => ref.invalidate(bootstrapDependenciesProvider),
            child: const Text('Try again'),
          ),
        ],
      ),
    );
  }
}

class _StartupFrame extends StatelessWidget {
  const _StartupFrame({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: BearfetchTheme.materialTheme(),
    home: Scaffold(
      backgroundColor: const Color(0xFFFFF8EF),
      body: Center(child: child),
    ),
  );
}
