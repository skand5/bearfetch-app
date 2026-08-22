import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/bearfetch_theme.dart';
import '../../../domain/repositories/app_repositories.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: BearfetchColors.cream,
      body: _OnboardingCanvas(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(28, 36, 28, 24),
            child: Column(
              children: [
                const _BrandLockup(),
                const SizedBox(height: 5),
                const _Tag(label: 'Free for K–12 learners'),
                const SizedBox(height: 32),
                const _HeroIllustration(),
                const SizedBox(height: 30),
                Text(
                  'Coding adventures for\nyoung learners',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 12),
                const Text(
                  "Create a family account, add your child's\nlearner profile, and start the first coding\nmission.",
                  textAlign: TextAlign.center,
                  style: BearfetchTheme.bodyTextStyle,
                ),
                const SizedBox(height: 34),
                _PrimaryButton(
                  label: "I'm a Parent",
                  icon: Icons.family_restroom_rounded,
                  onPressed: () => context.go('/signup/account'),
                ),
                const SizedBox(height: 14),
                _SecondaryButton(
                  label: 'Sign in',
                  onPressed: () => context.go(
                    ref.read(authRepositoryProvider).requiresAuthentication
                        ? '/signup/account'
                        : '/home-started',
                  ),
                ),
                const SizedBox(height: 16),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock_outline_rounded,
                      size: 14,
                      color: Color(0xFF986B49),
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Children do not need an email or phone number.',
                      style: TextStyle(color: Color(0xFF986B49), fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardingCanvas extends StatelessWidget {
  const _OnboardingCanvas({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      const ColoredBox(color: BearfetchColors.cream),
      const Positioned(
        top: -48,
        left: -42,
        child: _Blob(size: 176, color: Color(0xFFFFE1C5)),
      ),
      const Positioned(
        top: 150,
        right: -60,
        child: _Blob(size: 166, color: Color(0xFFDDF1E5)),
      ),
      const Positioned(
        bottom: -65,
        left: -48,
        child: _Blob(size: 168, color: Color(0xFFFCE7A8)),
      ),
      const Positioned(
        bottom: -58,
        right: -50,
        child: _Blob(size: 150, color: Color(0xFFE9DBF0)),
      ),
      child,
    ],
  );
}

class _Blob extends StatelessWidget {
  const _Blob({required this.size, required this.color});
  final double size;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}

class _BrandLockup extends StatelessWidget {
  const _BrandLockup();
  @override
  Widget build(BuildContext context) => const Image(
    image: AssetImage('assets/illustrations/bearfetch_brand.png'),
    width: 330,
    height: 42,
    filterQuality: FilterQuality.high,
  );
}

class _HeroIllustration extends StatelessWidget {
  const _HeroIllustration();
  @override
  Widget build(BuildContext context) => const SizedBox(
    height: 302,
    child: Image(
      image: AssetImage('assets/illustrations/onboarding_hero.png'),
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    ),
  );
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    decoration: BoxDecoration(
      color: BearfetchColors.honey,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      label,
      style: const TextStyle(
        fontFamily: 'Nunito',
        color: Color(0xFF7A4A10),
        fontWeight: FontWeight.w700,
        fontSize: 12,
      ),
    ),
  );
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.onPressed,
    this.icon,
  });
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 58,
    child: ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: BearfetchColors.orange,
        foregroundColor: Colors.white,
        elevation: 3,
        shadowColor: BearfetchColors.orangeDark,
        textStyle: const TextStyle(
          fontFamily: 'Fredoka',
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
        shape: const StadiumBorder(),
      ),
    ),
  );
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 56,
    child: OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: BearfetchColors.brown,
        side: const BorderSide(color: BearfetchColors.orange, width: 2),
        textStyle: const TextStyle(
          fontFamily: 'Fredoka',
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      child: Text(label),
    ),
  );
}
