import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/bearfetch_theme.dart';

/// Parent-first entry screen rendered from the approved Figma frame (1:7).
/// The visual stays pixel-aligned to the 390 × 848 design while the controls
/// remain native, accessible Flutter buttons.
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  static const _designWidth = 390.0;
  static const _designHeight = 848.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BearfetchColors.cream,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final scale = math.min(
            constraints.maxWidth / _designWidth,
            constraints.maxHeight / _designHeight,
          );
          final canvasWidth = _designWidth * scale;
          final canvasHeight = _designHeight * scale;
          final horizontalOffset = (constraints.maxWidth - canvasWidth) / 2;

          return Stack(
            fit: StackFit.expand,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: canvasWidth,
                  height: canvasHeight,
                  child: const Image(
                    image: AssetImage(
                      'assets/illustrations/onboarding_01_screen.png',
                    ),
                    fit: BoxFit.fill,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              ),
              Positioned(
                left: horizontalOffset + (30 * scale),
                top: 656 * scale,
                width: 330 * scale,
                height: 58 * scale,
                child: const _FigmaParentButton(),
              ),
              Positioned(
                left: horizontalOffset + (30 * scale),
                top: 725 * scale,
                width: 330 * scale,
                height: 56 * scale,
                child: const _FigmaSignInButton(),
              ),
              _DesignButton(
                semanticLabel: "I'm a Parent",
                left: horizontalOffset + (30 * scale),
                top: 656 * scale,
                width: 330 * scale,
                height: 60 * scale,
                onPressed: () => context.go('/signup/account'),
              ),
              _DesignButton(
                semanticLabel: 'Sign in',
                left: horizontalOffset + (30 * scale),
                top: 725 * scale,
                width: 330 * scale,
                height: 58 * scale,
                onPressed: () => context.go('/signup/account?mode=sign-in'),
              ),
              _OnboardingCopy(
                left: horizontalOffset + (54 * scale),
                top: 480 * scale,
                width: 282 * scale,
                height: 145 * scale,
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Visuals from Figma node 1:170. Kept separate from the transparent
/// [_DesignButton] overlay so native navigation and semantics remain intact.
class _FigmaParentButton extends StatelessWidget {
  const _FigmaParentButton();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFE8762B),
        border: Border.all(color: const Color(0xFFC05E1A), width: 2),
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(color: Color(0xFFC05E1A), offset: Offset(0, 4)),
          BoxShadow(
            color: Color.fromRGBO(232, 118, 43, 0.28),
            offset: Offset(0, 6),
            blurRadius: 18,
          ),
        ],
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/illustrations/onboarding_parent_icon.svg',
              width: 20,
              height: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              "I'm a Parent",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Fredoka',
                fontSize: 17,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.1,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Visuals from Figma node 1:177.
class _FigmaSignInButton extends StatelessWidget {
  const _FigmaSignInButton();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F0),
        border: Border.all(color: const Color(0xFFC07040), width: 2),
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(192, 112, 64, 0.35),
            offset: Offset(0, 3),
          ),
          BoxShadow(
            color: Color.fromRGBO(92, 51, 23, 0.08),
            offset: Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: const Center(
        child: Text(
          'Sign in',
          style: TextStyle(
            color: Color(0xFF5C3317),
            fontFamily: 'Fredoka',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.1,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}

/// The approved onboarding artwork contains legacy copy. Cover only its text
/// area and render current product language as accessible native Flutter text.
class _OnboardingCopy extends StatelessWidget {
  const _OnboardingCopy({
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
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: Semantics(
        label:
            'AI Adventures for young learners. Create a family account, add your child\'s learner profile, and start the first AI-mission.',
        child: ExcludeSemantics(
          child: FittedBox(
            fit: BoxFit.fill,
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: _designCopyWidth,
              height: _designCopyHeight,
              child: Column(
                children: [
                  SizedBox(
                    width: _designCopyWidth,
                    height: 54,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.topCenter,
                      child: const Text(
                        'AI Adventures for\nyoung learners',
                        textAlign: TextAlign.center,
                        textScaler: TextScaler.noScaling,
                        style: TextStyle(
                          color: BearfetchColors.cocoa,
                          fontFamily: 'Fredoka',
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 9),
                  SizedBox(
                    width: _designCopyWidth,
                    height: 70,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.topCenter,
                      child: const Text(
                        "Create a family account, add your\nchild's learner profile, and start\nthe first AI-mission.",
                        textAlign: TextAlign.center,
                        textScaler: TextScaler.noScaling,
                        style: TextStyle(
                          color: BearfetchColors.bodyBrown,
                          fontFamily: 'Nunito',
                          fontSize: 13,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static const _designCopyWidth = 282.0;
  static const _designCopyHeight = 145.0;
}

class _DesignButton extends StatelessWidget {
  const _DesignButton({
    required this.semanticLabel,
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.onPressed,
  });

  final String semanticLabel;
  final double left;
  final double top;
  final double width;
  final double height;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: Semantics(
        button: true,
        label: semanticLabel,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(height / 2),
          ),
        ),
      ),
    );
  }
}
