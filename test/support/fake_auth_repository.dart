import 'dart:async';

import 'package:bearfetch_app/domain/repositories/app_repositories.dart';

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({bool authenticated = false, bool sessionEvents = false})
    : _authenticated = authenticated,
      _changes = sessionEvents
          ? StreamController<AuthSessionStatus>.broadcast()
          : null;

  final StreamController<AuthSessionStatus>? _changes;
  final List<String> requestedEmails = [];
  bool _authenticated;
  String? verifiedToken;
  int signOutCount = 0;

  @override
  bool get hasSession => _authenticated;

  @override
  bool get requiresAuthentication => true;

  @override
  String? get currentUserId => _authenticated ? 'test-user' : null;

  @override
  String? get currentEmail => _authenticated ? 'parent@example.com' : null;

  @override
  Stream<AuthSessionStatus> get sessionChanges =>
      _changes?.stream ?? const Stream.empty();

  @override
  Future<void> requestEmailOtp(String email) async {
    requestedEmails.add(email);
  }

  @override
  Future<void> verifyEmailOtp({
    required String email,
    required String token,
  }) async {
    verifiedToken = token;
    _authenticated = true;
  }

  @override
  Future<void> signOut() async {
    signOutCount += 1;
    _authenticated = false;
  }

  void emit(AuthSessionStatus status) {
    _authenticated = status == AuthSessionStatus.authenticated;
    _changes?.add(status);
  }

  Future<void> dispose() => _changes?.close() ?? Future<void>.value();
}
