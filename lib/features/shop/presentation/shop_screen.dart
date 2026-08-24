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
  static const _contentHeight = 1322.0;
  static const _assetHeight = 1402.0;

  String category = 'Hats';

  void _share() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Shop sharing is ready for local review.'),
        ),
      );
  }

  Future<void> _buyOrEquipStarCap(AppViewState state) async {
    final controller = ref.read(appStateControllerProvider.notifier);
    if (state.ownedAccessories.contains('Star Cap')) {
      await controller.equip('Star Cap');
      return;
    }
    final result = await controller.buy('Star Cap', 25);
    if (result == PurchaseResult.insufficientHoney && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You need more honey jars.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appViewStateProvider);
    final controller = ref.read(appStateControllerProvider.notifier);
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
                      Positioned.fill(
                        child: _CategoryLayer(
                          selected: category,
                          onSelected: (value) =>
                              setState(() => category = value),
                        ),
                      ),
                      if (state.ownedAccessories.contains('Star Cap'))
                        Positioned.fill(
                          child: _StarCapState(
                            equipped: state.equippedAccessory == 'Star Cap',
                          ),
                        ),
                      _AccessoryCardStatus(
                        left: 205,
                        top: 850,
                        owned: state.ownedAccessories.contains('Moon Glasses'),
                        equipped: state.equippedAccessory == 'Moon Glasses',
                        price: 60,
                      ),
                      _AccessoryCardStatus(
                        left: 20,
                        top: 1111,
                        owned: state.ownedAccessories.contains('Rocket Pack'),
                        equipped: state.equippedAccessory == 'Rocket Pack',
                        price: 90,
                      ),
                      Positioned(
                        left: 24,
                        top: 874,
                        width: 160,
                        height: 64,
                        child: _ShopHitTarget(
                          label: state.ownedAccessories.contains('Star Cap')
                              ? state.equippedAccessory == 'Star Cap'
                                    ? 'Star Cap equipped'
                                    : 'Equip Star Cap'
                              : 'Buy Star Cap',
                          enabled: state.equippedAccessory != 'Star Cap',
                          onTap: () => _buyOrEquipStarCap(state),
                        ),
                      ),
                      Positioned(
                        left: 205,
                        top: 874,
                        width: 165,
                        height: 64,
                        child: _ShopHitTarget(
                          label: state.equippedAccessory == 'Moon Glasses'
                              ? 'Moon Glasses equipped'
                              : 'Equip Moon Glasses',
                          enabled: state.equippedAccessory != 'Moon Glasses',
                          onTap: () => controller.equip('Moon Glasses'),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 1134,
                        width: 165,
                        height: 64,
                        child: _ShopHitTarget(
                          label: state.equippedAccessory == 'Rocket Pack'
                              ? 'Rocket Pack equipped'
                              : 'Equip Rocket Pack',
                          enabled: state.equippedAccessory != 'Rocket Pack',
                          onTap: () => controller.equip('Rocket Pack'),
                        ),
                      ),
                      Positioned(
                        left: 188,
                        top: 1212,
                        width: 178,
                        height: 78,
                        child: _ShopHitTarget(
                          label: state.ownedAccessories.contains('Star Cap')
                              ? 'Equip selected accessory'
                              : 'Buy selected accessory',
                          enabled: state.equippedAccessory != 'Star Cap',
                          onTap: () => _buyOrEquipStarCap(state),
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

class _CategoryLayer extends StatelessWidget {
  const _CategoryLayer({required this.selected, required this.onSelected});

  final String selected;
  final ValueChanged<String> onSelected;

  static const _categories = [
    ('Hats', 20.0, 84.0),
    ('Glasses', 115.0, 107.0),
    ('Outfits', 236.0, 101.0),
    ('Backpacks', 350.0, 116.0),
  ];

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      if (selected != 'Hats') ...[
        const Positioned(
          left: 20,
          top: 604,
          width: 84,
          height: 45,
          child: _CategoryPill(label: 'Hats', selected: false),
        ),
        for (final item in _categories.where((item) => item.$1 == selected))
          Positioned(
            left: item.$2,
            top: 604,
            width: item.$3,
            height: 45,
            child: _CategoryPill(label: item.$1, selected: true),
          ),
      ],
      for (final item in _categories)
        Positioned(
          left: item.$2,
          top: 596,
          width: item.$3,
          height: 62,
          child: _ShopHitTarget(
            label: '${item.$1} category',
            selected: selected == item.$1,
            onTap: () => onSelected(item.$1),
          ),
        ),
    ],
  );
}

class _CategoryPill extends StatelessWidget {
  const _CategoryPill({required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) => Container(
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: selected ? const Color(0xFF293033) : const Color(0xFFFFCEB5),
      borderRadius: BorderRadius.circular(25),
    ),
    child: Text(
      label,
      maxLines: 1,
      style: TextStyle(
        fontFamily: 'Fredoka',
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: selected ? Colors.white : const Color(0xFF171B1A),
      ),
    ),
  );
}

class _StarCapState extends StatelessWidget {
  const _StarCapState({required this.equipped});

  final bool equipped;

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      _AccessoryCardStatus(
        left: 20,
        top: 850,
        owned: true,
        equipped: equipped,
        price: 25,
      ),
      Positioned(
        left: 20,
        top: 1247,
        width: 350,
        height: 58,
        child: ColoredBox(
          color: Colors.white,
          child: Row(
            children: [
              const SizedBox(width: 18),
              Text(
                equipped ? 'EQUIPPED' : 'OWNED',
                style: const TextStyle(
                  fontFamily: 'Fredoka',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6CE3C8),
                ),
              ),
              const Spacer(),
              Text(
                equipped ? 'Equipped' : 'Equip',
                style: TextStyle(
                  fontFamily: 'Fredoka',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: equipped
                      ? const Color(0xFFB0A7A7)
                      : BearfetchColors.cocoa,
                ),
              ),
              const SizedBox(width: 34),
            ],
          ),
        ),
      ),
    ],
  );
}

class _AccessoryCardStatus extends StatelessWidget {
  const _AccessoryCardStatus({
    required this.left,
    required this.top,
    required this.owned,
    required this.equipped,
    required this.price,
  });

  final double left;
  final double top;
  final bool owned;
  final bool equipped;
  final int price;

  @override
  Widget build(BuildContext context) => Positioned(
    left: left,
    top: top,
    width: 165,
    height: 82,
    child: ColoredBox(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            equipped
                ? 'EQUIPPED'
                : owned
                ? 'OWNED'
                : 'NOT OWNED',
            style: TextStyle(
              fontFamily: 'Fredoka',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: owned ? const Color(0xFF6CE3C8) : const Color(0xFF877365),
            ),
          ),
          const Spacer(),
          Center(
            child: Text(
              equipped
                  ? 'Equipped'
                  : owned
                  ? 'Equip'
                  : 'Earn $price honey',
              style: TextStyle(
                fontFamily: 'Fredoka',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: equipped
                    ? const Color(0xFFB0A7A7)
                    : BearfetchColors.cocoa,
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    ),
  );
}

class _ShopHitTarget extends StatelessWidget {
  const _ShopHitTarget({
    required this.label,
    required this.onTap,
    this.enabled = true,
    this.selected,
  });

  final String label;
  final VoidCallback onTap;
  final bool enabled;
  final bool? selected;

  @override
  Widget build(BuildContext context) => Semantics(
    label: label,
    button: true,
    enabled: enabled,
    selected: selected,
    child: Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: enabled ? onTap : null,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
    ),
  );
}
