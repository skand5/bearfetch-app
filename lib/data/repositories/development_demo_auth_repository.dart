import 'dart:async';

import '../../domain/repositories/app_repositories.dart';

/// A development-only, local demo session.
///
/// It is selected by bootstrap only for `APP_ENV=development`, has no network
/// implementation, and must never be used by a production build.
class DevelopmentDemoAuthRepository implements AuthRepository {
  DevelopmentDemoAuthRepository({
    required Future<void> Function() resetDemoState,
  }) : _resetDemoState = resetDemoState;

  static const demoUserId = 'development-demo-parent';
  static const demoEmail = 'demo.parent@bearfetch.invalid';

  final Future<void> Function() _resetDemoState;
  final _changes = StreamController<AuthSessionStatus>.broadcast();
  bool _hasSession = false;

  @override
  bool get requiresAuthentication => true;

  @override
  bool get supportsDemoLogin => true;

  @override
  bool get hasSession => _hasSession;

  @override
  String? get currentUserId => _hasSession ? demoUserId : null;

  @override
  String? get currentEmail => _hasSession ? demoEmail : null;

  @override
  Stream<AuthSessionStatus> get sessionChanges => _changes.stream;

  @override
  Future<void> requestEmailOtp(String email) => Future.error(
    UnsupportedError('Use the development demo account instead.'),
  );

  @override
  Future<void> verifyEmailOtp({required String email, required String token}) =>
      Future.error(UnsupportedError('Use the development demo account.'));

  @override
  Future<void> signInDemo() async {
    await _resetDemoState();
    _hasSession = true;
    _changes.add(AuthSessionStatus.authenticated);
  }

  @override
  Future<void> signOut() async {
    _hasSession = false;
    _changes.add(AuthSessionStatus.signedOut);
  }
}
