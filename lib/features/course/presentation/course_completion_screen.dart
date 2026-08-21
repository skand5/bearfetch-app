import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/state/app_state.dart';

class CourseCompletionScreen extends ConsumerWidget {
  const CourseCompletionScreen({super.key});

  static const _designWidth = 390.0;
  static const _designHeight = 1562.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F0),
      body: SafeArea(
        bottom: false,
        child: MediaQuery.withNoTextScaling(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final scale = constraints.maxWidth / _designWidth;
              return Semantics(
                label: 'Course Complete!',
                container: true,
                explicitChildNodes: true,
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: constraints.maxWidth,
                    height: _designHeight * scale,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        width: _designWidth,
                        height: _designHeight,
                        child: Stack(
                          children: [
                            const Positioned.fill(
                              child: Image(
                                image: AssetImage(
                                  'assets/illustrations/course_completion.png',
                                ),
                                fit: BoxFit.fill,
                                filterQuality: FilterQuality.high,
                              ),
                            ),
                            _CompletionHitTarget(
                              label: 'Close',
                              left: 4,
                              top: 0,
                              width: 48,
                              height: 58,
                              onTap: () => context.go('/home'),
                            ),
                            _CompletionHitTarget(
                              label: 'Share course completion',
                              left: 334,
                              top: 0,
                              width: 56,
                              height: 58,
                              onTap: () {
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Course completion sharing will be connected after backend setup.',
                                      ),
                                    ),
                                  );
                              },
                            ),
                            _CompletionHitTarget(
                              label: 'Finish Course',
                              left: 18,
                              top: 1490,
                              width: 354,
                              height: 60,
                              onTap: () async {
                                await ref
                                    .read(appStateControllerProvider.notifier)
                                    .completeCourse();
                                if (context.mounted) context.go('/home');
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _CompletionHitTarget extends StatelessWidget {
  const _CompletionHitTarget({
    required this.label,
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.onTap,
  });

  final String label;
  final double left;
  final double top;
  final double width;
  final double height;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: Semantics(
        button: true,
        label: label,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
        ),
      ),
    );
  }
}
