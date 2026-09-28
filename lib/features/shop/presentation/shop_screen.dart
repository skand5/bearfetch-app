import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/state/app_state.dart';
import '../../../core/theme/bearfetch_theme.dart';
import '../../../domain/repositories/app_repositories.dart';

class ShopScreen extends ConsumerStatefulWidget {
  const ShopScreen({super.key});

  @override
  ConsumerState<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends ConsumerState<ShopScreen> {
  static const _designWidth = 390.0;
  // End after second accessory row. App shell owns bottom navigation.
  static const _contentHeight = 1130.0;
  static const _assetHeight = 1402.0;

  String? selectedAccessory;

  void _share() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Shop sharing is ready for local review.'),
        ),
      );
  }

  Future<void> _buyOrEquipAccessory(
    AppViewState state, {
    required String accessoryId,
    required int price,
  }) async {
    final controller = ref.read(appStateControllerProvider.notifier);
    if (state.ownedAccessories.contains(accessoryId)) {
      final slot = _slotFor(accessoryId);
      if (_BearAppearance.equippedIds(
        state.equippedAccessories,
      ).contains(accessoryId)) {
        await controller.unequip(slot: slot);
      } else {
        await controller.equip(accessoryId, slot: slot);
      }
      return;
    }
    final result = await controller.buy(accessoryId, price);
    if (result == PurchaseResult.insufficientHoney && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You need more honey jars.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appViewStateProvider);
    final equippedBearAsset = _BearAppearance.assetFor(
      state.equippedAccessories,
    );
    return ColoredBox(
      color: const Color(0xFFFBF9F1),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final scale = constraints.maxWidth / _designWidth;
          return SingleChildScrollView(
            child: SizedBox(
              width: constraints.maxWidth,
              height: _contentHeight * scale,
              child: FittedBox(
                fit: BoxFit.fill,
                child: SizedBox(
                  width: _designWidth,
                  height: _contentHeight,
                  child: Stack(
                    clipBehavior: Clip.hardEdge,
                    children: [
                      const Positioned(
                        left: 0,
                        top: 0,
                        width: _designWidth,
                        height: _assetHeight,
                        child: Image(
                          image: AssetImage(
                            'assets/illustrations/customization.png',
                          ),
                          fit: BoxFit.fill,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                      if (equippedBearAsset != null) ...[
                        const _ShopSpaceBackground(),
                        _EquippedBear(assetPath: equippedBearAsset),
                      ],
                      Positioned(
                        left: 8,
                        top: 6,
                        width: 42,
                        height: 48,
                        child: _ShopHitTarget(
                          label: 'Close shop',
                          onTap: () => context.go('/home'),
                        ),
                      ),
                      Positioned(
                        left: 340,
                        top: 6,
                        width: 42,
                        height: 48,
                        child: _ShopHitTarget(
                          label: 'Share shop',
                          onTap: _share,
                        ),
                      ),
                      _HoneyBalance(value: state.honey),
                      // The source image contains static selected and disabled
                      // card states. Replace the complete grid so its state is
                      // driven only by the learner's owned accessories.
                      const _ShopCardGridMask(),
                      _ShopAccessoryCard(
                        left: 15,
                        top: 600,
                        width: 178,
                        height: 260,
                        title: 'Star Cap',
                        price: 25,
                        owned: state.ownedAccessories.contains('Star Cap'),
                        equipped: _BearAppearance.equippedIds(
                          state.equippedAccessories,
                        ).contains('Star Cap'),
                        sourceLeft: 32,
                        sourceTop: 700,
                      ),
                      _ShopAccessoryCard(
                        left: 204,
                        top: 600,
                        width: 166,
                        height: 260,
                        title: 'Moon Glasses',
                        price: 60,
                        owned: state.ownedAccessories.contains('Moon Glasses'),
                        equipped: _BearAppearance.equippedIds(
                          state.equippedAccessories,
                        ).contains('Moon Glasses'),
                        sourceLeft: 216,
                        sourceTop: 700,
                      ),
                      _ShopAccessoryCard(
                        left: 15,
                        top: 866,
                        width: 178,
                        height: 250,
                        title: 'Rocket Pack',
                        price: 90,
                        owned: state.ownedAccessories.contains('Rocket Pack'),
                        equipped: _BearAppearance.equippedIds(
                          state.equippedAccessories,
                        ).contains('Rocket Pack'),
                        sourceLeft: 32,
                        sourceTop: 965,
                      ),
                      _ShopAccessoryCard(
                        left: 204,
                        top: 866,
                        width: 166,
                        height: 250,
                        title: 'Galaxy Helm',
                        price: 180,
                        owned: state.ownedAccessories.contains('Galaxy Helm'),
                        equipped: _BearAppearance.equippedIds(
                          state.equippedAccessories,
                        ).contains('Galaxy Helm'),
                        sourceLeft: 216,
                        sourceTop: 965,
                      ),
                      if (selectedAccessory == 'Moon Glasses')
                        const _AccessorySelectionOutline(
                          left: 204,
                          top: 601,
                          width: 166,
                          height: 258,
                        ),
                      if (selectedAccessory == 'Rocket Pack')
                        const _AccessorySelectionOutline(
                          left: 20,
                          top: 866,
                          width: 166,
                          height: 250,
                        ),
                      if (selectedAccessory == 'Galaxy Helm')
                        const _AccessorySelectionOutline(
                          left: 204,
                          top: 866,
                          width: 166,
                          height: 250,
                        ),
                      Positioned(
                        left: 15,
                        top: 601,
                        width: 178,
                        height: 258,
                        child: _ShopHitTarget(
                          label: 'Select Star Cap',
                          onTap: () =>
                              setState(() => selectedAccessory = 'Star Cap'),
                        ),
                      ),
                      Positioned(
                        left: 204,
                        top: 601,
                        width: 166,
                        height: 258,
                        child: _ShopHitTarget(
                          label: 'Select Moon Glasses',
                          onTap: () => setState(
                            () => selectedAccessory = 'Moon Glasses',
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 866,
                        width: 166,
                        height: 250,
                        child: _ShopHitTarget(
                          label: 'Select Rocket Pack',
                          onTap: () =>
                              setState(() => selectedAccessory = 'Rocket Pack'),
                        ),
                      ),
                      Positioned(
                        left: 24,
                        top: 791,
                        width: 160,
                        height: 64,
                        child: _ShopHitTarget(
                          label: state.ownedAccessories.contains('Star Cap')
                              ? _BearAppearance.equippedIds(
                                      state.equippedAccessories,
                                    ).contains('Star Cap')
                                    ? 'Remove Star Cap'
                                    : 'Equip Star Cap'
                              : 'Buy Star Cap',
                          onTap: () => _buyOrEquipAccessory(
                            state,
                            accessoryId: 'Star Cap',
                            price: 25,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 204,
                        top: 866,
                        width: 166,
                        height: 250,
                        child: _ShopHitTarget(
                          label: 'Select Galaxy Helm',
                          onTap: () =>
                              setState(() => selectedAccessory = 'Galaxy Helm'),
                        ),
                      ),
                      Positioned(
                        left: 205,
                        top: 791,
                        width: 165,
                        height: 64,
                        child: _ShopHitTarget(
                          label: state.ownedAccessories.contains('Moon Glasses')
                              ? _BearAppearance.equippedIds(
                                      state.equippedAccessories,
                                    ).contains('Moon Glasses')
                                    ? 'Remove Moon Glasses'
                                    : 'Equip Moon Glasses'
                              : 'Buy Moon Glasses',
                          onTap: () => _buyOrEquipAccessory(
                            state,
                            accessoryId: 'Moon Glasses',
                            price: 60,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 1051,
                        width: 165,
                        height: 64,
                        child: _ShopHitTarget(
                          label: state.ownedAccessories.contains('Rocket Pack')
                              ? _BearAppearance.equippedIds(
                                      state.equippedAccessories,
                                    ).contains('Rocket Pack')
                                    ? 'Remove Rocket Pack'
                                    : 'Equip Rocket Pack'
                              : 'Buy Rocket Pack',
                          onTap: () => _buyOrEquipAccessory(
                            state,
                            accessoryId: 'Rocket Pack',
                            price: 90,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 205,
                        top: 1051,
                        width: 165,
                        height: 64,
                        child: _ShopHitTarget(
                          label: state.ownedAccessories.contains('Galaxy Helm')
                              ? _BearAppearance.equippedIds(
                                      state.equippedAccessories,
                                    ).contains('Galaxy Helm')
                                    ? 'Remove Galaxy Helm'
                                    : 'Equip Galaxy Helm'
                              : 'Buy Galaxy Helm',
                          onTap: () => _buyOrEquipAccessory(
                            state,
                            accessoryId: 'Galaxy Helm',
                            price: 180,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  static String _slotFor(String accessoryId) => switch (accessoryId) {
    'Star Cap' || 'Galaxy Helm' => 'head',
    'Moon Glasses' => 'face',
    'Rocket Pack' => 'back',
    _ => 'featured',
  };
}

class _EquippedBear extends StatelessWidget {
  const _EquippedBear({required this.assetPath});

  final String assetPath;

  @override
  Widget build(BuildContext context) => Positioned(
    left: -48,
    top: 40,
    width: 483,
    height: 483,
    child: IgnorePointer(child: Image.asset(assetPath, fit: BoxFit.contain)),
  );
}

class _ShopSpaceBackground extends StatelessWidget {
  const _ShopSpaceBackground();

  @override
  Widget build(BuildContext context) => const Positioned.fill(
    child: Stack(
      children: [
        Positioned(
          left: 0,
          top: 63,
          width: 390,
          height: 420,
          child: IgnorePointer(child: ColoredBox(color: Color(0xFFFBF9F1))),
        ),
        Positioned(
          left: 0,
          top: 63,
          width: 390,
          height: 220,
          child: IgnorePointer(
            child: Image(
              image: AssetImage(
                'assets/illustrations/shop_space_background.png',
              ),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ],
    ),
  );
}

class _BearAppearance {
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

class _HoneyBalance extends StatelessWidget {
  const _HoneyBalance({required this.value});

  final int value;

  @override
  Widget build(BuildContext context) => Positioned(
    left: 65,
    top: 516,
    width: 70,
    height: 40,
    child: ColoredBox(
      color: Colors.white,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          '$value',
          style: const TextStyle(
            fontFamily: 'Fredoka',
            fontSize: 25,
            fontWeight: FontWeight.w700,
            color: Color(0xFF9A5300),
          ),
        ),
      ),
    ),
  );
}

class _ShopCardGridMask extends StatelessWidget {
  const _ShopCardGridMask();

  @override
  Widget build(BuildContext context) => const Positioned(
    left: 0,
    top: 580,
    width: 390,
    height: 625,
    child: ColoredBox(color: Color(0xFFFBF9F1)),
  );
}

class _ShopAccessoryCard extends StatelessWidget {
  const _ShopAccessoryCard({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.title,
    required this.price,
    required this.owned,
    required this.equipped,
    required this.sourceLeft,
    required this.sourceTop,
  });

  final double left;
  final double top;
  final double width;
  final double height;
  final String title;
  final int price;
  final bool owned;
  final bool equipped;
  final double sourceLeft;
  final double sourceTop;

  @override
  Widget build(BuildContext context) => Positioned(
    left: left,
    top: top,
    width: width,
    height: height,
    child: Container(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: SizedBox(
              width: 143,
              height: 113,
              child: _CustomizationCrop(
                sourceLeft: sourceLeft,
                sourceTop: sourceTop,
                width: 143,
                height: 113,
              ),
            ),
          ),
          const SizedBox(height: 11),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Fredoka',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF171B1A),
            ),
          ),
          const SizedBox(height: 4),
          if (owned)
            const Center(
              child: Text(
                'OWNED',
                style: TextStyle(
                  fontFamily: 'Fredoka',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6CE3C8),
                ),
              ),
            )
          else
            _HoneyJarPrice(price: price),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 38,
            child: Center(
              child: owned
                  ? Text(
                      equipped ? 'Remove' : 'Equip',
                      style: const TextStyle(
                        fontFamily: 'Fredoka',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: BearfetchColors.cocoa,
                      ),
                    )
                  : Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: BearfetchColors.honey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Buy',
                        style: TextStyle(
                          fontFamily: 'Fredoka',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF6D3A00),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _CustomizationCrop extends StatelessWidget {
  const _CustomizationCrop({
    required this.sourceLeft,
    required this.sourceTop,
    required this.width,
    required this.height,
  });

  final double sourceLeft;
  final double sourceTop;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(13),
    child: OverflowBox(
      alignment: Alignment.topLeft,
      minWidth: 390,
      maxWidth: 390,
      minHeight: 1402,
      maxHeight: 1402,
      child: Transform.translate(
        offset: Offset(-sourceLeft, -sourceTop),
        child: const Image(
          image: AssetImage('assets/illustrations/customization.png'),
          width: 390,
          height: 1402,
          fit: BoxFit.fill,
          filterQuality: FilterQuality.high,
        ),
      ),
    ),
  );
}

class _HoneyJarPrice extends StatelessWidget {
  const _HoneyJarPrice({required this.price});

  final int price;

  @override
  Widget build(BuildContext context) => Center(
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/icons/honey_jar.png',
          width: 12,
          height: 13,
          filterQuality: FilterQuality.none,
        ),
        const SizedBox(width: 4),
        Text(
          '$price',
          style: TextStyle(
            fontFamily: 'Fredoka',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF9A5300),
          ),
        ),
      ],
    ),
  );
}

class _AccessorySelectionOutline extends StatelessWidget {
  const _AccessorySelectionOutline({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
  });

  final double left;
  final double top;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) => Positioned(
    left: left,
    top: top,
    width: width,
    height: height,
    child: IgnorePointer(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: BearfetchColors.honey, width: 3),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),
  );
}

class _ShopHitTarget extends StatelessWidget {
  const _ShopHitTarget({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    label: label,
    button: true,
    enabled: true,
    child: Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
    ),
  );
}
