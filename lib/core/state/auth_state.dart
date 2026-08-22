import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/app_repositories.dart';

enum AuthFlowStatus { signedOut, otpSent, authenticated, expired }

class AuthFlowState {
  const AuthFlowState({required this.status, this.pendingEmail});

  final AuthFlowStatus status;
  final String? pendingEmail;

  bool get isAuthenticated => status == AuthFlowStatus.authenticated;
}

final authFlowControllerProvider =
    AsyncNotifierProvider<AuthFlowController, AuthFlowState>(
      AuthFlowController.new,
    );

class AuthFlowController extends AsyncNotifier<AuthFlowState> {
  StreamSubscription<AuthSessionStatus>? _subscription;

  @override
  Future<AuthFlowState> build() async {
    final repository = ref.read(authRepositoryProvider);
    _subscription = repository.sessionChanges.listen(_applySessionStatus);
    ref.onDispose(() => _subscription?.cancel());
    return AuthFlowState(
      status: repository.hasSession
          ? AuthFlowStatus.authenticated
          : AuthFlowStatus.signedOut,
      pendingEmail: repository.currentEmail,
    );
  }

  void _applySessionStatus(AuthSessionStatus status) {
    final current = state.valueOrNull;
    state = AsyncData(
      AuthFlowState(
        status: switch (status) {
          AuthSessionStatus.signedOut => AuthFlowStatus.signedOut,
          AuthSessionStatus.authenticated => AuthFlowStatus.authenticated,
          AuthSessionStatus.expired => AuthFlowStatus.expired,
        },
        pendingEmail: status == AuthSessionStatus.signedOut
            ? null
            : current?.pendingEmail ??
                  ref.read(authRepositoryProvider).currentEmail,
      ),
    );
  }

  Future<void> requestOtp(String email) async {
    final normalizedEmail = email.trim().toLowerCase();
    state = const AsyncLoading<AuthFlowState>().copyWithPrevious(state);
    try {
      await ref.read(authRepositoryProvider).requestEmailOtp(normalizedEmail);
      state = AsyncData(
        AuthFlowState(
          status: AuthFlowStatus.otpSent,
          pendingEmail: normalizedEmail,
        ),
      );
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> verifyOtp(String token) async {
    final email = state.valueOrNull?.pendingEmail;
    if (email == null) throw StateError('Request a new email code.');
    state = const AsyncLoading<AuthFlowState>().copyWithPrevious(state);
    try {
      await ref
          .read(authRepositoryProvider)
          .verifyEmailOtp(email: email, token: token);
      state = AsyncData(
        AuthFlowState(
          status: AuthFlowStatus.authenticated,
          pendingEmail: email,
        ),
      );
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> resendOtp() async {
    final email = state.valueOrNull?.pendingEmail;
    if (email == null) throw StateError('Enter your email again.');
    await requestOtp(email);
  }

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    state = const AsyncData(AuthFlowState(status: AuthFlowStatus.signedOut));
  }
}
