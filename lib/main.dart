import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/widgets.dart';

import 'core/config/app_config.dart';
import 'core/bootstrap/app_bootstrap.dart';

export 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.validate();
  runApp(const ProviderScope(child: BearfetchBootstrapApp()));
}
