import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:bearfetch_app/features/course/presentation/course_activity_screen.dart';
import 'package:bearfetch_app/features/course/presentation/activity_result_screen.dart';
import 'package:bearfetch_app/features/course/presentation/course_completion_screen.dart';
import 'package:bearfetch_app/main.dart';
import 'support/test_harness.dart';

void main() {
  late TestHarness harness;

  setUp(() async {
    harness = await TestHarness.create();
  });

  tearDown(() => harness.dispose());

  testWidgets('parent-first onboarding is the app entry point', (tester) async {
    await tester.pumpWidget(harness.wrap(const BearfetchApp()));
    expect(find.bySemanticsLabel("I'm a Parent"), findsOneWidget);
    expect(find.bySemanticsLabel('Sign in'), findsOneWidget);
    expect(find.text('AI Adventures for\nyoung learners'), findsOneWidget);
    expect(
      find.text(
        "Create a family account, add your\nchild's learner profile, and start\nthe first AI-mission.",
      ),
      findsOneWidget,
    );
  });

  testWidgets('parent signup validates details then opens learner profile', (
    tester,
  ) async {
    await tester.pumpWidget(harness.wrap(const BearfetchApp()));

    final parentButton = find.bySemanticsLabel("I'm a Parent");
    await tester.ensureVisible(parentButton);
    await tester.tap(parentButton);
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('Parent name'), findsOneWidget);
    expect(find.bySemanticsLabel('Email address'), findsOneWidget);

    final sendOtp = find.bySemanticsLabel('Send OTP');
    await tester.ensureVisible(sendOtp);
    await tester.tap(sendOtp);
    await tester.pump();
    expect(find.text('Enter your name.'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(0), 'Priya Kumar');
    await tester.enterText(find.byType(TextField).at(1), 'priya@example.com');
    await tester.ensureVisible(sendOtp);
    await tester.tap(sendOtp);
    await tester.pumpAndSettle();

    expect(find.text('Verify your contact'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField), '123456');
    await tester.tap(find.text('Verify and continue'));
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel("Child's nickname"), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Max');
    final ageRange = find.bySemanticsLabel('Age range 6–11 yr');
    await tester.ensureVisible(ageRange);
    await tester.tap(ageRange);
    await tester.pump();

    final continueButton = find.bySemanticsLabel('Continue').last;
    await tester.ensureVisible(continueButton);
    await tester.tap(continueButton);
    await tester.pumpAndSettle();
    expect(
      find.bySemanticsLabel('I am the parent or guardian'),
      findsOneWidget,
    );

    for (final label in const [
      'I am the parent or guardian',
      'I approve creating a learner profile',
      'I can manage this later',
    ]) {
      final confirmation = find.bySemanticsLabel(label);
      await tester.ensureVisible(confirmation);
      await tester.tap(confirmation);
      await tester.pump();
    }

    final approveButton = find.bySemanticsLabel('Approve and Continue');
    await tester.ensureVisible(approveButton);
    await tester.tap(approveButton);
    await tester.pumpAndSettle();
    expect(find.text('Meet AI Chatbots'), findsWidgets);
  });

  testWidgets('returning parent sign-in requests only an email code', (
    tester,
  ) async {
    await tester.pumpWidget(harness.wrap(const BearfetchApp()));

    final signIn = find.bySemanticsLabel('Sign in');
    await tester.ensureVisible(signIn);
    await tester.tap(signIn);
    await tester.pumpAndSettle();
    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.bySemanticsLabel('Parent name'), findsNothing);
    expect(find.bySemanticsLabel('Email address'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'parent@example.com');
    await tester.tap(find.bySemanticsLabel('Send sign-in code'));
    await tester.pumpAndSettle();
    expect(find.text('Verify your contact'), findsOneWidget);
  });

  testWidgets('native shell tabs and first activity route work', (
    tester,
  ) async {
    await tester.pumpWidget(harness.wrap(const BearfetchApp()));

    GoRouter.of(tester.element(find.byType(Scaffold).first)).go('/home');
    await tester.pumpAndSettle();
    expect(find.text('Meet AI Chatbots'), findsWidgets);
    expect(find.text('DAILY QUEST'), findsNothing);
    expect(find.text('Hello Guest 👋'), findsOneWidget);
    expect(find.text('Get ready to learn AI!'), findsOneWidget);

    await tester.tap(find.text('Courses'));
    await tester.pumpAndSettle();
    expect(find.text('K-12 Friendly'), findsOneWidget);
    expect(find.bySemanticsLabel('Continue Course'), findsOneWidget);
    expect(find.bySemanticsLabel('View Course Path'), findsNothing);

    await tester.tap(find.text('Shop'));
    await tester.pumpAndSettle();
    final buyStarCap = find.bySemanticsLabel('Buy Star Cap');
    expect(buyStarCap, findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('Continue Learning'), findsOneWidget);
    expect(find.bySemanticsLabel('Change Avatar'), findsOneWidget);
    expect(find.bySemanticsLabel('Logout'), findsOneWidget);

    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    final mission = find.text('Start First Mission');
    await tester.ensureVisible(mission);
    await tester.tap(mission);
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('Meet AI Chatbots'), findsOneWidget);

    final start = find.bySemanticsLabel('Start');
    await tester.ensureVisible(start);
    await tester.tap(start);
    await tester.pumpAndSettle();
    expect(find.text('What you learnt:'), findsOneWidget);
  });

  testWidgets('all course activity definitions render natively', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    for (final entry in harness.catalog.byId.entries) {
      await tester.pumpWidget(
        harness.wrap(
          MaterialApp(home: CourseActivityScreen(activityId: entry.key)),
        ),
      );
      await tester.pump();
      if (entry.key == 'unit-01-01' ||
          entry.key == 'unit-01-02' ||
          entry.key == 'unit-01-03' ||
          entry.key == 'unit-01-04' ||
          entry.key == 'unit-02-01' ||
          entry.key == 'unit-02-02' ||
          entry.key == 'unit-02-03' ||
          entry.key == 'unit-03-01' ||
          entry.key == 'unit-03-02' ||
          entry.key == 'unit-03-03' ||
          entry.key == 'unit-04-01' ||
          entry.key == 'unit-04-02' ||
          entry.key == 'unit-04-03' ||
          entry.key == 'unit-04-04' ||
          entry.key == 'unit-04-05' ||
          entry.key == 'unit-04-06' ||
          entry.key == 'unit-04-07') {
        expect(
          find.bySemanticsLabel(entry.value.title),
          findsOneWidget,
          reason: entry.key,
        );
      } else {
        expect(find.text(entry.value.title), findsOneWidget, reason: entry.key);
      }
      expect(tester.takeException(), isNull, reason: entry.key);
    }
  });

  testWidgets('all activities start with no selected response', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    for (final activityId in harness.catalog.byId.keys) {
      await tester.pumpWidget(
        harness.wrap(
          MaterialApp(home: CourseActivityScreen(activityId: activityId)),
        ),
      );
      await tester.pump();

      expect(
        find.byWidgetPredicate(
          (widget) => widget is Semantics && widget.properties.selected == true,
        ),
        findsNothing,
        reason: '$activityId must start with no selected response.',
      );
    }
  });

  testWidgets('chatbot exploration requires trying each question', (
    tester,
  ) async {
    await tester.pumpWidget(
      harness.wrap(
        const MaterialApp(home: CourseActivityScreen(activityId: 'unit-01-04')),
      ),
    );
    await tester.pump();

    expect(
      find.text(
        'An AI chatbot is a smart helper that can reply to your questions using words.',
      ),
      findsNothing,
    );

    final questions = const [
      'What is an AI chatbot?',
      'Where do chatbots appear?',
      'What can a chatbot do?',
    ];
    final replies = const [
      'An AI chatbot is a smart helper that can reply to your questions using words.',
      'Chatbots can appear in apps, websites, games, search, shopping, and support.',
      'A chatbot can answer questions, explain ideas, and help people complete tasks.',
    ];

    for (final questionLabel in questions) {
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == questionLabel &&
              widget.properties.selected == false,
        ),
        findsOneWidget,
        reason: 'A fresh chatbot exploration must not preselect a question.',
      );
    }

    for (var index = 0; index < questions.length; index++) {
      final question = find.byWidgetPredicate(
        (widget) =>
            widget is Semantics && widget.properties.label == questions[index],
      );
      await tester.ensureVisible(question);
      await tester.tap(question);
      await tester.pump();
      expect(find.text(replies[index]), findsOneWidget);
    }
  });

  testWidgets('tone exploration requires trying all three styles', (
    tester,
  ) async {
    await tester.pumpWidget(
      harness.wrap(
        const MaterialApp(home: CourseActivityScreen(activityId: 'unit-03-02')),
      ),
    );
    await tester.pump();

    for (final label in const ['Funny style', 'Serious style']) {
      final option = find.bySemanticsLabel(label);
      await tester.ensureVisible(option);
      await tester.tap(option);
      await tester.pump();
    }

    final check = find.bySemanticsLabel('Check');
    await tester.ensureVisible(check);
    await tester.tap(check);
    await tester.pump();
    expect(
      find.text('Try Funny, Serious, and Friendly before continuing.'),
      findsOneWidget,
    );

    final friendly = find.bySemanticsLabel('Friendly style');
    await tester.ensureVisible(friendly);
    await tester.tap(friendly);
    await tester.pump();
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.label == 'Friendly style' &&
            widget.properties.selected == true,
      ),
      findsOneWidget,
    );
  });

  testWidgets('chatbot system parts fill slots after the fixed chat screen', (
    tester,
  ) async {
    await tester.pumpWidget(
      harness.wrap(
        const MaterialApp(home: CourseActivityScreen(activityId: 'unit-04-01')),
      ),
    );
    await tester.pump();

    final aiBrain = find.bySemanticsLabel('AI Brain');
    await tester.ensureVisible(aiBrain);
    await tester.tap(aiBrain);
    await tester.pump();

    expect(
      find.bySemanticsLabel('Remove AI Brain from slot 2'),
      findsOneWidget,
    );
  });

  testWidgets('prediction activity accepts all three natural next words', (
    tester,
  ) async {
    await tester.pumpWidget(
      harness.wrap(
        const MaterialApp(home: CourseActivityScreen(activityId: 'unit-02-02')),
      ),
    );
    await tester.pump();

    for (final label in const ['honey', 'answer', 'sky']) {
      final option = find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.label == label &&
            widget.properties.selected == false,
      );
      expect(option, findsOneWidget);
      await tester.tap(option);
      await tester.pump();
    }

    for (final label in const ['honey', 'answer', 'sky']) {
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == label &&
              widget.properties.selected == true,
        ),
        findsOneWidget,
      );
    }
  });

  testWidgets('memory reply activity starts without a selected reply', (
    tester,
  ) async {
    await tester.pumpWidget(
      harness.wrap(
        const MaterialApp(home: CourseActivityScreen(activityId: 'unit-02-03')),
      ),
    );
    await tester.pump();

    for (final label in const [
      'Reply A uses memory',
      'Reply B has no memory',
    ]) {
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == label &&
              widget.properties.selected == false,
        ),
        findsOneWidget,
      );
    }
  });

  testWidgets('training examples react to the selected chatbot type', (
    tester,
  ) async {
    await tester.pumpWidget(
      harness.wrap(
        const MaterialApp(
          home: CourseActivityScreen(
            activityId: 'unit-04-06',
            chatbotTypeIndex: 0,
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Your chatbot: Math Bot'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) => widget is Semantics && widget.properties.selected == true,
      ),
      findsNothing,
    );
  });

  testWidgets('bot test reveals its response before enabling Yes or No', (
    tester,
  ) async {
    await tester.pumpWidget(
      harness.wrap(
        const MaterialApp(home: CourseActivityScreen(activityId: 'unit-04-07')),
      ),
    );
    await tester.pump();

    expect(find.bySemanticsLabel('Yes, it helped'), findsNothing);
    expect(find.bySemanticsLabel('Not yet'), findsNothing);

    await tester.tap(find.bySemanticsLabel('Try Example Prompt').last);
    await tester.pump();

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Semantics && widget.properties.label == 'Yes, it helped',
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (widget) => widget is Semantics && widget.properties.label == 'Not yet',
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (widget) => widget is Semantics && widget.properties.selected == true,
      ),
      findsNothing,
    );
  });

  testWidgets('activity result copy changes with the completed activity', (
    tester,
  ) async {
    await tester.pumpWidget(
      harness.wrap(
        const MaterialApp(
          home: ActivityResultScreen(activityId: 'unit-04-07', correct: true),
        ),
      ),
    );
    await tester.pump();
    expect(find.textContaining('fixed Study Coach example'), findsOneWidget);
    expect(find.textContaining('journey is complete'), findsOneWidget);
    expect(find.bySemanticsLabel('Continue'), findsOneWidget);
  });

  testWidgets('incorrect activity result keeps native retry controls', (
    tester,
  ) async {
    await tester.pumpWidget(
      harness.wrap(
        const MaterialApp(
          home: ActivityResultScreen(activityId: 'unit-04-07', correct: false),
        ),
      ),
    );
    await tester.pump();

    expect(find.bySemanticsLabel('Almost there'), findsOneWidget);
    expect(find.bySemanticsLabel('Notifications'), findsOneWidget);
    expect(find.bySemanticsLabel('Try Again'), findsOneWidget);
  });

  testWidgets('course completion keeps native completion controls', (
    tester,
  ) async {
    await tester.pumpWidget(
      harness.wrap(const MaterialApp(home: CourseCompletionScreen())),
    );
    await tester.pump();

    expect(find.bySemanticsLabel('Course Complete!'), findsOneWidget);
    expect(find.bySemanticsLabel('Close'), findsOneWidget);
    expect(find.bySemanticsLabel('Share course completion'), findsOneWidget);
    expect(find.bySemanticsLabel('Finish Course'), findsOneWidget);
  });
}
