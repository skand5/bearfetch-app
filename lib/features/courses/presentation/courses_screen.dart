import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/state/app_state.dart';
import '../../../core/widgets/equipped_bear_avatar.dart';

class CoursesScreen extends ConsumerWidget {
  const CoursesScreen({super.key});

  static const _designWidth = 390.0;
  static const _contentHeight = 1057.0;
  static const _assetHeight = 1139.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appViewStateProvider);
    void openCourse() {
      context.go(state.nextCourseRoute);
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
                          image: AssetImage(
                            'assets/illustrations/courses_page.png',
                          ),
                          fit: BoxFit.fill,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                      const Positioned(
                        left: 40,
                        top: 251,
                        width: 230,
                        height: 42,
                        child: _CourseAudienceBadges(),
                      ),
                      const _CoursesHeaderOverlay(),
                      const Positioned(
                        left: 100,
                        top: 521,
                        width: 198,
                        height: 46,
                        child: ColoredBox(color: Color(0xFFA0D2EB)),
                      ),
                      const Positioned(
                        left: 100,
                        top: 533,
                        width: 190,
                        height: 35,
                        child: ColoredBox(color: Color(0xFFA0D2EB)),
                      ),
                      if (state.completedSteps >= 36)
                        const _CoursesFinishedButton(),
                      _CourseProgressOverlay(progress: state.progress),
                      Positioned(
                        left: 334,
                        top: 39,
                        width: 40,
                        height: 40,
                        child: _CourseHitTarget(
                          label: 'Notifications',
                          onTap: () {},
                        ),
                      ),
                      Positioned(
                        left: 45,
                        top: 454,
                        width: 300,
                        height: 70,
                        child: _CourseHitTarget(
                          label: state.completedSteps >= 36
                              ? 'Course Finished!'
                              : 'Continue Course',
                          onTap: openCourse,
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

class _CourseAudienceBadges extends StatelessWidget {
  const _CourseAudienceBadges();

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: const Color(0xFFA0D2EB),
    child: const Padding(
      padding: EdgeInsets.only(left: 7),
      child: Row(
        children: [
          _CourseAudienceBadge(label: 'AI Course', width: 85),
          SizedBox(width: 8),
          _CourseAudienceBadge(label: 'K-12 Friendly', width: 124),
        ],
      ),
    ),
  );
}

class _CourseAudienceBadge extends StatelessWidget {
  const _CourseAudienceBadge({required this.label, required this.width});

  final String label;
  final double width;

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: 30,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: const Color(0xFFFBF9F1),
      border: Border.all(color: const Color(0xFF293033), width: 2),
      borderRadius: BorderRadius.circular(15),
    ),
    child: FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        label,
        textScaler: TextScaler.noScaling,
        style: const TextStyle(
          fontFamily: 'BeVietnamPro',
          fontWeight: FontWeight.w600,
          fontSize: 12,
          color: Color(0xFF293033),
        ),
      ),
    ),
  );
}

class _CoursesHeaderOverlay extends StatelessWidget {
  const _CoursesHeaderOverlay();

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
              _CoursesHeaderNotification(),
            ],
          ),
        ),
      ),
    ),
  );
}

class _CoursesHeaderNotification extends StatelessWidget {
  const _CoursesHeaderNotification();

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

class _CoursesFinishedButton extends StatelessWidget {
  const _CoursesFinishedButton();

  @override
  Widget build(BuildContext context) => const Positioned(
    left: 95,
    top: 467,
    width: 200,
    height: 38,
    child: ColoredBox(
      color: Color(0xFFFF9F43),
      child: Center(
        child: Text(
          'Course Finished!',
          style: TextStyle(
            fontFamily: 'BeVietnamPro',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF6D3A00),
          ),
        ),
      ),
    ),
  );
}

class _CourseProgressOverlay extends StatelessWidget {
  const _CourseProgressOverlay({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Positioned(
        left: 310,
        top: 398,
        width: 38,
        height: 21,
        child: ColoredBox(
          color: const Color(0xFFA0D2EB),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${(progress * 100).round()}%',
              style: const TextStyle(
                fontFamily: 'Fredoka',
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: Color(0xFF293033),
              ),
            ),
          ),
        ),
      ),
      Positioned(
        left: 47,
        top: 419,
        width: 296,
        height: 13,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8F7F0),
            border: Border.all(color: const Color(0xFF293033), width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF86F6DA),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

class _CourseHitTarget extends StatelessWidget {
  const _CourseHitTarget({required this.label, required this.onTap});

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
