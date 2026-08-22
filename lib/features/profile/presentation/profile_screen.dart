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
