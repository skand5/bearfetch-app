import 'dart:math' as math;

import 'package:flutter/material.dart';
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
            ],
          );
        },
      ),
    );
  }
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
