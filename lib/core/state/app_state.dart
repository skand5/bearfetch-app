import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/content/course_catalog.dart';
import '../../domain/repositories/app_repositories.dart';

class AppViewState {
  const AppViewState({
    required this.parentName,
    required this.hasParent,
    required this.learnerName,
    required this.hasLearner,
    required this.ageRange,
    required this.language,
    required this.parentApproved,
    required this.completedActivityIds,
    required this.completedSteps,
    required this.nextCourseRoute,
    required this.honey,
    required this.xp,
    required this.achievements,
    required this.ownedAccessories,
    required this.equippedAccessories,
    required this.pendingSyncEvents,
    required this.syncWarning,
  });

  final String parentName;
  final bool hasParent;
  final String learnerName;
  final bool hasLearner;
  final String ageRange;
  final String language;
  final bool parentApproved;
  final Set<String> completedActivityIds;
  final int completedSteps;
  final String nextCourseRoute;
  final int honey;
  final int xp;
  final Set<String> achievements;
  final Set<String> ownedAccessories;
  final Map<String, String> equippedAccessories;
  final int pendingSyncEvents;
  final String? syncWarning;

  bool get courseStarted => completedActivityIds.isNotEmpty;
  double get progress => completedSteps / 36;
  String get equippedAccessory =>
      equippedAccessories['featured'] ?? 'Rocket Pack';

  factory AppViewState.loading(CourseCatalog catalog) => AppViewState(
    parentName: 'Parent',
    hasParent: false,
    learnerName: 'Max',
    hasLearner: false,
    ageRange: '6–11 yr',
    language: 'English',
    parentApproved: false,
    completedActivityIds: const {},
    completedSteps: 0,
    nextCourseRoute: '/activity/${catalog.firstActivity.id}',
    honey: 0,
    xp: 0,
    achievements: const {},
    ownedAccessories: const {},
    equippedAccessories: const {},
    pendingSyncEvents: 0,
    syncWarning: null,
  );
}

final appStateControllerProvider =
    AsyncNotifierProvider<AppStateController, AppViewState>(
      AppStateController.new,
    );

final appViewStateProvider = Provider<AppViewState>((ref) {
  final catalog = ref.watch(courseCatalogProvider);
  return ref.watch(appStateControllerProvider).valueOrNull ??
      AppViewState.loading(catalog);
});

class AppStateController extends AsyncNotifier<AppViewState> {
  @override
  Future<AppViewState> build() => _load();

  Future<AppViewState> _load() async {
    final catalog = ref.read(courseCatalogProvider);
    final parent = await ref.read(parentRepositoryProvider).getParent();
    final learner = await ref.read(learnerRepositoryProvider).getLearner();
    final completed = await ref
        .read(progressRepositoryProvider)
        .completedActivityIds();
    final achievements = await ref
        .read(rewardsRepositoryProvider)
        .achievementIds();
    final completedDefinitions = completed
        .map((id) => catalog.byId[id])
        .whereType<ActivityDefinition>();
    final activityDisplayStep = completedDefinitions.fold(
      0,
      (highest, activity) => activity.step > highest ? activity.step : highest,
    );
    final courseCompleted = achievements.contains('ai-explorer-badge');
    final allActivitiesCompleted =
        completedDefinitions.length == catalog.activities.length;
    return AppViewState(
      parentName: parent?.displayName ?? 'Parent',
      hasParent: parent != null,
      learnerName: learner?.nickname ?? 'Max',
      hasLearner: learner != null,
      ageRange: learner?.ageBand ?? '6–11 yr',
      language: learner?.language ?? 'English',
      parentApproved: await ref
          .read(consentRepositoryProvider)
          .hasActiveConsent(),
      completedActivityIds: Set.unmodifiable(completed),
      completedSteps: courseCompleted ? 36 : activityDisplayStep,
      nextCourseRoute: allActivitiesCompleted
          ? '/course-completion'
          : '/activity/${catalog.nextIncomplete(completed).id}',
      honey: await ref.read(rewardsRepositoryProvider).balance('honey'),
      xp: await ref.read(rewardsRepositoryProvider).balance('xp'),
      achievements: Set.unmodifiable(achievements),
      ownedAccessories: Set.unmodifiable(
        await ref.read(shopRepositoryProvider).ownedAccessoryIds(),
      ),
      equippedAccessories: Map.unmodifiable(
        await ref.read(shopRepositoryProvider).equippedAccessories(),
      ),
      pendingSyncEvents: await ref
          .read(syncRepositoryProvider)
          .pendingEventCount(),
      syncWarning: await ref
          .read(syncRepositoryProvider)
          .lastRecoverableError(),
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading<AppViewState>().copyWithPrevious(state);
    state = await AsyncValue.guard(_load);
  }

  Future<void> setParentName(String value) async {
    await ref.read(parentRepositoryProvider).saveParentName(value);
    await refresh();
  }

  Future<void> saveLearner({
    required String nickname,
    required String age,
    required String preferredLanguage,
  }) async {
    await ref
        .read(learnerRepositoryProvider)
        .saveLearner(
          nickname: nickname,
          ageBand: age,
          language: preferredLanguage,
        );
    await refresh();
  }

  Future<void> approveParent() async {
    await ref.read(consentRepositoryProvider).approveLocalConsent();
    await refresh();
  }

  Future<void> completeActivity(ActivityDefinition activity) async {
    await ref
        .read(progressRepositoryProvider)
        .completeActivity(activityId: activity.id, rewardId: activity.rewardId);
    await refresh();
  }

  Future<void> recordRetry(String activityId) async {
    await ref.read(progressRepositoryProvider).recordRetry(activityId);
    await refresh();
  }

  Future<void> completeCourse() async {
    final catalog = ref.read(courseCatalogProvider);
    await ref
        .read(progressRepositoryProvider)
        .completeCourse(catalog.completionRewardId);
    await refresh();
  }

  Future<PurchaseResult> buy(String name, int price) async {
    final result = await ref
        .read(shopRepositoryProvider)
        .purchase(accessoryId: name, price: price);
    await refresh();
    return result;
  }

  Future<bool> equip(String name, {String slot = 'featured'}) async {
    final equipped = await ref
        .read(shopRepositoryProvider)
        .equip(accessoryId: name, slot: slot);
    await refresh();
    return equipped;
  }
}
