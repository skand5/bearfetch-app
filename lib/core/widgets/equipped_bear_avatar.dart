import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/app_state.dart';

/// Header-sized portrait of the bear currently equipped in the shop.
class EquippedBearAvatar extends ConsumerWidget {
  const EquippedBearAvatar({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final equippedAsset = BearAppearance.assetFor(
      ref.watch(appViewStateProvider).equippedAccessories,
    );

    if (equippedAsset == null) {
      return Image.asset(
        'assets/icons/home/usrimg.png',
        width: size,
        height: size,
        fit: BoxFit.contain,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.28),
      child: ColoredBox(
        color: const Color(0xFFFFE5BE),
        child: SizedBox(
          width: size,
          height: size,
          child: ClipRect(
            child: Transform.scale(
              scale: 1.62,
              alignment: Alignment.topCenter,
              child: Image.asset(equippedAsset, fit: BoxFit.contain),
            ),
          ),
        ),
      ),
    );
  }
}

/// Single source of truth for shop outfit combinations and their artwork.
abstract final class BearAppearance {
  static Set<String> equippedIds(Map<String, String> equippedAccessories) {
    final bySlot = <String, String>{};
    for (final accessory in equippedAccessories.values) {
      final slot = _slotFor(accessory);
      if (slot != null) bySlot[slot] = accessory;
    }
    return Set.unmodifiable(bySlot.values);
  }

  static String? assetFor(Map<String, String> equippedAccessories) {
    final items = equippedIds(equippedAccessories);
    final cap = items.contains('Star Cap');
    final glasses = items.contains('Moon Glasses');
    final rocket = items.contains('Rocket Pack');
    final helm = items.contains('Galaxy Helm');

    if (cap && glasses && rocket) {
      return 'assets/illustrations/bear_equipped_cap_moon_glasses_rocket_pack.png';
    }
    if (helm && glasses && rocket) {
      return 'assets/illustrations/bear_equipped_galaxy_helm_moon_glasses_rocket_pack.png';
    }
    if (cap && glasses) {
      return 'assets/illustrations/bear_equipped_cap_moon_glasses.png';
    }
    if (cap && rocket) {
      return 'assets/illustrations/bear_equipped_cap_rocket_pack.png';
    }
    if (glasses && rocket) {
      return 'assets/illustrations/bear_equipped_moon_glasses_rocket_pack.png';
    }
    if (helm && rocket) {
      return 'assets/illustrations/bear_equipped_galaxy_helm_rocket_pack.png';
    }
    if (cap) return 'assets/illustrations/bear_equipped_cap.png';
    if (glasses) return 'assets/illustrations/bear_equipped_moon_glasses.png';
    if (rocket) return 'assets/illustrations/bear_equipped_rocket_pack.png';
    if (helm) return 'assets/illustrations/bear_equipped_galaxy_helm.png';
    return null;
  }

  static String? _slotFor(String accessoryId) => switch (accessoryId) {
    'Star Cap' || 'Galaxy Helm' => 'head',
    'Moon Glasses' => 'face',
    'Rocket Pack' => 'back',
    _ => null,
  };
}
