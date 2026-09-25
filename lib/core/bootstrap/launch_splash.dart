import 'dart:async';

import 'package:flutter/material.dart';

/// Keeps the supplied launch artwork visible while Flutter hands off from the
/// platform splash to the routed application.
class LaunchSplash extends StatefulWidget {
  const LaunchSplash({super.key, required this.child});

  final Widget child;

  @override
  State<LaunchSplash> createState() => _LaunchSplashState();
}

class _LaunchSplashState extends State<LaunchSplash> {
  static const _minimumDisplayTime = Duration(milliseconds: 1600);
  Timer? _timer;
  var _isReady = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _timer = Timer(_minimumDisplayTime, () {
        if (mounted) setState(() => _isReady = true);
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isReady) return widget.child;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFF102B60),
        body: SizedBox.expand(
          child: Image.asset(
            'assets/illustrations/bearfetch_splash.png',
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
          ),
        ),
      ),
    );
  }
}
