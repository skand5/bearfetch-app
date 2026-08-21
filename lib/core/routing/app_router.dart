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
import '../../features/shell/presentation/app_shell.dart';
import '../../features/shop/presentation/shop_screen.dart';
import '../../domain/content/course_catalog.dart';

const _initialRoute = String.fromEnvironment(
  'BEARFETCH_INITIAL_ROUTE',
  defaultValue: '/onboarding',
);

final appRouterProvider = Provider<GoRouter>(
  (ref) => GoRouter(
    initialLocation: _initialRoute,
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/signup/account',
        builder: (context, state) => const ParentAccountScreen(),
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
        ),
      ),
      GoRoute(
        path: '/result/:activityId',
        builder: (context, state) => ActivityResultScreen(
          activityId: state.pathParameters['activityId']!,
          correct: state.uri.queryParameters['correct'] == 'true',
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
  ),
);
