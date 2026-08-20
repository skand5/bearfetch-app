import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/app_config.dart';
import 'core/routing/app_router.dart';
import 'core/theme/bearfetch_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.validate();
  runApp(const ProviderScope(child: BearfetchApp()));
}

class BearfetchApp extends ConsumerWidget {
  const BearfetchApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp.router(
    title: 'BearFetch',
    theme: BearfetchTheme.materialTheme(),
    routerConfig: ref.watch(appRouterProvider),
  );
}
