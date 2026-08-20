import 'package:flutter/material.dart';

class CoursesPlaceholderScreen extends StatelessWidget {
  const CoursesPlaceholderScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(
    body: SafeArea(child: Center(child: Text('Courses foundation ready'))),
  );
}
