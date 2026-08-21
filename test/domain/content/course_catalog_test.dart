import 'dart:io';

import 'package:bearfetch_app/domain/content/course_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CourseCatalog catalog;

  setUpAll(() async {
    catalog = CourseCatalog.fromJsonString(
      await File('assets/content/course_manifest.json').readAsString(),
    );
  });

  test('manifest has stable ordered activity and reward identifiers', () {
    expect(catalog.courseId, 'ai-course-01');
    expect(catalog.totalDisplaySteps, 36);
    expect(catalog.activities, hasLength(17));
    expect(catalog.activities.first.id, 'unit-01-01');
    expect(catalog.activities.last.id, 'unit-04-07');
    expect(
      catalog.activities.map((activity) => activity.sequence),
      orderedEquals(List.generate(17, (index) => index + 1)),
    );
    expect(
      catalog.activities.map((activity) => activity.rewardId).toSet(),
      hasLength(17),
    );
  });

  test(
    'manifest next links follow sequence despite duplicate display steps',
    () {
      expect(catalog.activity('unit-04-02').step, 24);
      expect(catalog.activity('unit-04-03').step, 24);
      expect(catalog.activity('unit-04-02').nextId, 'unit-04-03');
      expect(catalog.nextIncomplete({'unit-04-02'}).id, 'unit-01-01');
      expect(
        catalog
            .nextIncomplete(
              catalog.activities
                  .take(12)
                  .map((activity) => activity.id)
                  .toSet(),
            )
            .id,
        'unit-04-03',
      );
    },
  );

  test('manifest validation rejects duplicate activity identifiers', () {
    final source = File(
      'assets/content/course_manifest.json',
    ).readAsStringSync();
    final invalid = source.replaceFirst('"unit-01-02"', '"unit-01-01"');
    expect(
      () => CourseCatalog.fromJsonString(invalid),
      throwsA(isA<FormatException>()),
    );
  });
}
