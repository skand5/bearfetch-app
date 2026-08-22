import 'dart:async';

import 'package:sentry_flutter/sentry_flutter.dart';

import '../config/app_config.dart';

/// Runtime gate for crash-only Sentry reporting.
abstract final class SentryConsentGate {
  static bool _isActive = false;

  static void setActive(bool value) => _isActive = value;

  static bool get isActive => _isActive;
}

/// Removes all optional fields which could hold user-provided content.
SentryEvent? sanitizeSentryEvent(SentryEvent event) {
  if (!SentryConsentGate.isActive) return null;

  return SentryEvent(
    eventId: event.eventId,
    timestamp: event.timestamp,
    platform: event.platform,
    logger: event.logger,
    release: event.release,
    dist: event.dist,
    environment: event.environment,
    level: event.level,
    exceptions: event.exceptions,
    threads: event.threads,
    debugMeta: event.debugMeta,
    type: event.type,
  );
}

Future<void> initializeSentry(FutureOr<void> Function() appRunner) async {
  if (AppConfig.sentryDsn.isEmpty) {
    await appRunner();
    return;
  }

  await SentryFlutter.init((options) {
    options.dsn = AppConfig.sentryDsn;
    options.environment = AppConfig.sentryEnvironment;
    options.sendDefaultPii = false;
    options.enableAutoSessionTracking = false;
    options.enableAutoPerformanceTracing = false;
    options.tracesSampleRate = 0;
    // ignore: experimental_member_use
    options.profilesSampleRate = 0;
    options.attachScreenshot = false;
    options.enablePrintBreadcrumbs = false;
    options.beforeBreadcrumb = (breadcrumb, hint) => null;
    options.beforeSend = (event, hint) => sanitizeSentryEvent(event);
  }, appRunner: appRunner);
}
