import 'package:flutter/material.dart';

class ShopPlaceholderScreen extends StatelessWidget {
  const ShopPlaceholderScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(
    body: SafeArea(child: Center(child: Text('Shop foundation ready'))),
  );
}
