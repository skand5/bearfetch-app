import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/state/app_state.dart';
import '../../../core/state/auth_state.dart';
import '../../../core/widgets/equipped_bear_avatar.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  static const _designWidth = 390.0;
  static const _contentHeight = 1320.0;
  static const _assetHeight = 1400.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appViewStateProvider);
    final equippedBearAsset = _ProfileBearAppearance.assetFor(
      state.equippedAccessories,
    );

    void continueLearning() {
      context.go(state.nextCourseRoute);
    }

    void showLocalMessage(String message) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
    }

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
                        top: 15,
                        width: _designWidth,
                        height: _assetHeight,
                        child: Image(
                          image: AssetImage('assets/illustrations/profile.png'),
                          fit: BoxFit.fill,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                      // Lower hero artwork below replacement header. Keep
                      // stats/content coordinates unchanged.
                      const Positioned(
                        left: 0,
                        top: 70,
                        width: _designWidth,
                        height: 288,
                        child: ColoredBox(color: Color(0xFFFBF9F1)),
                      ),
                      if (equippedBearAsset == null)
                        Positioned(
                          left: 0,
                          top: 70,
                          width: _designWidth,
                          height: 288,
                          child: ClipRect(
                            child: OverflowBox(
                              alignment: Alignment.topCenter,
                              minWidth: _designWidth,
                              maxWidth: _designWidth,
                              minHeight: _assetHeight,
                              maxHeight: _assetHeight,
                              child: Transform.translate(
                                offset: Offset(0, 15),
                                child: Transform.translate(
                                  offset: Offset(0, -70),
                                  child: Image.asset(
                                    'assets/illustrations/profile.png',
                                    width: _designWidth,
                                    height: _assetHeight,
                                    fit: BoxFit.fill,
                                    filterQuality: FilterQuality.high,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (equippedBearAsset != null) const _ProfileHeroBase(),
                      if (equippedBearAsset != null)
                        Positioned(
                          left: 20,
                          // Keep the replacement frame below the header.
                          top: 100,
                          width: 350,
                          height: 266,
                          child: ClipRect(
                            child: SizedBox(
                              width: 350,
                              height: 266,
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Image.asset(
                                  equippedBearAsset,
                                  width: 330,
                                  height: 330,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),
                      const _ProfileHeaderOverlay(),
                      Transform.translate(
                        offset: const Offset(0, 15),
                        child: _ProfileProgressOverlay(state: state),
                      ),
                      // The baked-in profile.png art still reads
                      // "Notifications" for this row; this label patch
                      // overlays the correct "Parent settings" copy so the
                      // visible text matches where the row actually
                      // navigates. Purely cosmetic — it sits above the
                      // Image and below the transparent hit target below.
                      const Positioned(
                        left: 34,
                        top: 1112,
                        width: 300,
                        height: 30,
                        child: ColoredBox(
                          color: Color(0xFFFBF9F1),
                          child: Row(
                            children: [
                              Icon(
                                Icons.manage_accounts_rounded,
                                size: 20,
                                color: Color(0xFF293033),
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Parent Settings',
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF293033),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 334,
                        top: 39,
                        width: 40,
                        height: 40,
                        child: _ProfileHitTarget(
                          label: 'Notifications',
                          onTap: () => showLocalMessage(
                            'No new notifications in the local prototype.',
                          ),
                        ),
                      ),
                      Positioned(
                        left: 40,
                        top: 690,
                        width: 306,
                        height: 58,
                        child: _ProfileHitTarget(
                          label: 'Continue Learning',
                          onTap: continueLearning,
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 1047,
                        width: 350,
                        height: 55,
                        child: _ProfileHitTarget(
                          label: 'Change Avatar',
                          onTap: () => context.go('/shop'),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 1102,
                        width: 350,
                        height: 55,
                        child: _ProfileHitTarget(
                          label: 'Parent Settings',
                          onTap: () => context.go('/parent-settings'),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 1157,
                        width: 350,
                        height: 58,
                        child: _ProfileHitTarget(
                          label: 'Logout',
                          onTap: () async {
                            await ref
                                .read(authFlowControllerProvider.notifier)
                                .signOut();
                            if (context.mounted) context.go('/onboarding');
                          },
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

class _ProfileHeaderOverlay extends StatelessWidget {
  const _ProfileHeaderOverlay();

  @override
  Widget build(BuildContext context) => Positioned(
    left: 0,
    top: 0,
    width: 390,
    height: 90,
    child: const ColoredBox(
      color: Color(0xFFFBF9F1),
      child: Padding(
        padding: EdgeInsets.only(left: 20, top: 35, right: 16),
        child: SizedBox(
          height: 48,
          child: Row(
            children: [
              EquippedBearAvatar(size: 48),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello Guest 👋',
                      maxLines: 1,
                      style: TextStyle(
                        fontFamily: 'BeVietnamPro',
                        fontSize: 14,
                        height: 1.45,
                        color: Color(0xFF483434),
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Get ready to learn AI!',
                        maxLines: 1,
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 22,
                          height: 1.2,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF483434),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12),
              _ProfileHeaderNotification(),
            ],
          ),
        ),
      ),
    ),
  );
}

class _ProfileHeaderNotification extends StatelessWidget {
  const _ProfileHeaderNotification();

  @override
  Widget build(BuildContext context) => Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
      border: Border.all(color: const Color(0xFFDAC2B1)),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Stack(
      alignment: Alignment.center,
      children: [
        SvgPicture.asset(
          'assets/icons/home/notification.svg',
          width: 13.333,
          height: 16.667,
        ),
        Positioned(
          right: 10,
          top: 9.56,
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFFE74C3C),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    ),
  );
}

class _ProfileBearAppearance {
  static String? assetFor(Map<String, String> equippedAccessories) {
    final items = equippedAccessories.values.toSet();
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
}

class _ProfileHeroBase extends StatelessWidget {
  const _ProfileHeroBase();

  @override
  Widget build(BuildContext context) => Positioned(
    left: 20,
    top: 100,
    width: 350,
    height: 266,
    child: ClipRect(
      child: OverflowBox(
        alignment: Alignment.topCenter,
        minHeight: 266,
        maxHeight: 266,
        child: Image.asset(
          'assets/illustrations/profile_hero_base.png',
          width: 350,
          height: 266,
          fit: BoxFit.fill,
        ),
      ),
    ),
  );
}

class _ProfileProgressOverlay extends StatelessWidget {
  const _ProfileProgressOverlay({required this.state});

  final AppViewState state;

  static const _cocoa = Color(0xFF293033);

  @override
  Widget build(BuildContext context) {
    final progressPercent = (state.progress * 100).round();
    return Stack(
      children: [
        _MetricValue(
          left: 43,
          top: 388,
          width: 66,
          background: const Color(0xFFFFCEB8),
          value: '$progressPercent%',
        ),
        _MetricValue(
          left: 161,
          top: 388,
          width: 60,
          background: const Color(0xFFC5A9F6),
          value: '${state.completedSteps}/36',
        ),
        _MetricValue(
          left: 286,
          top: 388,
          width: 52,
          background: const Color(0xFF9DCEE6),
          value: '${_completedUnits()}/5',
        ),
        Positioned(
          left: 42,
          top: 551,
          width: 260,
          height: 20,
          child: ColoredBox(
            color: const Color(0xFFFFFCF5),
            child: Text(
              state.courseStarted
                  ? 'CONTINUE LEARNING'
                  : 'FIRST MISSION · MEET AI CHATBOTS',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'BeVietnamPro',
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFF877365),
              ),
            ),
          ),
        ),
        _MetricValue(
          left: 300,
          top: 624,
          width: 60,
          height: 20,
          background: const Color(0xFFFBF9F1),
          value: '$progressPercent%',
          fontSize: 11,
        ),
        Positioned(
          left: 43,
          top: 647,
          width: 303,
          height: 12,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFFCF5),
              border: Border.all(color: _cocoa, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: state.progress.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF86F6DA),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
        ),
        _TreasureValue(left: 56, value: '${state.honey}'),
        _TreasureValue(left: 179, value: '${state.xp}'),
        _TreasureValue(left: 304, value: '${state.achievements.length}'),
      ],
    );
  }

  int _completedUnits() {
    if (state.completedSteps == 0) return 0;
    if (state.completedSteps >= 36) return 5;
    if (state.completedSteps >= 30) return 4;
    if (state.completedSteps >= 17) return 3;
    if (state.completedSteps >= 8) return 2;
    return 1;
  }
}

class _MetricValue extends StatelessWidget {
  const _MetricValue({
    required this.left,
    required this.top,
    required this.width,
    required this.background,
    required this.value,
    this.fontSize = 17,
    this.height = 27,
  });

  final double left;
  final double top;
  final double width;
  final Color background;
  final String value;
  final double fontSize;
  final double height;

  @override
  Widget build(BuildContext context) => Positioned(
    left: left,
    top: top,
    width: width,
    height: height,
    child: ColoredBox(
      color: background,
      child: Center(
        child: Text(
          value,
          maxLines: 1,
          style: TextStyle(
            fontFamily: 'Fredoka',
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: _ProfileProgressOverlay._cocoa,
          ),
        ),
      ),
    ),
  );
}

class _TreasureValue extends StatelessWidget {
  const _TreasureValue({required this.left, required this.value});

  final double left;
  final String value;

  @override
  Widget build(BuildContext context) => Positioned(
    left: left,
    top: 894,
    width: 42,
    height: 25,
    child: ColoredBox(
      color: const Color(0xFFFFFCF5),
      child: Center(
        child: Text(
          value,
          maxLines: 1,
          style: const TextStyle(
            fontFamily: 'Fredoka',
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF293033),
          ),
        ),
      ),
    ),
  );
}

class _ProfileHitTarget extends StatelessWidget {
  const _ProfileHitTarget({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    label: label,
    button: true,
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
