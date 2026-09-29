import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/state/app_state.dart';
import '../../../core/widgets/equipped_bear_avatar.dart';
import '../../../domain/content/course_catalog.dart';

class ActivityResultScreen extends ConsumerWidget {
  const ActivityResultScreen({
    super.key,
    required this.activityId,
    required this.correct,
    this.chatbotTypeIndex,
  });

  final String activityId;
  final bool correct;
  final int? chatbotTypeIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activity = ref.watch(courseCatalogProvider).activity(activityId);
    if (!correct) return _RetryResult(activity: activity);

    final copy = _resultCopyFor(activityId, chatbotTypeIndex);
    return _CorrectResult(
      activity: activity,
      copy: copy,
      learnerName: ref.watch(appViewStateProvider).learnerName,
      onContinue: () async {
        await ref
            .read(appStateControllerProvider.notifier)
            .completeActivity(activity);
        final next = activity.nextId;
        if (context.mounted) {
          final chatbotTypeQuery =
              (activityId == 'unit-04-05' || activityId == 'unit-04-06') &&
                  chatbotTypeIndex != null
              ? '?chatbotType=$chatbotTypeIndex'
              : '';
          context.go(
            next == null
                ? '/course-completion'
                : '/activity/$next$chatbotTypeQuery',
          );
        }
      },
    );
  }
}

class _CorrectResult extends StatelessWidget {
  const _CorrectResult({
    required this.activity,
    required this.copy,
    required this.learnerName,
    required this.onContinue,
  });

  final ActivityDefinition activity;
  final _ResultCopy copy;
  final String learnerName;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) => MediaQuery.withNoTextScaling(
    child: Scaffold(
      backgroundColor: const Color(0xFFFDF8EF),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final designWidth = constraints.maxWidth <= 480
                ? constraints.maxWidth
                : 390.0;
            final scale = designWidth / 390;
            return Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: designWidth,
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        20 * scale,
                        14 * scale,
                        20 * scale,
                        10 * scale,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _ResultHeader(scale: scale),
                            SizedBox(height: 6 * scale),
                            Semantics(
                              label: 'Success animation for ${activity.title}',
                              image: true,
                              child: SizedBox(
                                height: 308 * scale,
                                child: Image.asset(
                                  'assets/illustrations/activity_success_great_work.png',
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.high,
                                  excludeFromSemantics: true,
                                ),
                              ),
                            ),
                            SizedBox(height: 20 * scale),
                            _ResultSection(
                              heading: 'What you learnt:',
                              body: copy.learnt,
                              scale: scale,
                            ),
                            SizedBox(height: 20 * scale),
                            _ResultSection(
                              heading: 'Whats next?',
                              body: copy.next,
                              scale: scale,
                            ),
                            const Spacer(),
                            _ResultRewards(scale: scale),
                            SizedBox(height: 10 * scale),
                            TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.94, end: 1),
                              duration: const Duration(milliseconds: 650),
                              curve: Curves.elasticOut,
                              builder: (context, pulse, child) =>
                                  Transform.scale(
                                    scale: pulse,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          24 * scale,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFFFF9F43)
                                                .withValues(
                                                  alpha:
                                                      (1 - pulse) * 0.8 + 0.18,
                                                ),
                                            blurRadius: 16 * (1 - pulse) + 5,
                                            spreadRadius: 2 * (1 - pulse),
                                          ),
                                        ],
                                      ),
                                      child: child,
                                    ),
                                  ),
                              child: SizedBox(
                                height: 46 * scale,
                                child: ElevatedButton(
                                  onPressed: onContinue,
                                  style: ElevatedButton.styleFrom(
                                    elevation: 5 * scale,
                                    shadowColor: const Color(0xFF293033),
                                    backgroundColor: const Color(0xFFFF9F43),
                                    foregroundColor: const Color(0xFF6D3A00),
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        24 * scale,
                                      ),
                                      side: BorderSide(
                                        color: const Color(0xFF293033),
                                        width: 2.5 * scale,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Continue',
                                        style: TextStyle(
                                          fontFamily: 'Nunito',
                                          fontSize: 16 * scale,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      SizedBox(width: 8 * scale),
                                      Icon(
                                        Icons.arrow_forward_rounded,
                                        size: 24 * scale,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}

class _ResultHeader extends StatelessWidget {
  const _ResultHeader({required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 64 * scale,
    child: Row(
      children: [
        EquippedBearAvatar(size: 48 * scale),
        SizedBox(width: 12 * scale),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  'Hello Guest 👋',
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: 'BeVietnamPro',
                    fontSize: 14 * scale,
                    height: 1.45,
                    color: const Color(0xFF4B3333),
                  ),
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  'Get ready to learn AI!',
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 22 * scale,
                    height: 1.25,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF4B3333),
                  ),
                ),
              ),
            ],
          ),
        ),
        Semantics(
          button: true,
          label: 'Notifications',
          child: InkWell(
            borderRadius: BorderRadius.circular(12 * scale),
            onTap: () {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Text(
                      'No new notifications in the local prototype.',
                    ),
                  ),
                );
            },
            child: Container(
              width: 40 * scale,
              height: 40 * scale,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFCF6),
                border: Border.all(
                  color: const Color(0xFFE3C9B7),
                  width: 1.2 * scale,
                ),
                borderRadius: BorderRadius.circular(12 * scale),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/home/notification.svg',
                    width: 13.4 * scale,
                    height: 16.7 * scale,
                  ),
                  Positioned(
                    right: 10 * scale,
                    top: 9 * scale,
                    child: Container(
                      width: 7 * scale,
                      height: 7 * scale,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE6493F),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class _ResultSection extends StatelessWidget {
  const _ResultSection({
    required this.heading,
    required this.body,
    required this.scale,
  });

  final String heading;
  final String body;
  final double scale;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        heading,
        style: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 15 * scale,
          height: 1.2,
          fontWeight: FontWeight.w900,
          color: const Color(0xFF4B3333),
        ),
      ),
      SizedBox(height: 6 * scale),
      Text(
        body,
        style: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 13.5 * scale,
          height: 1.42,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.7 * scale,
          color: const Color(0xFF171914),
        ),
      ),
    ],
  );
}

class _ResultRewards extends StatelessWidget {
  const _ResultRewards({required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Text(
        'Rewards Earned:',
        style: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 14 * scale,
          fontWeight: FontWeight.w900,
          color: const Color(0xFF4B3333),
        ),
      ),
      SizedBox(width: 8 * scale),
      Expanded(
        child: Row(
          children: [
            Expanded(
              child: _ResultRewardPill(
                icon: Icons.star_rounded,
                color: const Color(0xFF22B26B),
                label: '+10 XP',
                scale: scale,
              ),
            ),
            SizedBox(width: 4 * scale),
            Expanded(
              flex: 2,
              child: _ResultRewardPill(
                icon: Icons.hive_rounded,
                color: const Color(0xFFFF9F43),
                label: '+5 Honey Jars',
                scale: scale,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _ResultRewardPill extends StatelessWidget {
  const _ResultRewardPill({
    required this.icon,
    required this.color,
    required this.label,
    required this.scale,
  });

  final IconData icon;
  final Color color;
  final String label;
  final double scale;

  @override
  Widget build(BuildContext context) => Container(
    height: 27 * scale,
    padding: EdgeInsets.symmetric(horizontal: 7 * scale),
    decoration: BoxDecoration(
      color: const Color(0xFFFFFDF8),
      border: Border.all(color: const Color(0xFF293033), width: 2 * scale),
      borderRadius: BorderRadius.circular(15 * scale),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 16 * scale, color: color),
        SizedBox(width: 3 * scale),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 12.5 * scale,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF293033),
            ),
          ),
        ),
      ],
    ),
  );
}

class _RetryResult extends ConsumerWidget {
  const _RetryResult({required this.activity});

  final ActivityDefinition activity;

  static const _designWidth = 391.0;
  static const _designHeight = 805.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF2),
      body: SafeArea(
        bottom: false,
        child: MediaQuery.withNoTextScaling(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final scale = constraints.maxWidth / _designWidth;
              return Semantics(
                label: 'Almost there',
                container: true,
                explicitChildNodes: true,
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: constraints.maxWidth,
                    height: _designHeight * scale,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        width: _designWidth,
                        height: _designHeight,
                        child: Stack(
                          children: [
                            const Positioned.fill(
                              child: Image(
                                image: AssetImage(
                                  'assets/illustrations/activity_wrong.png',
                                ),
                                fit: BoxFit.fill,
                                filterQuality: FilterQuality.high,
                              ),
                            ),
                            const Positioned(
                              left: 0,
                              top: 0,
                              width: 391,
                              height: 70,
                              child: ColoredBox(color: Color(0xFFFFFBF2)),
                            ),
                            _RetryHitTarget(
                              label: 'Try Again',
                              left: 18,
                              top: 732,
                              width: 355,
                              height: 62,
                              onTap: () async {
                                await ref
                                    .read(appStateControllerProvider.notifier)
                                    .recordRetry(activity.id);
                                if (context.mounted) {
                                  context.go('/activity/${activity.id}');
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _RetryHitTarget extends StatelessWidget {
  const _RetryHitTarget({
    required this.label,
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.onTap,
  });

  final String label;
  final double left;
  final double top;
  final double width;
  final double height;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Positioned(
    left: left,
    top: top,
    width: width,
    height: height,
    child: Semantics(
      button: true,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
      ),
    ),
  );
}

class _ResultCopy {
  const _ResultCopy({required this.learnt, required this.next});

  final String learnt;
  final String next;
}

_ResultCopy _resultCopyFor(String activityId, int? chatbotTypeIndex) {
  const botNames = ['Math Bot', 'Fun Bot', 'Study Coach', 'Helper Bot'];
  const exampleNames = [
    'Math Practice Examples',
    'Fun Facts Examples',
    'Study Coach Examples',
    'General Helper Examples',
  ];
  final index =
      chatbotTypeIndex != null &&
          chatbotTypeIndex >= 0 &&
          chatbotTypeIndex < botNames.length
      ? chatbotTypeIndex
      : 2;
  if (activityId == 'unit-04-05') {
    return _ResultCopy(
      learnt:
          'The scripted example gave your chatbot concept a clear purpose: ${botNames[index]}.',
      next:
          'Next, you’ll review fixed ${exampleNames[index]} that match the ${botNames[index]} concept.',
    );
  }
  if (activityId == 'unit-04-06') {
    return _ResultCopy(
      learnt:
          'The scripted ${exampleNames[index]} showed how relevant examples can match a chatbot’s intended purpose.',
      next:
          'Next, you’ll review a scripted ${botNames[index]} prompt and its predefined response.',
    );
  }
  return _activityResultCopy[activityId]!;
}

const _activityResultCopy = <String, _ResultCopy>{
  'unit-01-01': _ResultCopy(
    learnt:
        'AI chatbots are helpers that talk with people using words. They can answer questions, suggest ideas, and support people inside apps and websites.',
    next:
        'Next, you’ll identify familiar companies and apps that use modern AI.',
  ),
  'unit-01-02': _ResultCopy(
    learnt:
        'You identified AI companies and AI-powered apps, and separated them from products that do not primarily use conversational AI.',
    next:
        'Next, you’ll learn how language models understand and generate human language.',
  ),
  'unit-01-03': _ResultCopy(
    learnt:
        'Large language models learn patterns from large amounts of text. They use those patterns to understand language and answer questions.',
    next:
        'Next, you’ll send a question to BearFetch Bot and observe its reply.',
  ),
  'unit-01-04': _ResultCopy(
    learnt:
        'A chatbot receives a user’s words as input, processes the request, and returns a useful answer as output.',
    next:
        'Next, you’ll build a sentence from tokens—the smaller pieces used to process language.',
  ),
  'unit-02-01': _ResultCopy(
    learnt:
        'Words can be split into smaller parts called tokens. AI systems process these pieces to understand and generate sentences.',
    next:
        'Next, you’ll see how a language model predicts the most likely word in a sentence.',
  ),
  'unit-02-02': _ResultCopy(
    learnt:
        'Language models predict likely next words by using patterns and context from the words that came before.',
    next:
        'Next, you’ll explore how chatbot memory helps a reply use earlier messages.',
  ),
  'unit-02-03': _ResultCopy(
    learnt:
        'Memory lets a chatbot connect a new question with useful details from earlier in the conversation.',
    next:
        'Next, you’ll improve prompts by adding a clear topic, audience, and response format.',
  ),
  'unit-03-01': _ResultCopy(
    learnt:
        'Specific prompts produce more useful answers. A clear topic and requested format guide the AI toward the result you need.',
    next:
        'Next, you’ll change a chatbot’s tone to make the same answer funny, serious, or friendly.',
  ),
  'unit-03-02': _ResultCopy(
    learnt:
        'The same question can produce different answers when you change the requested style, tone, or behavior.',
    next:
        'Next, you’ll choose the respectful and helpful role a chatbot should follow.',
  ),
  'unit-03-03': _ResultCopy(
    learnt:
        'A good chatbot should be clear, helpful, and respectful while guiding conversations and completing useful tasks.',
    next: 'Next, you’ll assemble the main parts that make a chatbot work.',
  ),
  'unit-04-01': _ResultCopy(
    learnt:
        'A working chatbot combines a chat screen, user question, AI brain, data or knowledge, and a bot reply.',
    next:
        'Next, you’ll choose the interface that best supports a clear chatbot conversation.',
  ),
  'unit-04-02': _ResultCopy(
    learnt:
        'A good chatbot interface makes messages easy to read and gives the user a simple, obvious place to type.',
    next:
        'Next, you’ll trace a message through the interface, AI model, and response stages.',
  ),
  'unit-04-03': _ResultCopy(
    learnt:
        'The interface receives the user’s message, the AI model generates an answer, and the interface displays the response.',
    next:
        'Next, you’ll check whether your first working bot produces a normal, useful output.',
  ),
  'unit-04-04': _ResultCopy(
    learnt:
        'The simulation showed how a chatbot can receive a message and return a clear response that explains what it is and how it can help.',
    next:
        'Next, you’ll simulate choosing a focus area and personality for a chatbot concept.',
  ),
  'unit-04-07': _ResultCopy(
    learnt:
        'You reviewed a fixed Study Coach example and identified why its predefined answer was clear, practical, and useful.',
    next:
        'Your AI chatbot journey is complete. Continue to review your progress, rewards, and completed course.',
  ),
};
