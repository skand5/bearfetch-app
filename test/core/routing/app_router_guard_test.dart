import 'package:bearfetch_app/core/routing/app_router.dart';
import 'package:bearfetch_app/core/state/app_state.dart';
import 'package:bearfetch_app/core/state/auth_state.dart';
import 'package:bearfetch_app/domain/content/course_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late CourseCatalog catalog;

  setUpAll(() async {
    catalog = await CourseCatalog.loadFromAssets();
  });

  test('credential-free prototype routes are not guarded', () {
    expect(
      resolveRouteRedirect(
        requiresAuthentication: false,
        auth: const AuthFlowState(status: AuthFlowStatus.signedOut),
        appState: null,
        path: '/home',
      ),
      isNull,
    );
  });

  test('signed-out and expired sessions are sent to onboarding', () {
    for (final status in [AuthFlowStatus.signedOut, AuthFlowStatus.expired]) {
      expect(
        resolveRouteRedirect(
          requiresAuthentication: true,
          auth: AuthFlowState(status: status),
          appState: null,
          path: '/home',
        ),
        '/onboarding',
      );
    }
  });

  test('signed-out users may enter email and OTP routes', () {
    for (final path in ['/onboarding', '/signup/account', '/signup/verify']) {
      expect(
        resolveRouteRedirect(
          requiresAuthentication: true,
          auth: const AuthFlowState(status: AuthFlowStatus.signedOut),
          appState: null,
          path: path,
        ),
        isNull,
      );
    }
  });

  test('authenticated user without learner enters learner setup', () {
    for (final path in ['/home', '/signup/approval']) {
      expect(
        resolveRouteRedirect(
          requiresAuthentication: true,
          auth: const AuthFlowState(status: AuthFlowStatus.authenticated),
          appState: AppViewState.loading(catalog),
          path: path,
        ),
        '/signup/learner',
      );
    }
  });

  test('authenticated learner without consent enters approval', () {
    expect(
      resolveRouteRedirect(
        requiresAuthentication: true,
        auth: const AuthFlowState(status: AuthFlowStatus.authenticated),
        appState: _appState(catalog, parentApproved: false),
        path: '/home',
      ),
      '/signup/approval',
    );
  });

  test('authenticated configured family leaves setup for home', () {
    expect(
      resolveRouteRedirect(
        requiresAuthentication: true,
        auth: const AuthFlowState(status: AuthFlowStatus.authenticated),
        appState: _appState(catalog, parentApproved: true),
        path: '/signup/verify',
      ),
      '/home',
    );
    expect(
      resolveRouteRedirect(
        requiresAuthentication: true,
        auth: const AuthFlowState(status: AuthFlowStatus.authenticated),
        appState: _appState(catalog, parentApproved: true),
        path: '/courses',
      ),
      isNull,
    );
  });

  test('withdrawn consent and pending deletion cannot bypass restrictions', () {
    final withdrawn = _appState(
      catalog,
      parentApproved: true,
      consentStatus: 'withdrawn',
    );
    final pending = _appState(
      catalog,
      parentApproved: true,
      pendingDeletion: true,
    );
    for (final state in [withdrawn, pending]) {
      expect(
        resolveRouteRedirect(
          requiresAuthentication: true,
          auth: const AuthFlowState(status: AuthFlowStatus.authenticated),
          appState: state,
          path: '/signup/approval',
        ),
        startsWith('/access-restricted'),
      );
      expect(
        resolveRouteRedirect(
          requiresAuthentication: true,
          auth: const AuthFlowState(status: AuthFlowStatus.authenticated),
          appState: state,
          path: '/parent-settings',
        ),
        isNull,
      );
    }
  });
}

AppViewState _appState(
  CourseCatalog catalog, {
  required bool parentApproved,
  String? consentStatus,
  bool pendingDeletion = false,
}) {
  final loading = AppViewState.loading(catalog);
  return AppViewState(
    parentName: 'Parent',
    hasParent: true,
    learnerName: 'Max',
    hasLearner: true,
    ageRange: loading.ageRange,
    language: loading.language,
    parentApproved: parentApproved,
    consentStatus: consentStatus ?? (parentApproved ? 'active' : 'none'),
    hasPendingDeletion: pendingDeletion,
    completedActivityIds: loading.completedActivityIds,
    completedSteps: loading.completedSteps,
    nextCourseRoute: loading.nextCourseRoute,
    honey: loading.honey,
    xp: loading.xp,
    achievements: loading.achievements,
    ownedAccessories: loading.ownedAccessories,
    equippedAccessories: loading.equippedAccessories,
    pendingSyncEvents: loading.pendingSyncEvents,
    syncWarning: loading.syncWarning,
  );
}
