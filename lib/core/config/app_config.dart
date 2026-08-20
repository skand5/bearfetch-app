enum AppEnvironment { development, production }

/// Compile-time configuration injected with `--dart-define`.
///
/// Public client values belong here. Service-role keys, SMTP credentials,
/// signing passwords, and Sentry auth tokens must never enter the app binary.
abstract final class AppConfig {
  static const environmentName = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'development',
  );
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  static const sentryDsn = String.fromEnvironment('SENTRY_DSN');
  static const sentryEnvironment = String.fromEnvironment('SENTRY_ENVIRONMENT');

  static AppEnvironment get environment => switch (environmentName) {
    'development' => AppEnvironment.development,
    'production' => AppEnvironment.production,
    _ => throw StateError('Unsupported APP_ENV: $environmentName'),
  };

  static bool get hasSupabaseConfiguration =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  static void validate() => validateValues(
    environmentName: environmentName,
    supabaseUrl: supabaseUrl,
    supabaseAnonKey: supabaseAnonKey,
    sentryDsn: sentryDsn,
    sentryEnvironment: sentryEnvironment,
  );

  static void validateValues({
    required String environmentName,
    required String supabaseUrl,
    required String supabaseAnonKey,
    required String sentryDsn,
    required String sentryEnvironment,
  }) {
    if (environmentName != 'development' && environmentName != 'production') {
      throw StateError('APP_ENV must be development or production.');
    }

    final hasUrl = supabaseUrl.isNotEmpty;
    final hasKey = supabaseAnonKey.isNotEmpty;
    if (hasUrl != hasKey) {
      throw StateError(
        'SUPABASE_URL and SUPABASE_ANON_KEY must be provided together.',
      );
    }

    if (environmentName == 'production') {
      final missing = <String>[
        if (!hasUrl) 'SUPABASE_URL',
        if (!hasKey) 'SUPABASE_ANON_KEY',
        if (sentryDsn.isEmpty) 'SENTRY_DSN',
        if (sentryEnvironment.isEmpty) 'SENTRY_ENVIRONMENT',
      ];
      if (missing.isNotEmpty) {
        throw StateError(
          'Missing production build values: ${missing.join(', ')}.',
        );
      }
    }
  }
}
