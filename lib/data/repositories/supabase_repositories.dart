import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repositories/app_repositories.dart';
import '../local/app_database.dart';
import 'local_app_repository.dart';

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
  Future<String> consentStatus() => local.consentStatus();

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

class SupabaseSyncRepository implements SyncRepository {
  SupabaseSyncRepository(this.local, this.client, this.auth);

  final LocalAppRepository local;
  final SupabaseClient client;
  final AuthRepository auth;

  @override
  Future<int> pendingEventCount() => local.pendingEventCount();

  @override
  Future<String?> lastRecoverableError() => local.lastRecoverableError();

  @override
  Future<SyncRunResult> syncNow() async {
    if (!auth.hasSession) {
      return const SyncRunResult(
        status: SyncRunStatus.skipped,
        message: 'Sign in to sync your family data.',
      );
    }
    var completedEvents = 0;
    for (final event in await local.pendingSyncEvents()) {
      try {
        await _send(event.operation, event.eventId, event.payloadJson);
        await local.markSyncEventSucceeded(event.eventId);
        completedEvents += 1;
      } catch (error) {
        await local.markSyncEventFailed(event.eventId, error);
        return SyncRunResult(
          status: SyncRunStatus.failed,
          completedEvents: completedEvents,
          message: 'Sync will retry automatically when available.',
        );
      }
    }
    try {
      await reconcile();
      return SyncRunResult(
        status: SyncRunStatus.synced,
        completedEvents: completedEvents,
      );
    } catch (error) {
      return SyncRunResult(
        status: SyncRunStatus.failed,
        completedEvents: completedEvents,
        message: 'Changes saved on this device; remote refresh will retry.',
      );
    }
  }

  Future<void> reconcile() async {
    if (!auth.hasSession) return;
    final parentId = auth.currentUserId;
    if (parentId == null) return;
    final learnerRows = _maps(
      await client.from('learners').select().eq('parent_id', parentId).limit(1),
    );
    if (learnerRows.isEmpty) return;
    final learner = learnerRows.single;
    final learnerId = learner['id']! as String;
    final parent = _singleMap(
      await client.from('parents').select().eq('id', parentId).single(),
    );
    await local.replaceWithRemoteSnapshot(
      parent: parent,
      learner: learner,
      consents: _maps(
        await client
            .from('consent_records')
            .select()
            .eq('parent_id', parentId)
            .order('updated_at'),
      ),
      progress: _maps(
        await client
            .from('activity_progress')
            .select()
            .eq('learner_id', learnerId),
      ),
      rewards: _maps(
        await client
            .from('reward_transactions')
            .select()
            .eq('learner_id', learnerId),
      ),
      achievements: _maps(
        await client.from('achievements').select().eq('learner_id', learnerId),
      ),
      ownedAccessories: _maps(
        await client
            .from('owned_accessories')
            .select()
            .eq('learner_id', learnerId),
      ),
      equippedAccessories: _maps(
        await client
            .from('equipped_accessories')
            .select()
            .eq('learner_id', learnerId),
      ),
      deletionRequests: _maps(
        await client
            .from('deletion_requests')
            .select()
            .eq('parent_id', parentId),
      ),
    );
  }

  Future<void> _send(
    String operation,
    String eventId,
    String payloadJson,
  ) async {
    final payload = jsonDecode(payloadJson) as Map<String, dynamic>;
    switch (operation) {
      case 'complete_activity':
        await client.rpc(
          'complete_activity',
          params: {'activity_id': payload['activityId'], 'event_id': eventId},
        );
      case 'complete_course':
        await client.rpc('complete_course', params: {'event_id': eventId});
      case 'purchase_accessory':
        await client.rpc(
          'purchase_accessory',
          params: {'accessory_id': payload['accessoryId'], 'event_id': eventId},
        );
      case 'equip_accessory':
        await client.rpc(
          'equip_accessory',
          params: {'accessory_id': payload['accessoryId'], 'event_id': eventId},
        );
      case 'withdraw_consent':
        await client.rpc('withdraw_consent', params: {'event_id': eventId});
      case 'schedule_deletion':
        await client.rpc(
          'schedule_deletion',
          params: {
            'target': payload['target'],
            'event_id': eventId,
            'request_id': payload['requestId'],
          },
        );
      case 'cancel_deletion':
        await client.rpc(
          'cancel_deletion',
          params: {'request_id': payload['requestId'], 'event_id': eventId},
        );
      default:
        throw StateError('Unknown sync operation.');
    }
  }
}

class SupabasePrivacyRepository implements PrivacyRepository {
  SupabasePrivacyRepository(this.local, this.client);

  final LocalAppRepository local;
  final SupabaseClient client;

  @override
  Future<Map<String, Object?>> exportLocalData() => local.exportLocalData();

  @override
  Future<void> withdrawConsent() async {
    await local.withdrawConsent();
  }

  @override
  Future<DeletionRequestState> deletionRequestState() =>
      local.deletionRequestState();

  @override
  Future<DeletionRequestState> scheduleDeletion(DeletionTarget target) =>
      local.scheduleDeletion(target);

  @override
  Future<void> cancelDeletion(String requestId) =>
      local.cancelDeletion(requestId);
}

Map<String, Object?> _singleMap(dynamic value) =>
    Map<String, Object?>.from(value as Map);

List<Map<String, Object?>> _maps(dynamic value) => (value as List)
    .map((row) => Map<String, Object?>.from(row as Map))
    .toList(growable: false);
