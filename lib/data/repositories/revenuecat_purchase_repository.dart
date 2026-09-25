import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart' as rc;

import '../../core/config/app_config.dart';
import '../../domain/repositories/app_repositories.dart';

/// RevenueCat-backed access to the parent-only progress insight request.
///
/// Access is derived exclusively from the active RevenueCat entitlement. No
/// purchase or entitlement state is persisted locally.
class RevenueCatPurchaseRepository
    implements ProgressInsightPurchaseRepository {
  static const entitlementId = 'progress_insight_requests';

  rc.Package? _lifetimePackage;
  String? _configuredParentUserId;

  @override
  Future<ProgressInsightPurchaseState> statusFor(String parentUserId) async {
    if (!AppConfig.hasRevenueCatConfiguration) {
      return const ProgressInsightPurchaseState(
        availability: ProgressInsightPurchaseAvailability.unavailable,
        hasEntitlement: false,
        message: 'Purchases are not configured for this build.',
      );
    }

    try {
      await _identifyParent(parentUserId);
      final customerInfo = await rc.Purchases.getCustomerInfo();
      if (_hasEntitlement(customerInfo)) {
        return const ProgressInsightPurchaseState(
          availability: ProgressInsightPurchaseAvailability.available,
          hasEntitlement: true,
        );
      }

      final offerings = await rc.Purchases.getOfferings();
      _lifetimePackage = offerings.current?.lifetime;
      final package = _lifetimePackage;
      if (package == null) {
        return const ProgressInsightPurchaseState(
          availability: ProgressInsightPurchaseAvailability.unavailable,
          hasEntitlement: false,
          message: 'Progress insight purchase is not available yet.',
        );
      }
      return ProgressInsightPurchaseState(
        availability: ProgressInsightPurchaseAvailability.available,
        hasEntitlement: false,
        localizedPrice: package.storeProduct.priceString,
      );
    } on PlatformException catch (error) {
      return ProgressInsightPurchaseState(
        availability: ProgressInsightPurchaseAvailability.unavailable,
        hasEntitlement: false,
        message: _purchaseErrorMessage(error),
      );
    } catch (_) {
      return const ProgressInsightPurchaseState(
        availability: ProgressInsightPurchaseAvailability.unavailable,
        hasEntitlement: false,
        message: 'Purchases could not be loaded. Please try again later.',
      );
    }
  }

  @override
  Future<ProgressInsightPurchaseState> purchase(String parentUserId) async {
    final current = await statusFor(parentUserId);
    if (!current.canPurchase) return current;

    final package = _lifetimePackage;
    if (package == null) {
      return const ProgressInsightPurchaseState(
        availability: ProgressInsightPurchaseAvailability.unavailable,
        hasEntitlement: false,
        message: 'Progress insight purchase is not available yet.',
      );
    }
    try {
      final result = await rc.Purchases.purchase(
        rc.PurchaseParams.package(package),
      );
      return _stateFromCustomerInfo(
        result.customerInfo,
        fallbackPrice: current.localizedPrice,
      );
    } on PlatformException catch (error) {
      return ProgressInsightPurchaseState(
        availability: ProgressInsightPurchaseAvailability.available,
        hasEntitlement: false,
        localizedPrice: current.localizedPrice,
        message: _purchaseErrorMessage(error),
      );
    } catch (_) {
      return ProgressInsightPurchaseState(
        availability: ProgressInsightPurchaseAvailability.available,
        hasEntitlement: false,
        localizedPrice: current.localizedPrice,
        message: 'Purchase could not be completed. Please try again.',
      );
    }
  }

  @override
  Future<ProgressInsightPurchaseState> restore(String parentUserId) async {
    final current = await statusFor(parentUserId);
    if (current.availability ==
        ProgressInsightPurchaseAvailability.unavailable) {
      return current;
    }
    try {
      final customerInfo = await rc.Purchases.restorePurchases();
      final restored = _stateFromCustomerInfo(
        customerInfo,
        fallbackPrice: current.localizedPrice,
      );
      return restored.hasEntitlement
          ? restored
          : ProgressInsightPurchaseState(
              availability: restored.availability,
              hasEntitlement: false,
              localizedPrice: restored.localizedPrice,
              message: 'No previous progress insight purchase was found.',
            );
    } on PlatformException catch (error) {
      return ProgressInsightPurchaseState(
        availability: current.availability,
        hasEntitlement: false,
        localizedPrice: current.localizedPrice,
        message: _purchaseErrorMessage(error),
      );
    } catch (_) {
      return ProgressInsightPurchaseState(
        availability: current.availability,
        hasEntitlement: false,
        localizedPrice: current.localizedPrice,
        message: 'Purchases could not be restored. Please try again.',
      );
    }
  }

  @override
  Future<void> signOut() async {
    _lifetimePackage = null;
    _configuredParentUserId = null;
    if (!AppConfig.hasRevenueCatConfiguration) return;
    try {
      if (await rc.Purchases.isConfigured) {
        await rc.Purchases.logOut();
      }
    } on PlatformException {
      // Auth sign-out must still complete if RevenueCat is temporarily offline.
    }
  }

  Future<void> _identifyParent(String parentUserId) async {
    if (parentUserId.isEmpty) {
      throw StateError('Parent authentication is required.');
    }
    if (_configuredParentUserId == parentUserId) return;

    if (await rc.Purchases.isConfigured) {
      await rc.Purchases.logIn(parentUserId);
    } else {
      final configuration = rc.PurchasesConfiguration(
        AppConfig.revenueCatPublicSdkKey,
      )..appUserID = parentUserId;
      await rc.Purchases.configure(configuration);
    }
    _configuredParentUserId = parentUserId;
  }

  ProgressInsightPurchaseState _stateFromCustomerInfo(
    rc.CustomerInfo customerInfo, {
    String? fallbackPrice,
  }) => ProgressInsightPurchaseState(
    availability: ProgressInsightPurchaseAvailability.available,
    hasEntitlement: _hasEntitlement(customerInfo),
    localizedPrice: fallbackPrice,
    message: _hasEntitlement(customerInfo)
        ? null
        : 'Purchase completed, but access is not active yet. Please restore later.',
  );

  bool _hasEntitlement(rc.CustomerInfo customerInfo) =>
      customerInfo.entitlements.active.containsKey(entitlementId);

  String _purchaseErrorMessage(PlatformException error) {
    final code = rc.PurchasesErrorHelper.getErrorCode(error);
    return code == rc.PurchasesErrorCode.purchaseCancelledError
        ? 'Purchase cancelled.'
        : 'Purchase could not be completed. Please try again.';
  }
}
