import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/state/app_state.dart';
import '../../../core/state/auth_state.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  static const _designWidth = 390.0;
  static const _contentHeight = 1320.0;
  static const _assetHeight = 1400.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appViewStateProvider);

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
                        top: 0,
                        width: _designWidth,
                        height: _assetHeight,
                        child: Image(
                          image: AssetImage('assets/illustrations/profile.png'),
                          fit: BoxFit.fill,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                      _ProfileProgressOverlay(state: state),
                      Positioned(
                        left: 326,
                        top: 8,
                        width: 48,
                        height: 52,
                        child: _ProfileHitTarget(
                          label: 'Notifications',
                          onTap: () => showLocalMessage(
                            'No new notifications in the local prototype.',
                          ),
                        ),
                      ),
                      Positioned(
                        left: 40,
                        top: 675,
                        width: 306,
                        height: 58,
                        child: _ProfileHitTarget(
                          label: 'Continue Learning',
                          onTap: continueLearning,
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 1032,
                        width: 350,
                        height: 55,
                        child: _ProfileHitTarget(
                          label: 'Change Avatar',
                          onTap: () => context.go('/shop'),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 1087,
                        width: 350,
                        height: 55,
                        child: _ProfileHitTarget(
                          label: 'Parent settings',
                          onTap: () => context.go('/parent-settings'),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 1142,
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
          left: 310,
          top: 624,
          width: 35,
          background: const Color(0xFFFFFCF5),
          value: '$progressPercent%',
          fontSize: 11,
        ),
        Positioned(
          left: 43,
          top: 647,
          width: 298,
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
  });

  final double left;
  final double top;
  final double width;
  final Color background;
  final String value;
  final double fontSize;

  @override
  Widget build(BuildContext context) => Positioned(
    left: left,
    top: top,
    width: width,
    height: 27,
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
