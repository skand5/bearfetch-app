import 'package:bearfetch_app/core/state/auth_state.dart';
import 'package:bearfetch_app/data/repositories/development_demo_auth_repository.dart';
import 'package:bearfetch_app/domain/repositories/app_repositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fake_auth_repository.dart';
import '../../support/fake_progress_insight_purchase_repository.dart';

void main() {
  test('restores an existing authenticated session', () async {
    final repository = FakeAuthRepository(authenticated: true);
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(repository),
        progressInsightPurchaseRepositoryProvider.overrideWithValue(
          FakeProgressInsightPurchaseRepository(),
        ),
      ],
    );
    addTearDown(container.dispose);
    final state = await container.read(authFlowControllerProvider.future);
    expect(state.status, AuthFlowStatus.authenticated);
  });

  test('requests, verifies, resends, expires, and signs out', () async {
    final repository = FakeAuthRepository(sessionEvents: true);
    final purchases = FakeProgressInsightPurchaseRepository();
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(repository),
        progressInsightPurchaseRepositoryProvider.overrideWithValue(purchases),
      ],
    );
    addTearDown(() async {
      container.dispose();
      await repository.dispose();
    });

    await container.read(authFlowControllerProvider.future);
    final controller = container.read(authFlowControllerProvider.notifier);

    await controller.requestOtp(' Parent@Example.COM ');
    expect(repository.requestedEmails, ['parent@example.com']);
    expect(
      container.read(authFlowControllerProvider).valueOrNull?.status,
      AuthFlowStatus.otpSent,
    );

    await controller.resendOtp();
    expect(repository.requestedEmails, [
      'parent@example.com',
      'parent@example.com',
    ]);

    await controller.verifyOtp('123456');
    expect(repository.verifiedToken, '123456');
    expect(
      container.read(authFlowControllerProvider).valueOrNull?.status,
      AuthFlowStatus.authenticated,
    );

    repository.emit(AuthSessionStatus.expired);
    await Future<void>.delayed(Duration.zero);
    expect(
      container.read(authFlowControllerProvider).valueOrNull?.status,
      AuthFlowStatus.expired,
    );

    await controller.signOut();
    expect(repository.signOutCount, 1);
    expect(purchases.signOutCount, 1);
    expect(
      container.read(authFlowControllerProvider).valueOrNull?.status,
      AuthFlowStatus.signedOut,
    );
  });

  test(
    'development demo login creates a local authenticated session',
    () async {
      var resetCount = 0;
      final repository = DevelopmentDemoAuthRepository(
        resetDemoState: () async => resetCount++,
      );
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(repository),
          progressInsightPurchaseRepositoryProvider.overrideWithValue(
            FakeProgressInsightPurchaseRepository(),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(authFlowControllerProvider.future);
      final controller = container.read(authFlowControllerProvider.notifier);
      await controller.signInDemo();
      final firstSessionUserId = repository.currentUserId;

      expect(repository.hasSession, isTrue);
      expect(resetCount, 1);
      expect(repository.currentEmail, 'demo.parent@bearfetch.invalid');
      expect(firstSessionUserId, startsWith('development-demo-parent-'));
      expect(
        container.read(authFlowControllerProvider).valueOrNull?.status,
        AuthFlowStatus.authenticated,
      );

      await controller.signOut();
      await controller.signInDemo();
      expect(repository.currentUserId, isNot(firstSessionUserId));
      expect(resetCount, 2);
    },
  );
}
