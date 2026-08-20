import 'package:flutter/material.dart';

class HomePlaceholderScreen extends StatelessWidget {
  const HomePlaceholderScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(
    body: SafeArea(child: Center(child: Text('Home foundation ready'))),
  );
}
