import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/routing/app_router.dart';
import 'core/state/app_state.dart';
import 'core/state/sync_state.dart';
import 'core/state/sync_triggers.dart';
import 'core/theme/bearfetch_theme.dart';
import 'core/observability/sentry_observability.dart';

class BearfetchApp extends ConsumerWidget {
  const BearfetchApp({super.key, this.syncWarning});

  final String? syncWarning;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appStateControllerProvider).valueOrNull;
    SentryConsentGate.setActive(
      appState?.parentApproved == true &&
          appState?.hasPendingDeletion != true &&
          appState?.consentStatus != 'withdrawn',
    );
    ref.watch(syncControllerProvider);
    return SyncTriggers(
      child: MaterialApp.router(
        title: 'BearFetch',
        theme: BearfetchTheme.materialTheme(),
        routerConfig: ref.watch(appRouterProvider),
        builder: (context, child) => syncWarning == null
            ? child!
            : Column(
                children: [
                  MaterialBanner(
                    content: Text(syncWarning!),
                    actions: const [SizedBox.shrink()],
                  ),
                  Expanded(child: child!),
                ],
              ),
      ),
    );
  }
}
