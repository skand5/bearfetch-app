import 'package:bearfetch_app/domain/repositories/app_repositories.dart';

class FakeProgressInsightPurchaseRepository
    implements ProgressInsightPurchaseRepository {
  FakeProgressInsightPurchaseRepository({
    this.state = const ProgressInsightPurchaseState(
      availability: ProgressInsightPurchaseAvailability.unavailable,
      hasEntitlement: false,
      message: 'Purchases are not configured for this build.',
    ),
  });

  ProgressInsightPurchaseState state;
  int purchaseCount = 0;
  int restoreCount = 0;
  int signOutCount = 0;

  @override
  Future<ProgressInsightPurchaseState> purchase(String parentUserId) async {
    purchaseCount += 1;
    return state;
  }

  @override
  Future<ProgressInsightPurchaseState> restore(String parentUserId) async {
    restoreCount += 1;
    return state;
  }

  @override
  Future<void> signOut() async {
    signOutCount += 1;
  }

  @override
  Future<ProgressInsightPurchaseState> statusFor(String parentUserId) async =>
      state;
}
