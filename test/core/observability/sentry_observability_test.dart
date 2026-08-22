import 'package:bearfetch_app/core/observability/sentry_observability.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() {
  test('Sentry drops every event before consent', () {
    SentryConsentGate.setActive(false);
    expect(
      sanitizeSentryEvent(SentryEvent(message: SentryMessage('name'))),
      isNull,
    );
  });

  test('Sentry strips user content, request, extras and breadcrumbs', () {
    SentryConsentGate.setActive(true);
    final event = SentryEvent(
      message: SentryMessage('learner supplied text'),
      user: SentryUser(email: 'parent@example.com'),
      request: SentryRequest(url: 'https://example.test/private'),
      breadcrumbs: [Breadcrumb(message: 'form input')],
      // ignore: deprecated_member_use
      extra: const {'learner': 'Max'},
    );
    final sanitized = sanitizeSentryEvent(event)!;

    expect(sanitized.message, isNull);
    expect(sanitized.user, isNull);
    expect(sanitized.request, isNull);
    // ignore: deprecated_member_use
    expect(sanitized.extra, isNull);
    expect(sanitized.breadcrumbs, isNull);
  });
}
