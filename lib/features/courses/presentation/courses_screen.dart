import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/state/app_state.dart';

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
                      _CourseProgressOverlay(progress: state.progress),
                      Positioned(
                        left: 326,
                        top: 16,
                        width: 48,
                        height: 48,
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
                          label: 'Continue Course',
                          onTap: openCourse,
                        ),
                      ),
                      Positioned(
                        left: 96,
                        top: 521,
                        width: 198,
                        height: 46,
                        child: _CourseHitTarget(
                          label: 'View Course Path',
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
          color: const Color(0xFF9DCEE6),
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
