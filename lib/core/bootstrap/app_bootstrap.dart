import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/local/app_database.dart';
import '../../data/repositories/local_app_repository.dart';
import '../../data/repositories/supabase_repositories.dart';
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
    required this.authRepository,
    required this.parentRepository,
    required this.learnerRepository,
    required this.consentRepository,
    required this.catalog,
    required this.status,
    this.syncWarning,
  });

  final AppDatabase database;
  final LocalAppRepository repository;
  final AuthRepository authRepository;
  final ParentRepository parentRepository;
  final LearnerRepository learnerRepository;
  final ConsentRepository consentRepository;
  final CourseCatalog catalog;
  final StartupStatus status;
  final String? syncWarning;
}

Future<BootstrapDependencies> createBootstrapDependencies() async {
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
    final client = AppConfig.hasSupabaseConfiguration
        ? Supabase.instance.client
        : null;
    return BootstrapDependencies(
      database: database,
      repository: repository,
      authRepository: client == null
          ? repository
          : SupabaseAuthRepository(client),
      parentRepository: client == null
          ? repository
          : SupabaseParentRepository(repository, client),
      learnerRepository: client == null
          ? repository
          : SupabaseLearnerRepository(repository, client),
      consentRepository: client == null
          ? repository
          : SupabaseConsentRepository(repository, client),
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
}

final bootstrapDependenciesProvider = FutureProvider<BootstrapDependencies>(
  (ref) => createBootstrapDependencies(),
);

List<Override> bootstrapOverrides(BootstrapDependencies dependencies) => [
  appDatabaseProvider.overrideWithValue(dependencies.database),
  courseCatalogProvider.overrideWithValue(dependencies.catalog),
  authRepositoryProvider.overrideWithValue(dependencies.authRepository),
  parentRepositoryProvider.overrideWithValue(dependencies.parentRepository),
  learnerRepositoryProvider.overrideWithValue(dependencies.learnerRepository),
  consentRepositoryProvider.overrideWithValue(dependencies.consentRepository),
  progressRepositoryProvider.overrideWithValue(dependencies.repository),
  rewardsRepositoryProvider.overrideWithValue(dependencies.repository),
  shopRepositoryProvider.overrideWithValue(dependencies.repository),
  syncRepositoryProvider.overrideWithValue(
    AppConfig.hasSupabaseConfiguration
        ? SupabaseSyncRepository(
            dependencies.repository,
            Supabase.instance.client,
            dependencies.authRepository,
          )
        : dependencies.repository,
  ),
  privacyRepositoryProvider.overrideWithValue(
    AppConfig.hasSupabaseConfiguration
        ? SupabasePrivacyRepository(
            dependencies.repository,
            Supabase.instance.client,
          )
        : dependencies.repository,
  ),
];

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
          overrides: bootstrapOverrides(dependencies),
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
