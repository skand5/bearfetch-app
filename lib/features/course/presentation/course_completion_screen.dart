import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/state/app_state.dart';

class CourseCompletionScreen extends ConsumerWidget {
  const CourseCompletionScreen({super.key});

  // The supplied Figma frame is 391 × 1563, with the actual designed page
  // ending at y=1289. The remainder is the Figma canvas, not app content.
  static const _designWidth = 391.0;
  static const _designHeight = 1289.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appViewStateProvider);
    // Course rewards are committed by Finish Course. Preview the actual total
    // the learner will have after that idempotent operation, rather than
    // presenting static currency figures in the completion artwork.
    final courseAwarded = state.achievements.contains('ai-explorer-badge');
    final totalHoney = state.honey + (courseAwarded ? 0 : 50);
    final totalXp = state.xp + (courseAwarded ? 0 : 100);
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
                            const Positioned(
                              left: 0,
                              top: 0,
                              width: _designWidth,
                              height: 1563,
                              child: Image(
                                image: AssetImage(
                                  'assets/illustrations/course_completion_figma.png',
                                ),
                                fit: BoxFit.fill,
                                filterQuality: FilterQuality.high,
                              ),
                            ),
                            _CompletionRewards(honey: totalHoney, xp: totalXp),
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
                              left: 20,
                              top: 1212,
                              width: 351,
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

class _CompletionRewards extends StatelessWidget {
  const _CompletionRewards({required this.honey, required this.xp});

  final int honey;
  final int xp;

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      _DynamicRewardTotal(
        left: 29,
        top: 1106,
        width: 148,
        label: '$honey Honey Jars',
        semanticLabel: 'Total honey jars: $honey',
      ),
      _DynamicRewardTotal(
        left: 213,
        top: 1106,
        width: 148,
        label: '$xp XP',
        semanticLabel: 'Total XP: $xp',
      ),
    ],
  );
}

class _DynamicRewardTotal extends StatelessWidget {
  const _DynamicRewardTotal({
    required this.left,
    required this.top,
    required this.width,
    required this.label,
    required this.semanticLabel,
  });

  final double left;
  final double top;
  final double width;
  final String label;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) => Positioned(
    left: left,
    top: top,
    width: width,
    height: 29,
    child: Semantics(
      label: semanticLabel,
      child: Container(
        color: const Color(0xFFFBF9F1),
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            maxLines: 1,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: Color(0xFF293033),
            ),
          ),
        ),
      ),
    ),
  );
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
