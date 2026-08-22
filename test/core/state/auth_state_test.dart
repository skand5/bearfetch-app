import 'package:bearfetch_app/core/state/auth_state.dart';
import 'package:bearfetch_app/domain/repositories/app_repositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fake_auth_repository.dart';

void main() {
  test('restores an existing authenticated session', () async {
    final repository = FakeAuthRepository(authenticated: true);
    final container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
    final state = await container.read(authFlowControllerProvider.future);
    expect(state.status, AuthFlowStatus.authenticated);
  });

  test('requests, verifies, resends, expires, and signs out', () async {
    final repository = FakeAuthRepository(sessionEvents: true);
    final container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
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
    expect(
      container.read(authFlowControllerProvider).valueOrNull?.status,
      AuthFlowStatus.signedOut,
    );
  });
}
