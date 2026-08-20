import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    const paths = ['/home', '/courses', '/shop', '/profile'];
    final selectedIndex = paths.indexWhere(path.startsWith);
    return Scaffold(
      body: child,
      bottomNavigationBar: _FigmaBottomNavigation(
        selectedIndex: selectedIndex < 0 ? 0 : selectedIndex,
        onSelected: (index) => context.go(paths[index]),
      ),
    );
  }
}

class _FigmaBottomNavigation extends StatelessWidget {
  const _FigmaBottomNavigation({
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const _items = [
    _NavigationItem(
      label: 'Home',
      asset: 'assets/icons/home/nav_home.svg',
      width: 16,
      height: 18,
    ),
    _NavigationItem(
      label: 'Courses',
      asset: 'assets/icons/home/nav_courses.svg',
      width: 22,
      height: 18,
    ),
    _NavigationItem(
      label: 'Shop',
      asset: 'assets/icons/home/nav_shop.svg',
      width: 19.677,
      height: 21.516,
    ),
    _NavigationItem(
      label: 'Profile',
      asset: 'assets/icons/home/nav_profile.svg',
      width: 16,
      height: 16,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return MediaQuery.withNoTextScaling(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final mobileWidth = constraints.maxWidth <= 480
              ? constraints.maxWidth
              : 390.0;
          final scale = mobileWidth / 390;
          return Container(
            height: 80 * scale + bottomInset,
            padding: EdgeInsets.only(
              left: 20 * scale,
              right: 20 * scale,
              top: 2 * scale,
              bottom: bottomInset,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFBF9F1),
              border: Border(
                top: BorderSide(
                  color: const Color(0xFFDAC2B1),
                  width: 2 * scale,
                ),
              ),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(12 * scale),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF877365).withValues(alpha: 0.1),
                  offset: Offset(0, -4 * scale),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Row(
              children: List.generate(_items.length, (index) {
                final item = _items[index];
                final selected = index == selectedIndex;
                return Expanded(
                  child: Center(
                    child: Semantics(
                      button: true,
                      selected: selected,
                      label: item.label,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(999 * scale),
                        onTap: () => onSelected(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 120),
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                (selected && item.label.length <= 5 ? 24 : 14) *
                                scale,
                            vertical: 8 * scale,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0xFFFF9F43)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(999 * scale),
                            boxShadow: selected
                                ? [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF6D3A00,
                                      ).withValues(alpha: 0.5),
                                      offset: Offset(0, 3 * scale),
                                      blurRadius: 0,
                                    ),
                                  ]
                                : null,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                item.asset,
                                width: item.width * scale,
                                height: item.height * scale,
                                colorFilter: ColorFilter.mode(
                                  selected
                                      ? const Color(0xFF6D3A00)
                                      : const Color(0xFF544437),
                                  BlendMode.srcIn,
                                ),
                              ),
                              SizedBox(height: 4 * scale),
                              Text(
                                item.label,
                                maxLines: 1,
                                softWrap: false,
                                style: TextStyle(
                                  fontFamily: 'BeVietnamPro',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10 * scale,
                                  height: 1.5,
                                  color: selected
                                      ? const Color(0xFF6D3A00)
                                      : const Color(0xFF544437),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        },
      ),
    );
  }
}

class _NavigationItem {
  const _NavigationItem({
    required this.label,
    required this.asset,
    required this.width,
    required this.height,
  });

  final String label;
  final String asset;
  final double width;
  final double height;
}
