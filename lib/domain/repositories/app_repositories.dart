import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/app_database.dart';

enum PurchaseResult { purchased, alreadyOwned, insufficientHoney }

abstract interface class AuthRepository {
  bool get hasSession;
}

abstract interface class ParentRepository {
  Future<ParentProfile?> getParent();
  Future<void> saveParentName(String name);
}

abstract interface class LearnerRepository {
  Future<LearnerProfile?> getLearner();
  Future<void> saveLearner({
    required String nickname,
    required String ageBand,
    required String language,
  });
}

abstract interface class ConsentRepository {
  Future<bool> hasActiveConsent();
  Future<void> approveLocalConsent();
}

abstract interface class ProgressRepository {
  Future<Set<String>> completedActivityIds();
  Future<Map<String, int>> retryCounts();
  Future<bool> completeActivity({
    required String activityId,
    required String rewardId,
  });
  Future<bool> completeCourse(String completionRewardId);
  Future<void> recordRetry(String activityId);
}

abstract interface class RewardsRepository {
  Future<int> balance(String kind);
  Future<Set<String>> achievementIds();
}

abstract interface class ShopRepository {
  Future<Set<String>> ownedAccessoryIds();
  Future<Map<String, String>> equippedAccessories();
  Future<PurchaseResult> purchase({
    required String accessoryId,
    required int price,
  });
  Future<bool> equip({required String accessoryId, required String slot});
}

abstract interface class SyncRepository {
  Future<int> pendingEventCount();
  Future<String?> lastRecoverableError();
}

abstract interface class PrivacyRepository {
  Future<Map<String, Object?>> exportLocalData();
}

final appDatabaseProvider = Provider<AppDatabase>(
  (ref) => throw StateError('Database has not been bootstrapped.'),
);
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => throw StateError('Auth repository has not been bootstrapped.'),
);
final parentRepositoryProvider = Provider<ParentRepository>(
  (ref) => throw StateError('Parent repository has not been bootstrapped.'),
);
final learnerRepositoryProvider = Provider<LearnerRepository>(
  (ref) => throw StateError('Learner repository has not been bootstrapped.'),
);
final consentRepositoryProvider = Provider<ConsentRepository>(
  (ref) => throw StateError('Consent repository has not been bootstrapped.'),
);
final progressRepositoryProvider = Provider<ProgressRepository>(
  (ref) => throw StateError('Progress repository has not been bootstrapped.'),
);
final rewardsRepositoryProvider = Provider<RewardsRepository>(
  (ref) => throw StateError('Rewards repository has not been bootstrapped.'),
);
final shopRepositoryProvider = Provider<ShopRepository>(
  (ref) => throw StateError('Shop repository has not been bootstrapped.'),
);
final syncRepositoryProvider = Provider<SyncRepository>(
  (ref) => throw StateError('Sync repository has not been bootstrapped.'),
);
final privacyRepositoryProvider = Provider<PrivacyRepository>(
  (ref) => throw StateError('Privacy repository has not been bootstrapped.'),
);
