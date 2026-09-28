import 'package:flutter/material.dart';

import '../theme/bearfetch_theme.dart';
import 'equipped_bear_avatar.dart';

class BearfetchHeader extends StatelessWidget {
  const BearfetchHeader({
    super.key,
    required this.name,
    this.showNotification = true,
  });
  final String name;
  final bool showNotification;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
    child: Row(
      children: [
        const EquippedBearAvatar(size: 48),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello $name 👋',
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 14,
                  color: Color(0xFF6D5042),
                ),
              ),
              const Text(
                'Good Morning',
                style: TextStyle(
                  fontFamily: 'Fredoka',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: BearfetchColors.cocoa,
                ),
              ),
            ],
          ),
        ),
        if (showNotification)
          IconButton.filledTonal(
            tooltip: 'Notifications',
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No new notifications.')),
            ),
            icon: const Icon(Icons.notifications_none_rounded),
          ),
      ],
    ),
  );
}

class BearfetchCard extends StatelessWidget {
  const BearfetchCard({
    super.key,
    required this.child,
    this.color = const Color(0xFFFFFBF5),
    this.padding = const EdgeInsets.all(18),
    this.borderColor = const Color(0x335C3317),
  });
  final Widget child;
  final Color color;
  final EdgeInsets padding;
  final Color borderColor;

  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: BoxDecoration(
      color: color,
      border: Border.all(color: borderColor, width: 2),
      borderRadius: BorderRadius.circular(22),
      boxShadow: const [
        BoxShadow(
          color: Color(0x183D2314),
          offset: Offset(0, 4),
          blurRadius: 0,
        ),
      ],
    ),
    child: child,
  );
}

class BearfetchPrimaryButton extends StatelessWidget {
  const BearfetchPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.enabled = true,
  });
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool enabled;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 56,
    child: ElevatedButton.icon(
      onPressed: enabled ? onPressed : null,
      icon: icon == null ? const SizedBox.shrink() : Icon(icon, size: 20),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: BearfetchColors.orange,
        foregroundColor: Colors.white,
        disabledBackgroundColor: const Color(0xFFD4A882),
        disabledForegroundColor: Colors.white,
        elevation: enabled ? 3 : 0,
        shadowColor: BearfetchColors.orangeDark,
        shape: const StadiumBorder(),
        textStyle: const TextStyle(
          fontFamily: 'Fredoka',
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );
}

class RewardPills extends StatelessWidget {
  const RewardPills({super.key, this.xp = 10, this.honey = 5});
  final int xp;
  final int honey;
  @override
  Widget build(BuildContext context) => Wrap(
    alignment: WrapAlignment.center,
    spacing: 10,
    runSpacing: 8,
    children: [
      _RewardPill(
        icon: Icons.star_rounded,
        label: '+$xp XP',
        color: const Color(0xFF63C08C),
      ),
      _RewardPill(
        icon: Icons.hive_rounded,
        label: '+$honey Honey Jars',
        color: BearfetchColors.orange,
      ),
    ],
  );
}

class _RewardPill extends StatelessWidget {
  const _RewardPill({
    required this.icon,
    required this.label,
    required this.color,
  });
  final IconData icon;
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: const Color(0xFF857266), width: 1.5),
      borderRadius: BorderRadius.circular(99),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w800,
            color: Color(0xFF4B4038),
          ),
        ),
      ],
    ),
  );
}

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.label, {super.key});
  final String label;
  @override
  Widget build(BuildContext context) => Text(
    label.toUpperCase(),
    style: const TextStyle(
      fontFamily: 'Nunito',
      color: Color(0xFF9B8171),
      letterSpacing: 1.6,
      fontSize: 13,
      fontWeight: FontWeight.w800,
    ),
  );
}
