import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:flutter/widgets.dart';

import 'core/config/app_config.dart';
import 'core/bootstrap/app_bootstrap.dart';

export 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.validate();
  if (AppConfig.hasSupabaseConfiguration) {
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      publishableKey: AppConfig.supabaseAnonKey,
    );
  }
  runApp(const ProviderScope(child: BearfetchBootstrapApp()));
}
