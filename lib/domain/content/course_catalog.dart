import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ActivityKind { lesson, select, multiSelect, sequence }

class ActivityDefinition {
  const ActivityDefinition({
    required this.id,
    required this.unit,
    required this.step,
    required this.sequence,
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.kind,
    required this.options,
    required this.correct,
    required this.correctSequence,
    required this.rewardId,
    this.nextId,
  });

  final String id;
  final int unit;
  final int step;
  final int sequence;
  final String badge;
  final String title;
  final String subtitle;
  final String body;
  final ActivityKind kind;
  final List<String> options;
  final Set<int> correct;
  final List<int> correctSequence;
  final String rewardId;
  final String? nextId;

  factory ActivityDefinition.fromJson(Map<String, Object?> json) {
    final kindName = json['kind'] as String?;
    final kind = ActivityKind.values.where((value) => value.name == kindName);
    if (kind.length != 1) {
      throw const FormatException('Activity kind is invalid.');
    }
    return ActivityDefinition(
      id: _requiredString(json, 'id'),
      unit: _requiredInt(json, 'unit'),
      step: _requiredInt(json, 'displayStep'),
      sequence: _requiredInt(json, 'sequence'),
      badge: _requiredString(json, 'badge'),
      title: _requiredString(json, 'title'),
      subtitle: _requiredString(json, 'subtitle'),
      body: _requiredString(json, 'body'),
      kind: kind.single,
      options: List<String>.unmodifiable(
        (json['options'] as List<Object?>? ?? const []).cast<String>(),
      ),
      correct: Set<int>.unmodifiable(
        (json['correct'] as List<Object?>? ?? const []).cast<int>(),
      ),
      correctSequence: List<int>.unmodifiable(
        (json['correctSequence'] as List<Object?>? ?? const []).cast<int>(),
      ),
      rewardId: _requiredString(json, 'rewardId'),
      nextId: json['nextActivityId'] as String?,
    );
  }
}

class CourseCatalog {
  CourseCatalog._({
    required this.courseId,
    required this.version,
    required this.totalDisplaySteps,
    required this.completionRewardId,
    required List<ActivityDefinition> activities,
  }) : activities = List.unmodifiable(activities),
       byId = Map.unmodifiable({for (final item in activities) item.id: item}) {
    _validate();
  }

  final String courseId;
  final int version;
  final int totalDisplaySteps;
  final String completionRewardId;
  final List<ActivityDefinition> activities;
  final Map<String, ActivityDefinition> byId;

  ActivityDefinition get firstActivity => activities.first;

  factory CourseCatalog.fromJsonString(String source) {
    final json = jsonDecode(source);
    if (json is! Map<String, Object?>) {
      throw const FormatException('Course manifest root must be an object.');
    }
    final rawActivities = json['activities'];
    if (rawActivities is! List<Object?>) {
      throw const FormatException('Course manifest activities are missing.');
    }
    final activities =
        rawActivities
            .map(
              (value) => ActivityDefinition.fromJson(
                (value as Map<Object?, Object?>).cast<String, Object?>(),
              ),
            )
            .toList()
          ..sort((left, right) => left.sequence.compareTo(right.sequence));
    return CourseCatalog._(
      courseId: _requiredString(json, 'courseId'),
      version: _requiredInt(json, 'version'),
      totalDisplaySteps: _requiredInt(json, 'totalDisplaySteps'),
      completionRewardId: _requiredString(json, 'completionRewardId'),
      activities: activities,
    );
  }

  static Future<CourseCatalog> loadFromAssets() async =>
      CourseCatalog.fromJsonString(
        await rootBundle.loadString('assets/content/course_manifest.json'),
      );

  ActivityDefinition activity(String id) {
    final result = byId[id];
    if (result == null) throw StateError('Unknown activity ID: $id');
    return result;
  }

  ActivityDefinition nextIncomplete(Set<String> completedIds) =>
      activities.firstWhere(
        (activity) => !completedIds.contains(activity.id),
        orElse: () => activities.last,
      );

  void _validate() {
    if (activities.isEmpty) {
      throw const FormatException('Course manifest has no activities.');
    }
    if (totalDisplaySteps != 36) {
      throw const FormatException('Course must contain 36 display steps.');
    }
    if (byId.length != activities.length) {
      throw const FormatException('Activity IDs must be unique.');
    }
    final rewardIds = activities.map((item) => item.rewardId).toSet();
    if (rewardIds.length != activities.length) {
      throw const FormatException('Activity reward IDs must be unique.');
    }
    for (var index = 0; index < activities.length; index++) {
      final activity = activities[index];
      if (activity.sequence != index + 1) {
        throw const FormatException('Activity sequence must be contiguous.');
      }
      if (activity.step < 1 || activity.step > totalDisplaySteps) {
        throw FormatException('${activity.id} display step is out of bounds.');
      }
      final expectedNext = index == activities.length - 1
          ? null
          : activities[index + 1].id;
      if (activity.nextId != expectedNext) {
        throw FormatException('${activity.id} next activity is invalid.');
      }
      if (activity.correct.any(
        (answer) => answer < 0 || answer >= activity.options.length,
      )) {
        throw FormatException('${activity.id} correct answer is invalid.');
      }
      if (activity.kind == ActivityKind.sequence &&
          (activity.correctSequence.length != activity.correct.length ||
              activity.correctSequence.toSet().length !=
                  activity.correctSequence.length ||
              !activity.correct.containsAll(activity.correctSequence))) {
        throw FormatException('${activity.id} correct sequence is invalid.');
      }
    }
  }
}

final courseCatalogProvider = Provider<CourseCatalog>(
  (ref) => throw StateError('Course catalog has not been bootstrapped.'),
);

String _requiredString(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is! String || value.isEmpty) {
    throw FormatException('$key must be a non-empty string.');
  }
  return value;
}

int _requiredInt(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is! int) throw FormatException('$key must be an integer.');
  return value;
}
