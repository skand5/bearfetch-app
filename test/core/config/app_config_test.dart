import 'package:bearfetch_app/core/config/app_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppConfig.validateValues', () {
    test('allows credential-free development builds', () {
      expect(
        () => AppConfig.validateValues(
          environmentName: 'development',
          supabaseUrl: '',
          supabaseAnonKey: '',
          sentryDsn: '',
          sentryEnvironment: 'development',
        ),
        returnsNormally,
      );
    });

    test('rejects partial Supabase configuration', () {
      expect(
        () => AppConfig.validateValues(
          environmentName: 'development',
          supabaseUrl: 'http://127.0.0.1:54321',
          supabaseAnonKey: '',
          sentryDsn: '',
          sentryEnvironment: 'development',
        ),
        throwsStateError,
      );
    });

    test('requires all production build values', () {
      expect(
        () => AppConfig.validateValues(
          environmentName: 'production',
          supabaseUrl: '',
          supabaseAnonKey: '',
          sentryDsn: '',
          sentryEnvironment: '',
        ),
        throwsStateError,
      );
    });

    test('accepts complete production configuration', () {
      expect(
        () => AppConfig.validateValues(
          environmentName: 'production',
          supabaseUrl: 'https://example.supabase.co',
          supabaseAnonKey: 'public-anon-key',
          sentryDsn: 'https://public@example.ingest.sentry.io/1',
          sentryEnvironment: 'production',
        ),
        returnsNormally,
      );
    });
  });
}
