import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/state/prototype_state.dart';

class CoursesScreen extends ConsumerWidget {
  const CoursesScreen({super.key});

  static const _designWidth = 390.0;
  static const _contentHeight = 1057.0;
  static const _assetHeight = 1139.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(prototypeStateProvider);
    void openCourse() {
      state.startCourse();
      context.go(
        '/activity/${activityIdForStep(state.completedSteps.clamp(1, 34))}',
      );
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

String activityIdForStep(int step) {
  const steps = <int, String>{
    1: 'unit-01-01',
    2: 'unit-01-02',
    4: 'unit-01-03',
    6: 'unit-01-04',
    8: 'unit-02-01',
    10: 'unit-02-02',
    12: 'unit-02-03',
    15: 'unit-03-01',
    17: 'unit-03-02',
    19: 'unit-03-03',
    22: 'unit-04-01',
    24: 'unit-04-02',
    25: 'unit-04-03',
    28: 'unit-04-04',
    30: 'unit-04-05',
    32: 'unit-04-06',
    34: 'unit-04-07',
  };
  final eligible = steps.keys.where((value) => value <= step).toList()..sort();
  return steps[eligible.isEmpty ? 1 : eligible.last]!;
}
