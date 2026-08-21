import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/state/app_state.dart';

abstract final class _HomeColors {
  static const canvas = Color(0xFFFDF6EC);
  static const cocoa = Color(0xFF483434);
  static const secondaryText = Color(0xFF877365);
  static const hero = Color(0xFFB4E6C9);
  static const mintText = Color(0xFF006B59);
  static const orange = Color(0xFFFF9F43);
  static const orangeBorder = Color(0xFF8F4E00);
  static const orangeText = Color(0xFF6D3A00);
  static const chip = Color(0xFFF6F5EF);
  static const beginner = Color(0xFF86F6DA);
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appViewStateProvider);
    return MediaQuery.withNoTextScaling(
      child: ColoredBox(
        color: _HomeColors.canvas,
        child: SafeArea(
          bottom: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final designWidth = constraints.maxWidth <= 480
                  ? constraints.maxWidth
                  : 390.0;
              final scale = designWidth / 390;
              return Center(
                child: SizedBox(
                  width: designWidth,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      _HomeHeader(name: state.learnerName, scale: scale),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          20 * scale,
                          32 * scale,
                          20 * scale,
                          32 * scale,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _MissionCard(
                              scale: scale,
                              started: state.courseStarted,
                              step: state.completedSteps,
                              onPressed: () {
                                context.go(state.nextCourseRoute);
                              },
                            ),
                            SizedBox(height: 32 * scale),
                            _SectionLabel(
                              label: 'RECOMMENDED COURSE',
                              scale: scale,
                            ),
                            SizedBox(height: 16 * scale),
                            _CourseCard(
                              scale: scale,
                              progress: state.progress,
                              started: state.courseStarted,
                              onPressed: () => context.go('/courses'),
                            ),
                            SizedBox(height: 32 * scale),
                            _SectionLabel(label: 'DAILY QUEST', scale: scale),
                            SizedBox(height: 16 * scale),
                            _QuestCard(
                              scale: scale,
                              onPressed: () =>
                                  context.go('/activity/unit-01-01'),
                            ),
                          ],
                        ),
                      ),
                    ],
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

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.name, required this.scale});
  final String name;
  final double scale;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 81 * scale,
    child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20 * scale,
        vertical: 16 * scale,
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/home/avatar.svg',
            width: 47.89 * scale,
            height: 48 * scale,
          ),
          SizedBox(width: 12 * scale),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello $name 👋',
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: 'BeVietnamPro',
                    fontWeight: FontWeight.w400,
                    fontSize: 14 * scale,
                    height: 1.45,
                    color: _HomeColors.cocoa,
                  ),
                ),
                Transform.translate(
                  offset: Offset(0, -0.75 * scale),
                  child: Text(
                    'Good Morning',
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontWeight: FontWeight.w800,
                      fontSize: 22 * scale,
                      height: 1.25,
                      color: _HomeColors.cocoa,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Semantics(
            button: true,
            label: 'Notifications',
            child: InkWell(
              borderRadius: BorderRadius.circular(12 * scale),
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No new notifications.')),
              ),
              child: Container(
                width: 40 * scale,
                height: 40 * scale,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFFDAC2B1),
                    width: scale,
                  ),
                  borderRadius: BorderRadius.circular(12 * scale),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/home/notification.svg',
                      width: 13.333 * scale,
                      height: 16.667 * scale,
                    ),
                    Positioned(
                      right: 10 * scale,
                      top: 9.56 * scale,
                      child: Container(
                        width: 8 * scale,
                        height: 8 * scale,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE74C3C),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _MissionCard extends StatelessWidget {
  const _MissionCard({
    required this.scale,
    required this.started,
    required this.step,
    required this.onPressed,
  });
  final double scale;
  final bool started;
  final int step;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: _HomeColors.hero,
      border: Border.all(color: _HomeColors.cocoa, width: 3 * scale),
      borderRadius: BorderRadius.circular(32 * scale),
      boxShadow: [
        BoxShadow(
          color: _HomeColors.cocoa,
          offset: Offset(0, 4 * scale),
          blurRadius: 0,
        ),
      ],
    ),
    clipBehavior: Clip.antiAlias,
    child: Stack(
      children: [
        Positioned(
          right: -44.33 * scale,
          top: -43.1 * scale,
          child: Image.asset(
            'assets/icons/home/hero_bot.png',
            width: 144.119 * scale,
            height: 148.312 * scale,
          ),
        ),
        Positioned(
          right: 80 * scale,
          bottom: 16 * scale,
          child: Opacity(
            opacity: 0.4,
            child: SvgPicture.asset(
              'assets/icons/home/hero_sparkle.svg',
              width: 30 * scale,
              height: 28.5 * scale,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(27 * scale),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12 * scale,
                  vertical: 6 * scale,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(999 * scale),
                ),
                child: Text(
                  started ? '🚀 CONTINUE LEARNING' : '🚀 FIRST MISSION',
                  style: TextStyle(
                    fontFamily: 'BeVietnamPro',
                    fontWeight: FontWeight.w400,
                    fontSize: 11 * scale,
                    height: 1.5,
                    letterSpacing: 0.55 * scale,
                    color: _HomeColors.mintText,
                  ),
                ),
              ),
              SizedBox(height: 16 * scale),
              Text(
                started ? 'Talking to a Bot' : 'Meet AI Chatbots',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontWeight: FontWeight.w800,
                  fontSize: 32 * scale,
                  height: 1.25,
                  letterSpacing: -0.64 * scale,
                  color: _HomeColors.cocoa,
                ),
              ),
              SizedBox(height: 12 * scale),
              Text(
                started
                    ? 'Try a simple question and see how an AI chatbot responds.'
                    : 'Learn where AI chatbots appear in games, apps, search, and everyday life.',
                style: TextStyle(
                  fontFamily: 'BeVietnamPro',
                  fontWeight: FontWeight.w500,
                  fontSize: 16 * scale,
                  height: 1.625,
                  color: _HomeColors.cocoa.withValues(alpha: 0.8),
                ),
              ),
              if (started) ...[
                SizedBox(height: 10 * scale),
                Text(
                  'Step $step of 36',
                  style: TextStyle(
                    fontFamily: 'BeVietnamPro',
                    fontWeight: FontWeight.w500,
                    fontSize: 12 * scale,
                    color: _HomeColors.cocoa,
                  ),
                ),
              ],
              SizedBox(height: 12 * scale),
              _FigmaButton(
                scale: scale,
                height: 60,
                label: started ? 'Continue Mission' : 'Start First Mission',
                iconAsset: 'assets/icons/home/play.svg',
                backgroundColor: _HomeColors.orange,
                foregroundColor: _HomeColors.orangeText,
                borderColor: _HomeColors.orangeBorder,
                shadowColor: const Color(0x4D8F4E00),
                onPressed: onPressed,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, required this.scale});
  final String label;
  final double scale;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(left: 8 * scale),
    child: Text(
      label,
      style: TextStyle(
        fontFamily: 'BeVietnamPro',
        fontWeight: FontWeight.w500,
        fontSize: 16 * scale,
        height: 1.5,
        letterSpacing: 1.6 * scale,
        color: _HomeColors.secondaryText,
      ),
    ),
  );
}

class _CourseCard extends StatelessWidget {
  const _CourseCard({
    required this.scale,
    required this.progress,
    required this.started,
    required this.onPressed,
  });
  final double scale;
  final double progress;
  final bool started;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => _HardShadowCard(
    scale: scale,
    radius: 24,
    padding: 27,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'From Understanding\nto Building LLMs',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontWeight: FontWeight.w700,
            fontSize: 20 * scale,
            height: 1.4,
            color: _HomeColors.cocoa,
          ),
        ),
        SizedBox(height: 8 * scale),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _MetadataChip(label: '36 steps', scale: scale),
              SizedBox(width: 10 * scale),
              _MetadataChip(
                label: 'Beginner',
                scale: scale,
                background: _HomeColors.beginner,
                foreground: const Color(0xFF00705D),
              ),
              SizedBox(width: 10 * scale),
              _MetadataChip(label: '5 units', scale: scale),
            ],
          ),
        ),
        SizedBox(height: 20 * scale),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _BodyText(text: 'Progress', scale: scale),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: _BodyText(
                  text: '${(progress * 100).round()}% complete',
                  scale: scale,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8 * scale),
        _OutlinedProgress(value: progress, scale: scale),
        SizedBox(height: 20 * scale),
        _FigmaButton(
          scale: scale,
          height: 48,
          label: started ? 'Continue Course' : 'View Course',
          iconAsset: 'assets/icons/home/arrow_right.svg',
          backgroundColor: Colors.white,
          foregroundColor: _HomeColors.cocoa,
          borderColor: _HomeColors.cocoa,
          shadowColor: _HomeColors.cocoa,
          fontFamily: 'BeVietnamPro',
          fontWeight: FontWeight.w500,
          fontSize: 16,
          onPressed: onPressed,
        ),
      ],
    ),
  );
}

class _QuestCard extends StatelessWidget {
  const _QuestCard({required this.scale, required this.onPressed});
  final double scale;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => _HardShadowCard(
    scale: scale,
    radius: 24,
    padding: 23,
    clip: true,
    child: Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        Positioned(
          right: -39 * scale,
          top: -39 * scale,
          child: SvgPicture.asset(
            'assets/icons/home/quest_star.svg',
            width: 88 * scale,
            height: 90 * scale,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 4 * scale),
              child: Container(
                width: 48 * scale,
                height: 48 * scale,
                decoration: BoxDecoration(
                  color: const Color(0xFFEBDCFF),
                  border: Border.all(
                    color: _HomeColors.cocoa,
                    width: 2 * scale,
                  ),
                  borderRadius: BorderRadius.circular(12 * scale),
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  'assets/icons/home/quest_badge.svg',
                  width: 10 * scale,
                  height: 20 * scale,
                ),
              ),
            ),
            SizedBox(width: 16 * scale),
            Expanded(
              child: SizedBox(
                height: 108 * scale,
                child: OverflowBox(
                  alignment: Alignment.topLeft,
                  maxWidth: 263 * scale,
                  maxHeight: 108 * scale,
                  child: SizedBox(
                    width: 263 * scale,
                    height: 108 * scale,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Complete 1 short AI lesson',
                          maxLines: 1,
                          style: TextStyle(
                            fontFamily: 'BeVietnamPro',
                            fontWeight: FontWeight.w500,
                            fontSize: 16 * scale,
                            height: 1.5,
                            color: _HomeColors.cocoa,
                          ),
                        ),
                        SizedBox(height: 4 * scale),
                        Text(
                          'Reward: +10 XP · +5 honey jars',
                          maxLines: 1,
                          style: TextStyle(
                            fontFamily: 'BeVietnamPro',
                            fontWeight: FontWeight.w500,
                            fontSize: 16 * scale,
                            height: 1.5,
                            color: _HomeColors.secondaryText,
                          ),
                        ),
                        SizedBox(height: 12 * scale),
                        SizedBox(
                          height: 44 * scale,
                          child: FilledButton(
                            onPressed: onPressed,
                            style: FilledButton.styleFrom(
                              backgroundColor: _HomeColors.cocoa,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 26 * scale,
                                vertical: 10 * scale,
                              ),
                              shape: const StadiumBorder(),
                              textStyle: TextStyle(
                                fontFamily: 'BeVietnamPro',
                                fontWeight: FontWeight.w500,
                                fontSize: 16 * scale,
                                height: 1.5,
                              ),
                            ),
                            child: const Text('Begin'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _HardShadowCard extends StatelessWidget {
  const _HardShadowCard({
    required this.scale,
    required this.radius,
    required this.padding,
    required this.child,
    this.clip = false,
  });
  final double scale;
  final double radius;
  final double padding;
  final Widget child;
  final bool clip;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: EdgeInsets.all(padding * scale),
      child: child,
    );
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _HomeColors.cocoa, width: 3 * scale),
        borderRadius: BorderRadius.circular(radius * scale),
        boxShadow: [
          BoxShadow(
            color: _HomeColors.cocoa,
            offset: Offset(0, 4 * scale),
            blurRadius: 0,
          ),
        ],
      ),
      child: clip
          ? ClipRRect(
              borderRadius: BorderRadius.circular((radius - 3) * scale),
              child: content,
            )
          : content,
    );
  }
}

class _MetadataChip extends StatelessWidget {
  const _MetadataChip({
    required this.label,
    required this.scale,
    this.background = _HomeColors.chip,
    this.foreground = const Color(0xFF544437),
  });
  final String label;
  final double scale;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) => Container(
    height: 36 * scale,
    padding: EdgeInsets.symmetric(horizontal: 14 * scale),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: background,
      border: Border.all(color: _HomeColors.cocoa, width: 2 * scale),
      borderRadius: BorderRadius.circular(999 * scale),
    ),
    child: Text(
      label,
      style: TextStyle(
        fontFamily: 'BeVietnamPro',
        fontWeight: FontWeight.w500,
        fontSize: 16 * scale,
        height: 1.5,
        color: foreground,
      ),
    ),
  );
}

class _BodyText extends StatelessWidget {
  const _BodyText({required this.text, required this.scale});
  final String text;
  final double scale;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontFamily: 'BeVietnamPro',
      fontWeight: FontWeight.w500,
      fontSize: 16 * scale,
      height: 1.5,
      color: _HomeColors.cocoa,
    ),
  );
}

class _OutlinedProgress extends StatelessWidget {
  const _OutlinedProgress({required this.value, required this.scale});
  final double value;
  final double scale;

  @override
  Widget build(BuildContext context) => Container(
    height: 16 * scale,
    padding: EdgeInsets.all(2 * scale),
    decoration: BoxDecoration(
      color: _HomeColors.chip,
      border: Border.all(color: _HomeColors.cocoa, width: 2 * scale),
      borderRadius: BorderRadius.circular(999 * scale),
    ),
    alignment: Alignment.centerLeft,
    child: FractionallySizedBox(
      widthFactor: value == 0 ? 0.02 : value.clamp(0.02, 1),
      child: Container(
        decoration: BoxDecoration(
          color: _HomeColors.orange,
          borderRadius: BorderRadius.circular(999 * scale),
        ),
      ),
    ),
  );
}

class _FigmaButton extends StatelessWidget {
  const _FigmaButton({
    required this.scale,
    required this.height,
    required this.label,
    required this.iconAsset,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderColor,
    required this.shadowColor,
    required this.onPressed,
    this.fontFamily = 'PlusJakartaSans',
    this.fontWeight = FontWeight.w700,
    this.fontSize = 20,
  });
  final double scale;
  final double height;
  final String label;
  final String iconAsset;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;
  final Color shadowColor;
  final VoidCallback onPressed;
  final String fontFamily;
  final FontWeight fontWeight;
  final double fontSize;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label,
    child: Container(
      height: height * scale,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor, width: 2 * scale),
        borderRadius: BorderRadius.circular(999 * scale),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            offset: Offset(0, 4 * scale),
            blurRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(999 * scale),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                iconAsset,
                width: (iconAsset.endsWith('play.svg') ? 11 : 16) * scale,
                height: (iconAsset.endsWith('play.svg') ? 14 : 16) * scale,
              ),
              SizedBox(width: 8 * scale),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontWeight: fontWeight,
                      fontSize: fontSize * scale,
                      height: 1.4,
                      color: foregroundColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
