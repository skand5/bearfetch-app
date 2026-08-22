import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repositories/app_repositories.dart';
import '../local/app_database.dart';

class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository(this.client);

  final SupabaseClient client;

  @override
  bool get requiresAuthentication => true;

  @override
  bool get hasSession => client.auth.currentSession != null;

  @override
  String? get currentUserId => client.auth.currentUser?.id;

  @override
  String? get currentEmail => client.auth.currentUser?.email;

  @override
  Stream<AuthSessionStatus> get sessionChanges => client.auth.onAuthStateChange
      .map(
        (event) =>
            event.event == AuthChangeEvent.signedOut || event.session == null
            ? AuthSessionStatus.signedOut
            : AuthSessionStatus.authenticated,
      )
      .distinct();

  @override
  Future<void> requestEmailOtp(String email) => client.auth.signInWithOtp(
    email: email.trim().toLowerCase(),
    shouldCreateUser: true,
  );

  @override
  Future<void> verifyEmailOtp({
    required String email,
    required String token,
  }) async {
    final response = await client.auth.verifyOTP(
      email: email.trim().toLowerCase(),
      token: token,
      type: OtpType.email,
    );
    if (response.session == null || response.user == null) {
      throw const AuthException('OTP verification did not create a session.');
    }
  }

  @override
  Future<void> signOut() => client.auth.signOut(scope: SignOutScope.local);
}

class SupabaseParentRepository implements ParentRepository {
  SupabaseParentRepository(this.local, this.client);

  final ParentRepository local;
  final SupabaseClient client;

  @override
  Future<ParentProfile?> getParent() => local.getParent();

  @override
  Future<void> saveParentName(String name) async {
    await local.saveParentName(name);
    final userId = client.auth.currentUser?.id;
    if (userId == null) return;
    await client
        .from('parents')
        .update({'display_name': name.trim()})
        .eq('id', userId);
  }
}

class SupabaseLearnerRepository implements LearnerRepository {
  SupabaseLearnerRepository(this.local, this.client);

  final LearnerRepository local;
  final SupabaseClient client;

  @override
  Future<LearnerProfile?> getLearner() => local.getLearner();

  @override
  Future<void> saveLearner({
    required String nickname,
    required String ageBand,
    required String language,
  }) async {
    await local.saveLearner(
      nickname: nickname,
      ageBand: ageBand,
      language: language,
    );
    final userId = client.auth.currentUser?.id;
    if (userId == null) return;
    await client.from('learners').upsert({
      'parent_id': userId,
      'nickname': nickname.trim(),
      'avatar_id': 'astronaut-bear',
      'age_band': ageBand,
      'language': language,
    }, onConflict: 'parent_id');
  }
}

class SupabaseConsentRepository implements ConsentRepository {
  SupabaseConsentRepository(this.local, this.client);

  static const consentVersion = 'bearfetch-parent-consent-v1';
  static const noticeVersion = 'bearfetch-direct-notice-v1';

  final ConsentRepository local;
  final SupabaseClient client;

  @override
  Future<bool> hasActiveConsent() => local.hasActiveConsent();

  @override
  Future<void> approveLocalConsent() async {
    if (client.auth.currentUser == null) {
      throw const AuthException('Authentication required for consent.');
    }
    await client.rpc(
      'record_parent_consent',
      params: {
        'consent_version': consentVersion,
        'notice_version': noticeVersion,
      },
    );
    await local.approveLocalConsent();
  }
}
