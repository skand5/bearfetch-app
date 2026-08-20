/// Values are injected at build/run time, never committed as secrets.
abstract final class AppConfig {
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  static bool get hasSupabaseConfiguration =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
}
