import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/course/presentation/activity_result_screen.dart';
import '../../features/course/presentation/course_activity_screen.dart';
import '../../features/course/presentation/course_completion_screen.dart';
import '../../features/courses/presentation/courses_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/onboarding/presentation/learner_setup_screens.dart';
import '../../features/onboarding/presentation/parent_account_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/profile/presentation/parent_settings_screen.dart';
import '../../features/shell/presentation/app_shell.dart';
import '../../features/shop/presentation/shop_screen.dart';
import '../../domain/content/course_catalog.dart';
import '../../domain/repositories/app_repositories.dart';
import '../state/app_state.dart';
import '../state/auth_state.dart';

const _initialRoute = String.fromEnvironment(
  'BEARFETCH_INITIAL_ROUTE',
  defaultValue: '/onboarding',
);

class _RouterRefreshNotifier extends ChangeNotifier {
  void refresh() => notifyListeners();
}

final _routerRefreshProvider = Provider<_RouterRefreshNotifier>((ref) {
  final notifier = _RouterRefreshNotifier();
  ref.listen(authFlowControllerProvider, (_, _) => notifier.refresh());
  ref.listen(appStateControllerProvider, (_, _) => notifier.refresh());
  ref.onDispose(notifier.dispose);
  return notifier;
});

String? resolveRouteRedirect({
  required bool requiresAuthentication,
  required AuthFlowState? auth,
  required AppViewState? appState,
  required String path,
}) {
  if (!requiresAuthentication || auth == null) return null;
  final signedOutRoute =
      path == '/onboarding' ||
      path == '/signup/account' ||
      path == '/signup/verify';
  if (!auth.isAuthenticated) {
    return signedOutRoute ? null : '/onboarding';
  }
  if (path == '/signup/learner') return null;
  if (appState != null && !appState.hasLearner) {
    return '/signup/learner';
  }
  if (appState != null && appState.hasPendingDeletion) {
    return path == '/access-restricted' || path == '/parent-settings'
        ? null
        : '/access-restricted?state=pending-deletion';
  }
  if (appState?.consentStatus == 'withdrawn') {
    return path == '/access-restricted' || path == '/parent-settings'
        ? null
        : '/access-restricted?state=consent-withdrawn';
  }
  if (path == '/signup/approval') return null;
  if (appState != null && !appState.parentApproved) {
    return '/signup/approval';
  }
  if (signedOutRoute) return '/home';
  return null;
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final requiresAuthentication = ref
      .read(authRepositoryProvider)
      .requiresAuthentication;
  ref.read(authFlowControllerProvider);

  return GoRouter(
    initialLocation: _initialRoute,
    refreshListenable: ref.read(_routerRefreshProvider),
    redirect: (context, state) => resolveRouteRedirect(
      requiresAuthentication: requiresAuthentication,
      auth: ref.read(authFlowControllerProvider).valueOrNull,
      appState: ref.read(appStateControllerProvider).valueOrNull,
      path: state.uri.path,
    ),
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/signup/account',
        builder: (context, state) => ParentAccountScreen(
          isSignIn: state.uri.queryParameters['mode'] == 'sign-in',
        ),
      ),
      GoRoute(
        path: '/signup/verify',
        builder: (context, state) => const OtpVerificationScreen(),
      ),
      GoRoute(
        path: '/signup/learner',
        builder: (context, state) => const LearnerProfileScreen(),
      ),
      GoRoute(
        path: '/signup/approval',
        builder: (context, state) => const ParentApprovalScreen(),
      ),
      GoRoute(
        path: '/parent-settings',
        builder: (context, state) => const ParentSettingsScreen(),
      ),
      GoRoute(
        path: '/access-restricted',
        builder: (context, state) => AccessRestrictedScreen(
          state: state.uri.queryParameters['state'] ?? 'consent-withdrawn',
        ),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/courses',
            builder: (context, state) => const CoursesScreen(),
          ),
          GoRoute(
            path: '/shop',
            builder: (context, state) => const ShopScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/activity/:activityId',
        builder: (context, state) => CourseActivityScreen(
          activityId: state.pathParameters['activityId']!,
          chatbotTypeIndex: int.tryParse(
            state.uri.queryParameters['chatbotType'] ?? '',
          ),
        ),
      ),
      GoRoute(
        path: '/result/:activityId',
        builder: (context, state) => ActivityResultScreen(
          activityId: state.pathParameters['activityId']!,
          correct: state.uri.queryParameters['correct'] == 'true',
          chatbotTypeIndex: int.tryParse(
            state.uri.queryParameters['chatbotType'] ?? '',
          ),
        ),
      ),
      GoRoute(
        path: '/course-completion',
        builder: (context, state) => const CourseCompletionScreen(),
      ),
      GoRoute(path: '/home-started', redirect: (context, state) => '/home'),
      GoRoute(
        path: '/screen/:screenId',
        redirect: (context, state) {
          final id = state.pathParameters['screenId']!;
          return ref.read(courseCatalogProvider).byId.containsKey(id)
              ? '/activity/$id'
              : '/home';
        },
      ),
    ],
  );
});
