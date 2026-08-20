import 'package:flutter/material.dart';

class ActivityPlaceholderScreen extends StatelessWidget {
  const ActivityPlaceholderScreen({super.key, required this.activityId});
  final String activityId;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(child: Center(child: Text('Activity: $activityId'))),
  );
}
