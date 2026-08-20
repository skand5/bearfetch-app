import 'package:flutter/material.dart';

class ProfilePlaceholderScreen extends StatelessWidget {
  const ProfilePlaceholderScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(
    body: SafeArea(child: Center(child: Text('Profile foundation ready'))),
  );
}
