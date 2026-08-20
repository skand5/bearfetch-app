import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/bearfetch_theme.dart';
import '../../../core/widgets/bearfetch_ui.dart';

enum ActivityKind { lesson, select, multiSelect, sequence }

class ActivityDefinition {
  const ActivityDefinition({
    required this.id,
    required this.unit,
    required this.step,
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.kind,
    this.options = const [],
    this.correct = const {},
    this.nextId,
  });
  final String id;
  final int unit;
  final int step;
  final String badge;
  final String title;
  final String subtitle;
  final String body;
  final ActivityKind kind;
  final List<String> options;
  final Set<int> correct;
  final String? nextId;
}

const activityDefinitions = <String, ActivityDefinition>{
  'unit-01-01': ActivityDefinition(
    id: 'unit-01-01',
    unit: 1,
    step: 1,
    badge: 'UNIT 1: WHAT IS AN AI CHATBOT?',
    title: 'Meet AI Chatbots',
    subtitle: 'Today we’ll learn about AI chatbots.',
    body:
        'A chatbot is an AI helper that talks with people using words. Chatbots can answer questions, suggest ideas, and help you inside apps or websites.\n\nYou may have seen chatbots in games, shopping, search, and support.',
    kind: ActivityKind.lesson,
    nextId: 'unit-01-02',
  ),
  'unit-01-02': ActivityDefinition(
    id: 'unit-01-02',
    unit: 1,
    step: 2,
    badge: 'AI APPS',
    title: 'Do you know these AI apps?',
    subtitle: 'Tap the AI companies or AI-powered apps.',
    body: 'Choose every example that uses modern AI.',
    kind: ActivityKind.multiSelect,
    options: [
      'OpenAI',
      'YouTube',
      'Spotify',
      'Xbox',
      'Claude',
      'PlayStation',
      'Starbucks',
      'Domino’s',
      'Gemini',
    ],
    correct: {0, 4, 8},
    nextId: 'unit-01-03',
  ),
  'unit-01-03': ActivityDefinition(
    id: 'unit-01-03',
    unit: 1,
    step: 4,
    badge: 'WORD BANK',
    title: 'Place the right words',
    subtitle: 'Complete the explanation using the word bank.',
    body:
        'An LLM is a type of artificial intelligence designed to understand and generate _____. It reads massive amounts of _____ and can _____.',
    kind: ActivityKind.multiSelect,
    options: [
      'Human language',
      'Text',
      'Answer questions',
      'Numbers only',
      'Pictures only',
    ],
    correct: {0, 1, 2},
    nextId: 'unit-01-04',
  ),
  'unit-01-04': ActivityDefinition(
    id: 'unit-01-04',
    unit: 1,
    step: 6,
    badge: 'INPUT → OUTPUT',
    title: 'Ask the chatbot a question',
    subtitle: 'Choose a question and watch how the bot replies.',
    body:
        'Hi! I’m BearFetch Bot. Ask me a question, and I’ll reply with an answer.',
    kind: ActivityKind.select,
    options: [
      'What is an AI chatbot?',
      'Where do chatbots appear?',
      'What can a chatbot do?',
    ],
    correct: {0},
    nextId: 'unit-02-01',
  ),
  'unit-02-01': ActivityDefinition(
    id: 'unit-02-01',
    unit: 2,
    step: 8,
    badge: 'TOKENS',
    title: 'Word Puzzle Blocks',
    subtitle: 'Put the word pieces in the correct order.',
    body:
        'Words can be split into smaller parts called tokens. Build the sentence below.',
    kind: ActivityKind.sequence,
    options: ['AI chatbots', 'answer', 'questions', 'using', 'words'],
    correct: {0, 1, 2, 3, 4},
    nextId: 'unit-02-02',
  ),
  'unit-02-02': ActivityDefinition(
    id: 'unit-02-02',
    unit: 2,
    step: 10,
    badge: 'PREDICTION',
    title: 'Guess the Next Word',
    subtitle: 'What is the most likely next word?',
    body: 'The bear eats sweet _____.',
    kind: ActivityKind.multiSelect,
    options: [
      'honey',
      'rocket',
      'window',
      'answer',
      'banana',
      'planet',
      'sky',
      'shoe',
      'sandwich',
    ],
    correct: {0, 3, 6},
    nextId: 'unit-02-03',
  ),
  'unit-02-03': ActivityDefinition(
    id: 'unit-02-03',
    unit: 2,
    step: 12,
    badge: 'MEMORY',
    title: 'Which reply remembers?',
    subtitle: 'Memory helps a chatbot use earlier messages.',
    body:
        'User: My favorite planet is Mars.\nBot: Got it. Your favorite planet is Mars.\nUser: Tell me more about my favorite planet.',
    kind: ActivityKind.select,
    options: [
      'Mars is called the Red Planet. It has dusty red soil, tall volcanoes, and two small moons.',
      'Which planet do you mean? Please tell me the planet name first.',
    ],
    correct: {0},
    nextId: 'unit-03-01',
  ),
  'unit-03-01': ActivityDefinition(
    id: 'unit-03-01',
    unit: 3,
    step: 15,
    badge: 'PROMPTING',
    title: 'Talk to AI Properly',
    subtitle: 'See how changing the prompt changes the answer.',
    body:
        'Better prompt: “Tell me 3 fun facts about Mars for kids in short sentences.”\n\nThe answer gives clear, short, kid-friendly facts.',
    kind: ActivityKind.multiSelect,
    options: [
      'It gave a clear topic',
      'It asked for short sentences',
      'It asked for a kid-friendly answer',
    ],
    correct: {0, 1, 2},
    nextId: 'unit-03-02',
  ),
  'unit-03-02': ActivityDefinition(
    id: 'unit-03-02',
    unit: 3,
    step: 17,
    badge: 'BEHAVIOR',
    title: 'Make AI Funny or Serious',
    subtitle: 'Choose a style and see how the answer changes.',
    body:
        'Prompt: “Explain what a black hole is.”\n\nA black hole is like a cosmic vacuum cleaner with a huge appetite. Even light cannot escape its pull.',
    kind: ActivityKind.select,
    options: ['Funny', 'Serious', 'Friendly'],
    correct: {0},
    nextId: 'unit-03-03',
  ),
  'unit-03-03': ActivityDefinition(
    id: 'unit-03-03',
    unit: 3,
    step: 19,
    badge: 'LLM ROLE',
    title: 'Chatbot Roles',
    subtitle: 'How should an LLM respond to a person’s prompt?',
    body:
        'A chatbot should guide conversations, provide useful information, and help people complete tasks.',
    kind: ActivityKind.select,
    options: ['Be Rude', 'Be Complicated', 'Be Respectful'],
    correct: {2},
    nextId: 'unit-04-01',
  ),
  'unit-04-01': ActivityDefinition(
    id: 'unit-04-01',
    unit: 4,
    step: 22,
    badge: 'SYSTEM',
    title: 'What is a Chatbot Made Of?',
    subtitle: 'Place the parts in the correct order.',
    body: 'A chatbot needs a screen, a brain, knowledge, and a reply.',
    kind: ActivityKind.sequence,
    options: [
      'User Question',
      'Chat Screen',
      'AI Brain',
      'Data / Knowledge',
      'Bot Reply',
    ],
    correct: {0, 1, 2, 3, 4},
    nextId: 'unit-04-02',
  ),
  'unit-04-02': ActivityDefinition(
    id: 'unit-04-02',
    unit: 4,
    step: 24,
    badge: 'UI LAYER',
    title: 'Choose the best chatbot UI',
    subtitle:
        'A good chatbot screen shows messages clearly and gives users a simple place to type.',
    body:
        'Compare the two layouts and choose the one designed for conversations.',
    kind: ActivityKind.select,
    options: [
      'Streaming Layout — best for videos',
      'BearFetch Chat — clear messages and a reply field',
    ],
    correct: {1},
    nextId: 'unit-04-03',
  ),
  'unit-04-03': ActivityDefinition(
    id: 'unit-04-03',
    unit: 4,
    step: 24,
    badge: 'CHAT FLOW',
    title: 'Send a Message',
    subtitle: 'Who’s doing what?',
    body:
        'User asks: “What is 5 × 5?”\nThe chatbot is generating…\nThe answer is 25!',
    kind: ActivityKind.select,
    options: [
      'LLM Interface',
      'AI Model',
      'Response',
      'LLM Interface',
      'AI Model',
      'Response',
      'LLM Interface',
      'AI Model',
      'Response',
    ],
    correct: {0, 4, 8},
    nextId: 'unit-04-04',
  ),
  'unit-04-04': ActivityDefinition(
    id: 'unit-04-04',
    unit: 4,
    step: 28,
    badge: 'CHATBOT BUILD',
    title: 'First Working Bot',
    subtitle: 'Does this look like a normal output?',
    body:
        'User: Who are you?\n\nBearFetch Bot: Hi, I am an AI chatbot. I can answer questions, explain ideas, and help you learn.',
    kind: ActivityKind.select,
    options: ['Yes', 'No'],
    correct: {0},
    nextId: 'unit-04-05',
  ),
  'unit-04-05': ActivityDefinition(
    id: 'unit-04-05',
    unit: 4,
    step: 30,
    badge: 'CUSTOMIZATION',
    title: 'Choose Chatbot Type',
    subtitle: 'What should your chatbot focus on?',
    body: 'Pick the kind of chatbot you want to build.',
    kind: ActivityKind.select,
    options: [
      'Math Bot — Learn & Solve',
      'Fun Bot — Play & Explore',
      'Study Coach — Guide & Grow',
      'Helper Bot — Help & Support',
    ],
    correct: {2},
    nextId: 'unit-04-06',
  ),
  'unit-04-06': ActivityDefinition(
    id: 'unit-04-06',
    unit: 4,
    step: 32,
    badge: 'TRAINING DATA',
    title: 'Choose Training Examples',
    subtitle: 'Pick the data that matches your chatbot’s purpose.',
    body:
        'Your chatbot: Study Coach Bot. It should help with study tips, reminders, and learning guidance.',
    kind: ActivityKind.select,
    options: [
      'Math Practice Examples',
      'Fun Facts Examples',
      'Study Coach Examples — Best match',
      'General Helper Examples',
    ],
    correct: {2},
    nextId: 'unit-04-07',
  ),
  'unit-04-07': ActivityDefinition(
    id: 'unit-04-07',
    unit: 4,
    step: 34,
    badge: 'BOT TEST',
    title: 'Test Your Bot',
    subtitle: 'Did your chatbot answer well?',
    body:
        'Prompt: “How can I study for a science test?”\n\nResponse: Start with the hardest topics. Review one at a time, make short notes, and take a quick break after 20 minutes.',
    kind: ActivityKind.select,
    options: ['Yes, it helped', 'Not yet'],
    correct: {0},
  ),
};

class CourseActivityScreen extends ConsumerStatefulWidget {
  const CourseActivityScreen({super.key, required this.activityId});
  final String activityId;
  @override
  ConsumerState<CourseActivityScreen> createState() =>
      _CourseActivityScreenState();
}

class _CourseActivityScreenState extends ConsumerState<CourseActivityScreen> {
  final Set<int> selected = {};
  final List<int> sequence = [];

  ActivityDefinition get activity => activityDefinitions[widget.activityId]!;

  @override
  void initState() {
    super.initState();
    _resetInteractionState();
  }

  @override
  void didUpdateWidget(covariant CourseActivityScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activityId != widget.activityId) {
      _resetInteractionState();
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    _resetInteractionState();
  }

  void _resetInteractionState() {
    selected.clear();
    sequence.clear();
    if (widget.activityId == 'unit-01-02') {
      selected.addAll(activity.correct);
    } else if (widget.activityId == 'unit-01-03') {
      selected.add(0);
    } else if (widget.activityId == 'unit-01-04') {
      selected.add(0);
    } else if (widget.activityId == 'unit-02-02') {
      selected.add(0);
    } else if (widget.activityId == 'unit-02-03') {
      selected.add(0);
    } else if (widget.activityId == 'unit-03-01') {
      selected.addAll({0, 1});
    } else if (widget.activityId == 'unit-03-02') {
      selected.add(0);
    } else if (widget.activityId == 'unit-03-03') {
      selected.add(2);
    } else if (widget.activityId == 'unit-04-01') {
      selected.add(1);
      sequence.add(1);
    } else if (widget.activityId == 'unit-04-02') {
      selected.add(1);
    } else if (widget.activityId == 'unit-04-03') {
      selected.addAll({0, 4, 8});
    } else if (widget.activityId == 'unit-04-04') {
      selected.add(0);
    } else if (widget.activityId == 'unit-04-05') {
      selected.add(2);
    } else if (widget.activityId == 'unit-04-06') {
      selected.add(2);
    } else if (widget.activityId == 'unit-04-07') {
      selected.add(0);
    }
  }

  void _selectPredictionOption(int group, int index) {
    setState(() {
      selected.removeWhere((item) => item ~/ 3 == group);
      selected.add(index);
    });
  }

  void _toggle(int index) {
    setState(() {
      if (activity.kind == ActivityKind.multiSelect) {
        selected.contains(index) ? selected.remove(index) : selected.add(index);
      } else if (activity.kind == ActivityKind.sequence) {
        if (selected.remove(index)) {
          sequence.remove(index);
        } else {
          selected.add(index);
          sequence.add(index);
        }
      } else {
        selected
          ..clear()
          ..add(index);
      }
    });
  }

  void _check() {
    if (activity.kind == ActivityKind.lesson) {
      context.go('/result/${activity.id}?correct=true');
      return;
    }
    if (selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choose an answer before checking.')),
      );
      return;
    }
    final setCorrect =
        selected.length == activity.correct.length &&
        selected.containsAll(activity.correct);
    final expectedSequence = activity.id == 'unit-04-01'
        ? const [1, 0, 2, 3, 4]
        : List.generate(sequence.length, (index) => index);
    final orderCorrect =
        activity.kind != ActivityKind.sequence ||
        (sequence.length == expectedSequence.length &&
            List.generate(
              sequence.length,
              (index) => sequence[index] == expectedSequence[index],
            ).every((matches) => matches));
    context.go('/result/${activity.id}?correct=${setCorrect && orderCorrect}');
  }

  @override
  Widget build(BuildContext context) {
    final a = activity;
    if (a.id == 'unit-01-01') {
      return Scaffold(
        body: SafeArea(
          child: _ActivityArtwork(
            semanticLabel: a.title,
            assetPath: 'assets/illustrations/unit_01_01.png',
            assetHeight: 1200,
            hitTargets: [
              _ArtworkHitTarget(
                label: 'Back to Courses',
                left: 12,
                top: 10,
                width: 54,
                height: 54,
                onTap: () => context.go('/courses'),
              ),
              _ArtworkHitTarget(
                label: 'Notifications',
                left: 322,
                top: 10,
                width: 56,
                height: 54,
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
              ),
              _ArtworkHitTarget(
                label: 'Start',
                left: 14,
                top: 1114,
                width: 362,
                height: 72,
                onTap: _check,
              ),
            ],
          ),
        ),
      );
    }
    if (a.id == 'unit-01-02') {
      const tiles = [
        ('OpenAI', 19.0, 322.0, 'openai'),
        ('YouTube', 140.0, 322.0, 'youtube'),
        ('Spotify', 261.0, 322.0, 'spotify'),
        ('Xbox', 19.0, 443.0, 'xbox'),
        ('Claude', 140.0, 443.0, 'claude'),
        ('PlayStation', 261.0, 443.0, 'playstation'),
        ('Starbucks', 19.0, 564.0, 'starbucks'),
        ('Domino’s', 140.0, 564.0, 'dominos'),
        ('Gemini', 261.0, 564.0, 'gemini'),
      ];
      return Scaffold(
        body: SafeArea(
          child: _ActivityArtwork(
            semanticLabel: a.title,
            assetPath: 'assets/illustrations/unit_01_02.png',
            assetHeight: 833,
            hitTargets: [
              _ArtworkHitTarget(
                label: 'Back to Courses',
                left: 12,
                top: 10,
                width: 54,
                height: 54,
                onTap: () => context.go('/courses'),
              ),
              _ArtworkHitTarget(
                label: 'Notifications',
                left: 322,
                top: 10,
                width: 56,
                height: 54,
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
              ),
              for (var index = 0; index < tiles.length; index++) ...[
                _ArtworkLogoTile(
                  left: tiles[index].$2,
                  top: tiles[index].$3,
                  selected: selected.contains(index),
                  assetPath:
                      'assets/illustrations/unit_01_02_logos/${tiles[index].$4}.png',
                ),
                _ArtworkHitTarget(
                  label: tiles[index].$1,
                  left: tiles[index].$2 - 5,
                  top: tiles[index].$3 - 6,
                  width: 119,
                  height: 121,
                  selected: selected.contains(index),
                  onTap: () => _toggle(index),
                ),
              ],
              _ArtworkHitTarget(
                label: 'Hint',
                left: 14,
                top: 758,
                width: 64,
                height: 70,
                onTap: () {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Look for tools powered by generative AI.',
                        ),
                      ),
                    );
                },
              ),
              _ArtworkHitTarget(
                label: 'Check',
                left: 88,
                top: 758,
                width: 288,
                height: 70,
                onTap: _check,
              ),
            ],
          ),
        ),
      );
    }
    if (a.id == 'unit-01-03') {
      return Scaffold(
        body: SafeArea(
          child: _ActivityArtwork(
            semanticLabel: a.title,
            assetPath: 'assets/illustrations/unit_01_03.png',
            assetHeight: 1187,
            hitTargets: [
              _ArtworkHitTarget(
                label: 'Back to Courses',
                left: 12,
                top: 10,
                width: 54,
                height: 54,
                onTap: () => context.go('/courses'),
              ),
              _ArtworkHitTarget(
                label: 'Notifications',
                left: 322,
                top: 10,
                width: 56,
                height: 54,
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
              ),
              if (!selected.contains(0))
                const _ArtworkWordSlot(
                  left: 52,
                  top: 444,
                  width: 162,
                  label: 'Tap word',
                  filled: false,
                ),
              if (selected.contains(1))
                const _ArtworkWordSlot(
                  left: 52,
                  top: 534,
                  width: 120,
                  label: 'Text',
                  filled: true,
                ),
              if (selected.contains(2))
                const _ArtworkWordSlot(
                  left: 52,
                  top: 669,
                  width: 120,
                  label: 'Answer',
                  filled: true,
                ),
              if (!selected.contains(0))
                const _ArtworkWordBankChip(
                  left: 20,
                  top: 923,
                  width: 180,
                  label: 'Human language',
                  placed: false,
                ),
              if (selected.contains(1))
                const _ArtworkWordBankChip(
                  left: 212,
                  top: 923,
                  width: 85,
                  label: 'Text',
                  placed: true,
                ),
              if (selected.contains(2))
                const _ArtworkWordBankChip(
                  left: 20,
                  top: 992,
                  width: 188,
                  label: 'Answer questions',
                  placed: true,
                ),
              for (final target in const [
                (0, 'Human language', 52.0, 444.0, 162.0),
                (1, 'Text', 52.0, 534.0, 120.0),
                (2, 'Answer questions', 52.0, 669.0, 120.0),
              ])
                _ArtworkHitTarget(
                  label: '${target.$2} answer slot',
                  left: target.$3,
                  top: target.$4,
                  width: target.$5,
                  height: 45,
                  selected: selected.contains(target.$1),
                  onTap: () => _toggle(target.$1),
                ),
              for (final target in const [
                (0, 'Human language', 20.0, 923.0, 180.0),
                (1, 'Text', 212.0, 923.0, 85.0),
                (2, 'Answer questions', 20.0, 992.0, 188.0),
              ])
                _ArtworkHitTarget(
                  label: target.$2,
                  left: target.$3,
                  top: target.$4,
                  width: target.$5,
                  height: 60,
                  selected: selected.contains(target.$1),
                  onTap: () => _toggle(target.$1),
                ),
              _ArtworkHitTarget(
                label: 'Hint',
                left: 14,
                top: 1108,
                width: 64,
                height: 66,
                onTap: () {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Read the sentence around each blank for a clue.',
                        ),
                      ),
                    );
                },
              ),
              _ArtworkHitTarget(
                label: 'Check',
                left: 88,
                top: 1108,
                width: 288,
                height: 66,
                onTap: _check,
              ),
            ],
          ),
        ),
      );
    }
    if (a.id == 'unit-01-04') {
      final selectedQuestion = selected.isEmpty ? 0 : selected.first;
      const questions = [
        'What is an AI chatbot?',
        'Where do chatbots appear?',
        'What can a chatbot do?',
      ];
      return Scaffold(
        body: SafeArea(
          child: _ActivityArtwork(
            semanticLabel: a.title,
            assetPath: 'assets/illustrations/unit_01_04.png',
            assetHeight: 1074,
            contentHeight: 1054,
            hitTargets: [
              _ArtworkHitTarget(
                label: 'Back to Courses',
                left: 12,
                top: 0,
                width: 54,
                height: 54,
                onTap: () => context.go('/courses'),
              ),
              _ArtworkHitTarget(
                label: 'Notifications',
                left: 322,
                top: 0,
                width: 56,
                height: 54,
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
              ),
              if (selectedQuestion != 0) ...[
                _ArtworkChatConversation(questionIndex: selectedQuestion),
                _ArtworkQuestionOption(
                  top: 758,
                  label: questions[0],
                  selected: false,
                ),
                _ArtworkQuestionOption(
                  top: selectedQuestion == 1 ? 814 : 870,
                  label: questions[selectedQuestion],
                  selected: true,
                ),
              ],
              for (var index = 0; index < questions.length; index++)
                _ArtworkHitTarget(
                  label: questions[index],
                  left: 16,
                  top: const [752.0, 808.0, 864.0][index],
                  width: 358,
                  height: 61,
                  selected: selectedQuestion == index,
                  onTap: () => _toggle(index),
                ),
              _ArtworkHitTarget(
                label: 'Check',
                left: 16,
                top: 978,
                width: 358,
                height: 68,
                onTap: _check,
              ),
            ],
          ),
        ),
      );
    }
    if (a.id == 'unit-02-01') {
      const words = [
        ('AI chatbots', 124.0, 835.0, 142.0, Color(0xFF7DE8D2)),
        ('questions', 71.0, 898.0, 127.0, Color(0xFFFFCEB8)),
        ('answer', 212.0, 898.0, 108.0, Color(0xFFFFCEB8)),
        ('using', 92.0, 961.0, 92.0, Color(0xFFCDB0F5)),
        ('words', 199.0, 961.0, 100.0, Color(0xFF99CEE8)),
      ];
      const slotTops = [428.0, 496.0, 565.0, 633.0, 701.0];
      return Scaffold(
        body: SafeArea(
          child: _ActivityArtwork(
            semanticLabel: a.title,
            assetPath: 'assets/illustrations/unit_02_01.png',
            assetHeight: 1175,
            contentHeight: 1155,
            hitTargets: [
              _ArtworkHitTarget(
                label: 'Back to Courses',
                left: 12,
                top: 0,
                width: 54,
                height: 54,
                onTap: () => context.go('/courses'),
              ),
              _ArtworkHitTarget(
                label: 'Notifications',
                left: 322,
                top: 0,
                width: 56,
                height: 54,
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
              ),
              for (var slot = 0; slot < sequence.length; slot++)
                _ArtworkSequenceSlot(
                  top: slotTops[slot],
                  label: words[sequence[slot]].$1,
                  color: words[sequence[slot]].$5,
                ),
              for (var slot = 0; slot < sequence.length; slot++)
                _ArtworkHitTarget(
                  label:
                      'Remove ${words[sequence[slot]].$1} from slot ${slot + 1}',
                  left: 75,
                  top: slotTops[slot],
                  width: 240,
                  height: 56,
                  selected: true,
                  onTap: () => _toggle(sequence[slot]),
                ),
              for (var index = 0; index < words.length; index++) ...[
                if (selected.contains(index))
                  _ArtworkPlacedWordChip(
                    left: words[index].$2,
                    top: words[index].$3,
                    width: words[index].$4,
                    label: words[index].$1,
                  ),
                _ArtworkHitTarget(
                  label: words[index].$1,
                  left: words[index].$2,
                  top: words[index].$3,
                  width: words[index].$4,
                  height: 50,
                  selected: selected.contains(index),
                  onTap: () => _toggle(index),
                ),
              ],
              _ArtworkHitTarget(
                label: 'Check',
                left: 20,
                top: 1091,
                width: 350,
                height: 56,
                onTap: _check,
              ),
            ],
          ),
        ),
      );
    }
    if (a.id == 'unit-02-02') {
      const choices = [
        ('honey', 44.0, 395.0, 74.0),
        ('rocket', 127.0, 395.0, 76.0),
        ('window', 211.0, 395.0, 83.0),
        ('answer', 44.0, 562.0, 81.0),
        ('banana', 132.0, 562.0, 84.0),
        ('planet', 224.0, 562.0, 72.0),
        ('sky', 44.0, 726.0, 56.0),
        ('shoe', 108.0, 726.0, 63.0),
        ('sandwich', 178.0, 726.0, 95.0),
      ];
      final groupSelections = <int, int>{
        for (final index in selected) index ~/ 3: index,
      };
      return Scaffold(
        body: SafeArea(
          child: _ActivityArtwork(
            semanticLabel: a.title,
            assetPath: 'assets/illustrations/unit_02_02.png',
            assetHeight: 956,
            hitTargets: [
              _ArtworkHitTarget(
                label: 'Back to Courses',
                left: 10,
                top: 10,
                width: 55,
                height: 55,
                onTap: () => context.go('/courses'),
              ),
              _ArtworkHitTarget(
                label: 'Notifications',
                left: 322,
                top: 10,
                width: 56,
                height: 54,
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
              ),
              if (groupSelections[0] != null && groupSelections[0] != 0) ...[
                _ArtworkPredictionBlank(
                  left: 241,
                  top: 323,
                  width: 89,
                  label: choices[groupSelections[0]!].$1,
                ),
                const _ArtworkPredictionChoice(
                  left: 44,
                  top: 395,
                  width: 74,
                  label: 'honey',
                  selected: false,
                ),
                _ArtworkPredictionChoice(
                  left: choices[groupSelections[0]!].$2,
                  top: choices[groupSelections[0]!].$3,
                  width: choices[groupSelections[0]!].$4,
                  label: choices[groupSelections[0]!].$1,
                  selected: true,
                ),
              ],
              if (groupSelections[1] case final choice?) ...[
                _ArtworkPredictionBlank(
                  left: 246,
                  top: 499,
                  width: 94,
                  label: choices[choice].$1,
                  height: 40,
                ),
                _ArtworkPredictionChoice(
                  left: choices[choice].$2,
                  top: choices[choice].$3,
                  width: choices[choice].$4,
                  label: choices[choice].$1,
                  selected: true,
                  height: 34,
                ),
              ],
              if (groupSelections[2] case final choice?) ...[
                _ArtworkPredictionBlank(
                  left: 213,
                  top: 662,
                  width: 94,
                  label: choices[choice].$1,
                  height: 40,
                ),
                _ArtworkPredictionChoice(
                  left: choices[choice].$2,
                  top: choices[choice].$3,
                  width: choices[choice].$4,
                  label: choices[choice].$1,
                  selected: true,
                  height: 34,
                ),
              ],
              for (var index = 0; index < choices.length; index++)
                _ArtworkHitTarget(
                  label: choices[index].$1,
                  left: choices[index].$2,
                  top: choices[index].$3,
                  width: choices[index].$4,
                  height: 38,
                  selected: selected.contains(index),
                  onTap: () => _selectPredictionOption(index ~/ 3, index),
                ),
              _ArtworkHitTarget(
                label: 'Hint',
                left: 20,
                top: 891,
                width: 51,
                height: 53,
                onTap: () {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Choose the word that makes each sentence sound natural.',
                        ),
                      ),
                    );
                },
              ),
              _ArtworkHitTarget(
                label: 'Check',
                left: 97,
                top: 891,
                width: 272,
                height: 53,
                onTap: _check,
              ),
            ],
          ),
        ),
      );
    }
    if (a.id == 'unit-02-03') {
      final selectedReply = selected.isEmpty ? 0 : selected.first;
      return Scaffold(
        body: SafeArea(
          child: _ActivityArtwork(
            semanticLabel: a.title,
            assetPath: 'assets/illustrations/unit_02_03.png',
            assetHeight: 1246,
            hitTargets: [
              _ArtworkHitTarget(
                label: 'Back to Courses',
                left: 10,
                top: 8,
                width: 55,
                height: 55,
                onTap: () => context.go('/courses'),
              ),
              _ArtworkHitTarget(
                label: 'Notifications',
                left: 322,
                top: 8,
                width: 56,
                height: 54,
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
              ),
              if (selectedReply == 1) ...[
                const _ArtworkMemoryReplyCard(
                  top: 721,
                  height: 194,
                  reply: 'Reply A:',
                  body:
                      'Mars is called the Red Planet. It has dusty red soil, tall volcanoes, and two small moons.',
                  tag: 'Uses memory',
                  positiveTag: true,
                  selected: false,
                ),
                const _ArtworkMemoryReplyCard(
                  top: 932,
                  height: 166,
                  reply: 'Reply B:',
                  body:
                      'Which planet do you mean? Please tell me the planet name first.',
                  tag: 'No memory',
                  positiveTag: false,
                  selected: true,
                ),
              ],
              _ArtworkHitTarget(
                label: 'Reply A uses memory',
                left: 20,
                top: 721,
                width: 350,
                height: 194,
                selected: selectedReply == 0,
                onTap: () => _toggle(0),
              ),
              _ArtworkHitTarget(
                label: 'Reply B has no memory',
                left: 20,
                top: 932,
                width: 350,
                height: 166,
                selected: selectedReply == 1,
                onTap: () => _toggle(1),
              ),
              _ArtworkHitTarget(
                label: 'Hint',
                left: 20,
                top: 1193,
                width: 51,
                height: 53,
                onTap: () {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text(
                          'The remembered reply should use the planet mentioned earlier.',
                        ),
                      ),
                    );
                },
              ),
              _ArtworkHitTarget(
                label: 'Check',
                left: 97,
                top: 1193,
                width: 272,
                height: 53,
                onTap: _check,
              ),
            ],
          ),
        ),
      );
    }
    if (a.id == 'unit-03-01') {
      const answerRows = [
        ('It gave a clear topic', 1194.0),
        ('It asked for short sentences', 1258.0),
        ('It asked for a kid-friendly answer', 1322.0),
      ];
      return Scaffold(
        body: SafeArea(
          child: _ActivityArtwork(
            semanticLabel: a.title,
            assetPath: 'assets/illustrations/unit_03_01.png',
            assetHeight: 1705,
            contentHeight: 1537,
            hitTargets: [
              _ArtworkHitTarget(
                label: 'Back to Courses',
                left: 10,
                top: 10,
                width: 55,
                height: 55,
                onTap: () => context.go('/courses'),
              ),
              _ArtworkHitTarget(
                label: 'Notifications',
                left: 322,
                top: 10,
                width: 56,
                height: 54,
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
              ),
              if (!selected.contains(0))
                const _ArtworkMultiSelectOption(
                  top: 1194,
                  label: 'It gave a clear topic',
                  selected: false,
                ),
              if (!selected.contains(1))
                const _ArtworkMultiSelectOption(
                  top: 1258,
                  label: 'It asked for short sentences',
                  selected: false,
                ),
              if (selected.contains(2))
                const _ArtworkMultiSelectOption(
                  top: 1322,
                  label: 'It asked for a kid-friendly answer',
                  selected: true,
                ),
              for (var index = 0; index < answerRows.length; index++)
                _ArtworkHitTarget(
                  label: answerRows[index].$1,
                  left: 19,
                  top: answerRows[index].$2,
                  width: 350,
                  height: 53,
                  selected: selected.contains(index),
                  onTap: () => _toggle(index),
                ),
              _ArtworkHitTarget(
                label: 'Hint',
                left: 19,
                top: 1468,
                width: 53,
                height: 55,
                onTap: () {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Look for the topic, requested length, and intended audience.',
                        ),
                      ),
                    );
                },
              ),
              _ArtworkHitTarget(
                label: 'Check',
                left: 95,
                top: 1468,
                width: 274,
                height: 55,
                onTap: _check,
              ),
            ],
          ),
        ),
      );
    }
    if (a.id == 'unit-03-02') {
      const styleRows = [
        ('Funny', 697.0),
        ('Serious', 795.0),
        ('Friendly', 894.0),
      ];
      final selectedStyle = selected.isEmpty ? 0 : selected.first;
      return Scaffold(
        body: SafeArea(
          child: _ActivityArtwork(
            semanticLabel: a.title,
            assetPath: 'assets/illustrations/unit_03_02.png',
            assetHeight: 1195,
            hitTargets: [
              _ArtworkHitTarget(
                label: 'Back to Courses',
                left: 10,
                top: 8,
                width: 55,
                height: 55,
                onTap: () => context.go('/courses'),
              ),
              _ArtworkHitTarget(
                label: 'Notifications',
                left: 322,
                top: 8,
                width: 56,
                height: 55,
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
              ),
              if (selectedStyle != 0) ...[
                _ArtworkStyleAnswer(styleIndex: selectedStyle),
                for (var index = 0; index < styleRows.length; index++)
                  _ArtworkStyleOption(
                    top: styleRows[index].$2,
                    styleIndex: index,
                    selected: selectedStyle == index,
                  ),
              ],
              for (var index = 0; index < styleRows.length; index++)
                _ArtworkHitTarget(
                  label: '${styleRows[index].$1} style',
                  left: 20,
                  top: styleRows[index].$2,
                  width: 350,
                  height: 89,
                  selected: selectedStyle == index,
                  onTap: () => _toggle(index),
                ),
              _ArtworkHitTarget(
                label: 'Hint',
                left: 20,
                top: 1099,
                width: 51,
                height: 52,
                onTap: () {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text(
                          'The same facts can be expressed in different tones.',
                        ),
                      ),
                    );
                },
              ),
              _ArtworkHitTarget(
                label: 'Check',
                left: 97,
                top: 1099,
                width: 272,
                height: 52,
                onTap: _check,
              ),
            ],
          ),
        ),
      );
    }
    if (a.id == 'unit-03-03') {
      const roleRows = [
        ('Be Rude', 656.0),
        ('Be Complicated', 746.0),
        ('Be Respectful', 833.0),
      ];
      final selectedRole = selected.isEmpty ? 2 : selected.first;
      return Scaffold(
        body: SafeArea(
          child: _ActivityArtwork(
            semanticLabel: a.title,
            assetPath: 'assets/illustrations/unit_03_03.png',
            assetHeight: 1070,
            hitTargets: [
              _ArtworkHitTarget(
                label: 'Back to Courses',
                left: 10,
                top: 8,
                width: 55,
                height: 55,
                onTap: () => context.go('/courses'),
              ),
              _ArtworkHitTarget(
                label: 'Notifications',
                left: 322,
                top: 8,
                width: 56,
                height: 55,
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
              ),
              if (selectedRole != 2)
                for (var index = 0; index < roleRows.length; index++)
                  _ArtworkRoleOption(
                    top: roleRows[index].$2,
                    roleIndex: index,
                    selected: selectedRole == index,
                  ),
              for (var index = 0; index < roleRows.length; index++)
                _ArtworkHitTarget(
                  label: roleRows[index].$1,
                  left: 20,
                  top: roleRows[index].$2,
                  width: 350,
                  height: 80,
                  selected: selectedRole == index,
                  onTap: () => _toggle(index),
                ),
              _ArtworkHitTarget(
                label: 'Hint',
                left: 20,
                top: 1006,
                width: 51,
                height: 50,
                onTap: () {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Good chatbot responses should be clear, helpful, and respectful.',
                        ),
                      ),
                    );
                },
              ),
              _ArtworkHitTarget(
                label: 'Check',
                left: 97,
                top: 1006,
                width: 272,
                height: 50,
                onTap: _check,
              ),
            ],
          ),
        ),
      );
    }
    if (a.id == 'unit-04-01') {
      const slotTops = [466.0, 554.0, 627.0, 699.0, 770.0];
      const parts = [
        ('User Question', 35.0, 1006.0, 141.0, Color(0xFFE5E2DA)),
        ('Chat Screen', 0.0, 0.0, 0.0, Color(0xFFFFCBB4)),
        ('AI Brain', 35.0, 909.0, 92.0, Color(0xFF99CEE8)),
        ('Data / Knowledge', 35.0, 957.0, 171.0, Color(0xFFA8EBBD)),
        ('Bot Reply', 140.0, 909.0, 107.0, Color(0xFFCDB0F5)),
      ];
      return Scaffold(
        body: SafeArea(
          child: _ActivityArtwork(
            semanticLabel: a.title,
            assetPath: 'assets/illustrations/unit_04_01.png',
            assetHeight: 1228,
            hitTargets: [
              _ArtworkHitTarget(
                label: 'Back to Courses',
                left: 10,
                top: 8,
                width: 55,
                height: 55,
                onTap: () => context.go('/courses'),
              ),
              _ArtworkHitTarget(
                label: 'Notifications',
                left: 322,
                top: 8,
                width: 56,
                height: 55,
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
              ),
              for (var slot = 1; slot < sequence.length; slot++)
                _ArtworkSystemSlot(
                  top: slotTops[slot],
                  label: parts[sequence[slot]].$1,
                  color: parts[sequence[slot]].$5,
                  partIndex: sequence[slot],
                ),
              for (var slot = 1; slot < sequence.length; slot++)
                _ArtworkHitTarget(
                  label:
                      'Remove ${parts[sequence[slot]].$1} from slot ${slot + 1}',
                  left: 44,
                  top: slotTops[slot],
                  width: 300,
                  height: 61,
                  selected: true,
                  onTap: () => _toggle(sequence[slot]),
                ),
              for (final index in [0, 2, 3, 4]) ...[
                if (selected.contains(index))
                  _ArtworkUsedSystemPart(
                    left: parts[index].$2,
                    top: parts[index].$3,
                    width: parts[index].$4,
                    label: parts[index].$1,
                  ),
                _ArtworkHitTarget(
                  label: parts[index].$1,
                  left: parts[index].$2,
                  top: parts[index].$3,
                  width: parts[index].$4,
                  height: 38,
                  selected: selected.contains(index),
                  onTap: () => _toggle(index),
                ),
              ],
              _ArtworkHitTarget(
                label: 'Hint',
                left: 20,
                top: 1152,
                width: 51,
                height: 52,
                onTap: () {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Start with the screen and question, then process knowledge before replying.',
                        ),
                      ),
                    );
                },
              ),
              _ArtworkHitTarget(
                label: 'Check',
                left: 97,
                top: 1152,
                width: 272,
                height: 52,
                onTap: _check,
              ),
            ],
          ),
        ),
      );
    }
    if (a.id == 'unit-04-02') {
      final selectedLayout = selected.isEmpty ? 1 : selected.first;
      return Scaffold(
        body: SafeArea(
          child: _ActivityArtwork(
            semanticLabel: a.title,
            assetPath: 'assets/illustrations/unit_04_02.png',
            assetHeight: 1130,
            contentHeight: 1106,
            hitTargets: [
              _ArtworkHitTarget(
                label: 'Back to Courses',
                left: 10,
                top: 8,
                width: 55,
                height: 55,
                onTap: () => context.go('/courses'),
              ),
              _ArtworkHitTarget(
                label: 'Notifications',
                left: 322,
                top: 8,
                width: 56,
                height: 55,
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
              ),
              if (selectedLayout == 0) const _ArtworkUiLayoutSelection(),
              _ArtworkHitTarget(
                label: 'Streaming Layout',
                left: 20,
                top: 316,
                width: 349,
                height: 294,
                selected: selectedLayout == 0,
                onTap: () => _toggle(0),
              ),
              _ArtworkHitTarget(
                label: 'BearFetch Chat',
                left: 20,
                top: 630,
                width: 349,
                height: 299,
                selected: selectedLayout == 1,
                onTap: () => _toggle(1),
              ),
              _ArtworkHitTarget(
                label: 'Hint',
                left: 20,
                top: 1041,
                width: 51,
                height: 51,
                onTap: () {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Look for clear messages and a simple reply field.',
                        ),
                      ),
                    );
                },
              ),
              _ArtworkHitTarget(
                label: 'Check',
                left: 97,
                top: 1041,
                width: 272,
                height: 51,
                onTap: _check,
              ),
            ],
          ),
        ),
      );
    }
    if (a.id == 'unit-04-03') {
      const defaultAnswers = [0, 4, 8];
      const choicePositions = [
        (82.0, 435.0, 164.0),
        (82.0, 487.0, 103.0),
        (194.0, 487.0, 112.0),
        (82.0, 656.0, 146.0),
        (82.0, 710.0, 122.0),
        (217.0, 710.0, 110.0),
        (82.0, 879.0, 146.0),
        (236.0, 879.0, 103.0),
        (82.0, 933.0, 130.0),
      ];
      return Scaffold(
        body: SafeArea(
          child: _ActivityArtwork(
            semanticLabel: a.title,
            assetPath: 'assets/illustrations/unit_04_03.png',
            assetHeight: 1152,
            hitTargets: [
              _ArtworkHitTarget(
                label: 'Back to Courses',
                left: 10,
                top: 8,
                width: 55,
                height: 55,
                onTap: () => context.go('/courses'),
              ),
              _ArtworkHitTarget(
                label: 'Notifications',
                left: 322,
                top: 8,
                width: 56,
                height: 55,
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
              ),
              for (var group = 0; group < 3; group++)
                if (!selected.contains(defaultAnswers[group]))
                  for (var offset = 0; offset < 3; offset++)
                    _ArtworkChatFlowPill(
                      left: choicePositions[group * 3 + offset].$1,
                      top: choicePositions[group * 3 + offset].$2,
                      width: choicePositions[group * 3 + offset].$3,
                      label: a.options[group * 3 + offset],
                      selected: selected.contains(group * 3 + offset),
                    ),
              for (var index = 0; index < 9; index++)
                _ArtworkHitTarget(
                  label: 'Step ${index ~/ 3 + 1}: ${a.options[index]}',
                  left: choicePositions[index].$1,
                  top: choicePositions[index].$2,
                  width: choicePositions[index].$3,
                  height: 45,
                  selected: selected.contains(index),
                  onTap: () => _selectPredictionOption(index ~/ 3, index),
                ),
              _ArtworkHitTarget(
                label: 'Hint',
                left: 20,
                top: 1087,
                width: 51,
                height: 51,
                onTap: () {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text(
                          'The interface receives the question, the model works, and the response is shown.',
                        ),
                      ),
                    );
                },
              ),
              _ArtworkHitTarget(
                label: 'Check',
                left: 97,
                top: 1087,
                width: 272,
                height: 51,
                onTap: _check,
              ),
            ],
          ),
        ),
      );
    }
    if (a.id == 'unit-04-04') {
      final selectedAnswer = selected.isEmpty ? 0 : selected.first;
      return Scaffold(
        body: SafeArea(
          child: _ActivityArtwork(
            semanticLabel: a.title,
            assetPath: 'assets/illustrations/unit_04_04.png',
            assetHeight: 1234,
            hitTargets: [
              _ArtworkHitTarget(
                label: 'Back to Courses',
                left: 10,
                top: 8,
                width: 55,
                height: 55,
                onTap: () => context.go('/courses'),
              ),
              _ArtworkHitTarget(
                label: 'Notifications',
                left: 322,
                top: 8,
                width: 56,
                height: 55,
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
              ),
              if (selectedAnswer == 1)
                const _ArtworkYesNoSelection(selectYes: false),
              _ArtworkHitTarget(
                label: 'Yes',
                left: 20,
                top: 833,
                width: 166,
                height: 69,
                selected: selectedAnswer == 0,
                onTap: () => _toggle(0),
              ),
              _ArtworkHitTarget(
                label: 'No',
                left: 203,
                top: 833,
                width: 166,
                height: 69,
                selected: selectedAnswer == 1,
                onTap: () => _toggle(1),
              ),
              _ArtworkHitTarget(
                label: 'Hint',
                left: 20,
                top: 1152,
                width: 51,
                height: 51,
                onTap: () {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text(
                          'A useful chatbot answer should identify itself and clearly explain how it can help.',
                        ),
                      ),
                    );
                },
              ),
              _ArtworkHitTarget(
                label: 'Check',
                left: 97,
                top: 1152,
                width: 272,
                height: 51,
                onTap: _check,
              ),
            ],
          ),
        ),
      );
    }
    if (a.id == 'unit-04-05') {
      final selectedBot = selected.isEmpty ? 2 : selected.first;
      const cardBounds = [
        (20.0, 514.0, 338.0, 136.0),
        (20.0, 665.0, 338.0, 112.0),
        (20.0, 792.0, 338.0, 135.0),
        (20.0, 942.0, 338.0, 111.0),
      ];
      return Scaffold(
        body: SafeArea(
          child: _ActivityArtwork(
            semanticLabel: a.title,
            assetPath: 'assets/illustrations/unit_04_05.png',
            assetHeight: 1211,
            hitTargets: [
              _ArtworkHitTarget(
                label: 'Back to Courses',
                left: 10,
                top: 8,
                width: 55,
                height: 55,
                onTap: () => context.go('/courses'),
              ),
              _ArtworkHitTarget(
                label: 'Notifications',
                left: 322,
                top: 8,
                width: 56,
                height: 55,
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
              ),
              if (selectedBot != 2)
                _ArtworkChatbotTypeCards(selectedIndex: selectedBot),
              for (var index = 0; index < cardBounds.length; index++)
                _ArtworkHitTarget(
                  label: a.options[index],
                  left: cardBounds[index].$1,
                  top: cardBounds[index].$2,
                  width: cardBounds[index].$3,
                  height: cardBounds[index].$4,
                  selected: selectedBot == index,
                  onTap: () => _toggle(index),
                ),
              _ArtworkHitTarget(
                label: 'Hint',
                left: 20,
                top: 1139,
                width: 51,
                height: 51,
                onTap: () {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Choose the bot type that best matches the kind of help you want it to provide.',
                        ),
                      ),
                    );
                },
              ),
              _ArtworkHitTarget(
                label: 'Check',
                left: 97,
                top: 1139,
                width: 272,
                height: 51,
                onTap: _check,
              ),
            ],
          ),
        ),
      );
    }
    if (a.id == 'unit-04-06') {
      final selectedExample = selected.isEmpty ? 2 : selected.first;
      const cardBounds = [
        (20.0, 675.0, 348.0, 220.0),
        (20.0, 912.0, 348.0, 221.0),
        (16.0, 1148.0, 354.0, 292.0),
        (20.0, 1457.0, 348.0, 258.0),
      ];
      return Scaffold(
        body: SafeArea(
          child: _ActivityArtwork(
            semanticLabel: a.title,
            assetPath: 'assets/illustrations/unit_04_06.png',
            assetHeight: 1841,
            hitTargets: [
              _ArtworkHitTarget(
                label: 'Back to Courses',
                left: 10,
                top: 8,
                width: 55,
                height: 55,
                onTap: () => context.go('/courses'),
              ),
              _ArtworkHitTarget(
                label: 'Notifications',
                left: 322,
                top: 8,
                width: 56,
                height: 55,
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
              ),
              if (selectedExample != 2)
                _ArtworkTrainingSelection(selectedIndex: selectedExample),
              for (var index = 0; index < cardBounds.length; index++)
                _ArtworkHitTarget(
                  label: a.options[index],
                  left: cardBounds[index].$1,
                  top: cardBounds[index].$2,
                  width: cardBounds[index].$3,
                  height: cardBounds[index].$4,
                  selected: selectedExample == index,
                  onTap: () => _toggle(index),
                ),
              _ArtworkHitTarget(
                label: 'Hint',
                left: 20,
                top: 1774,
                width: 51,
                height: 51,
                onTap: () {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Training examples should closely match the chatbot’s chosen purpose.',
                        ),
                      ),
                    );
                },
              ),
              _ArtworkHitTarget(
                label: 'Check',
                left: 97,
                top: 1774,
                width: 272,
                height: 51,
                onTap: _check,
              ),
            ],
          ),
        ),
      );
    }
    if (a.id == 'unit-04-07') {
      final selectedResponse = selected.isEmpty ? 0 : selected.first;
      return Scaffold(
        body: SafeArea(
          child: _ActivityArtwork(
            semanticLabel: a.title,
            assetPath: 'assets/illustrations/unit_04_07.png',
            assetHeight: 1261,
            hitTargets: [
              _ArtworkHitTarget(
                label: 'Back to Courses',
                left: 10,
                top: 8,
                width: 55,
                height: 55,
                onTap: () => context.go('/courses'),
              ),
              _ArtworkHitTarget(
                label: 'Notifications',
                left: 322,
                top: 8,
                width: 56,
                height: 55,
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
              ),
              _ArtworkHitTarget(
                label: 'Try Example Prompt',
                left: 47,
                top: 863,
                width: 297,
                height: 57,
                onTap: () {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Example prompt completed. Review the bot response below.',
                        ),
                      ),
                    );
                },
              ),
              if (selectedResponse == 1)
                const _ArtworkBotTestSelection(selectYes: false),
              _ArtworkHitTarget(
                label: 'Yes, it helped',
                left: 20,
                top: 1021,
                width: 180,
                height: 56,
                selected: selectedResponse == 0,
                onTap: () => _toggle(0),
              ),
              _ArtworkHitTarget(
                label: 'Not yet',
                left: 213,
                top: 1021,
                width: 156,
                height: 56,
                selected: selectedResponse == 1,
                onTap: () => _toggle(1),
              ),
              _ArtworkHitTarget(
                label: 'Hint',
                left: 20,
                top: 1197,
                width: 51,
                height: 51,
                onTap: () {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text(
                          'A good Study Coach response gives clear, practical, and manageable advice.',
                        ),
                      ),
                    );
                },
              ),
              _ArtworkHitTarget(
                label: 'Check',
                left: 97,
                top: 1197,
                width: 272,
                height: 51,
                onTap: _check,
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _ActivityHeader(activity: a),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                children: [
                  Chip(
                    avatar: const Icon(Icons.auto_awesome_rounded, size: 17),
                    label: Text(
                      a.badge,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    a.title,
                    style: const TextStyle(
                      fontFamily: 'Fredoka',
                      fontSize: 25,
                      height: 1.15,
                      fontWeight: FontWeight.w700,
                      color: BearfetchColors.cocoa,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    a.subtitle,
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 16,
                      height: 1.4,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6E5546),
                    ),
                  ),
                  const SizedBox(height: 18),
                  BearfetchCard(
                    color: _cardColor(a.unit),
                    child: Text(
                      a.body,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 15,
                        height: 1.55,
                        color: BearfetchColors.cocoa,
                      ),
                    ),
                  ),
                  if (a.kind == ActivityKind.sequence &&
                      sequence.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Text(
                      'YOUR SEQUENCE',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                        color: Color(0xFF8A7567),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 7,
                      runSpacing: 7,
                      children: sequence
                          .map(
                            (index) => Chip(
                              label: Text(
                                '${sequence.indexOf(index) + 1}. ${a.options[index]}',
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                  if (a.options.isNotEmpty) ...[
                    const SizedBox(height: 22),
                    ...List.generate(
                      a.options.length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _AnswerOption(
                          label: a.options[index],
                          selected: selected.contains(index),
                          number: a.kind == ActivityKind.sequence
                              ? sequence.indexOf(index) + 1
                              : null,
                          onTap: () => _toggle(index),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  const RewardPills(),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
              decoration: const BoxDecoration(
                color: Color(0xFFFFFBF5),
                border: Border(top: BorderSide(color: Color(0x225C3317))),
              ),
              child: BearfetchPrimaryButton(
                label: a.kind == ActivityKind.lesson ? 'Start' : 'Check',
                icon: a.kind == ActivityKind.lesson
                    ? Icons.play_arrow_rounded
                    : Icons.check_rounded,
                onPressed: _check,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _cardColor(int unit) => const [
    Color(0xFFEAF4FF),
    Color(0xFFDDF4E7),
    Color(0xFFFFE7D8),
    Color(0xFFEDE4FF),
  ][unit - 1];
}

class _ActivityArtwork extends StatelessWidget {
  const _ActivityArtwork({
    required this.semanticLabel,
    required this.assetPath,
    required this.assetHeight,
    required this.hitTargets,
    this.contentHeight,
  });

  static const _designWidth = 390.0;

  final String semanticLabel;
  final String assetPath;
  final double assetHeight;
  final double? contentHeight;
  final List<Widget> hitTargets;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    explicitChildNodes: true,
    label: semanticLabel,
    child: ColoredBox(
      color: const Color(0xFFFFF8EF),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final scale = constraints.maxWidth / _designWidth;
          final layoutHeight = contentHeight ?? assetHeight;
          return SingleChildScrollView(
            child: SizedBox(
              width: constraints.maxWidth,
              height: layoutHeight * scale,
              child: FittedBox(
                fit: BoxFit.fill,
                child: SizedBox(
                  width: _designWidth,
                  height: layoutHeight,
                  child: Stack(
                    clipBehavior: Clip.hardEdge,
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        width: _designWidth,
                        height: assetHeight,
                        child: Image.asset(
                          assetPath,
                          fit: BoxFit.fill,
                          filterQuality: FilterQuality.high,
                          excludeFromSemantics: true,
                        ),
                      ),
                      ...hitTargets,
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}

class _ArtworkHitTarget extends StatelessWidget {
  const _ArtworkHitTarget({
    required this.label,
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.onTap,
    this.selected,
  });

  final String label;
  final double left;
  final double top;
  final double width;
  final double height;
  final VoidCallback onTap;
  final bool? selected;

  @override
  Widget build(BuildContext context) => Positioned(
    left: left,
    top: top,
    width: width,
    height: height,
    child: Semantics(
      label: label,
      button: true,
      selected: selected,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
      ),
    ),
  );
}

class _ArtworkLogoTile extends StatelessWidget {
  const _ArtworkLogoTile({
    required this.left,
    required this.top,
    required this.selected,
    required this.assetPath,
  });

  final double left;
  final double top;
  final bool selected;
  final String assetPath;

  @override
  Widget build(BuildContext context) => Positioned(
    left: left,
    top: top,
    width: 109,
    height: 109,
    child: IgnorePointer(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: selected
                      ? const Color(0xFFFF9F43)
                      : const Color(0xFF293033),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          Positioned(
            left: 8,
            top: 20,
            width: 93,
            height: 79,
            child: Image.asset(
              assetPath,
              fit: BoxFit.fill,
              filterQuality: FilterQuality.high,
              excludeFromSemantics: true,
            ),
          ),
          if (selected)
            const Positioned(right: -5, top: -6, child: _ArtworkCheckmark()),
        ],
      ),
    ),
  );
}

class _ArtworkCheckmark extends StatelessWidget {
  const _ArtworkCheckmark();

  @override
  Widget build(BuildContext context) => Container(
    width: 24,
    height: 24,
    decoration: BoxDecoration(
      color: const Color(0xFFFF9F43),
      shape: BoxShape.circle,
      border: Border.all(color: const Color(0xFF293033), width: 2),
    ),
    child: const Icon(Icons.check_rounded, size: 16, color: Color(0xFF293033)),
  );
}

class _ArtworkWordSlot extends StatelessWidget {
  const _ArtworkWordSlot({
    required this.left,
    required this.top,
    required this.width,
    required this.label,
    required this.filled,
  });

  final double left;
  final double top;
  final double width;
  final String label;
  final bool filled;

  @override
  Widget build(BuildContext context) => Positioned(
    left: left,
    top: top,
    width: width,
    height: 42,
    child: IgnorePointer(
      child: filled
          ? Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFFFCEB8),
                border: Border.all(color: const Color(0xFF293033), width: 2),
                borderRadius: BorderRadius.circular(11),
                boxShadow: const [
                  BoxShadow(color: Color(0xFF293033), offset: Offset(0, 3)),
                ],
              ),
              child: Text(
                label,
                maxLines: 1,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF293033),
                ),
              ),
            )
          : CustomPaint(
              foregroundPainter: _DashedRoundRectPainter(),
              child: ColoredBox(
                color: const Color(0xFFFBF9F1),
                child: Center(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFE2C9BA),
                    ),
                  ),
                ),
              ),
            ),
    ),
  );
}

class _ArtworkWordBankChip extends StatelessWidget {
  const _ArtworkWordBankChip({
    required this.left,
    required this.top,
    required this.width,
    required this.label,
    required this.placed,
  });

  final double left;
  final double top;
  final double width;
  final String label;
  final bool placed;

  @override
  Widget build(BuildContext context) => Positioned(
    left: left,
    top: top,
    width: width,
    height: 58,
    child: IgnorePointer(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: placed ? const Color(0xFFF6DDCE) : const Color(0xFFFBF9F1),
          border: Border.all(
            color: placed ? const Color(0xFF858A88) : const Color(0xFF293033),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: placed ? const Color(0xFF858A88) : const Color(0xFF293033),
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Text(
          label,
          maxLines: 1,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: placed ? const Color(0xFF858A88) : const Color(0xFF293033),
          ),
        ),
      ),
    ),
  );
}

class _ArtworkQuestionOption extends StatelessWidget {
  const _ArtworkQuestionOption({
    required this.top,
    required this.label,
    required this.selected,
  });

  final double top;
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) => Positioned(
    left: 21,
    top: top,
    width: 348,
    height: 50,
    child: IgnorePointer(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFCEB8) : const Color(0xFFFBF9F1),
          border: Border.all(
            color: selected ? const Color(0xFF9B5700) : const Color(0xFF293033),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(color: Color(0xFF293033), offset: Offset(0, 3)),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF514338),
                ),
              ),
            ),
            if (selected)
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF9B5700), width: 2),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 14,
                  color: Color(0xFF9B5700),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

class _ArtworkChatConversation extends StatelessWidget {
  const _ArtworkChatConversation({required this.questionIndex});

  final int questionIndex;

  @override
  Widget build(BuildContext context) {
    final question = questionIndex == 1
        ? 'Where do chatbots appear?'
        : 'What can a chatbot do?';
    final answer = questionIndex == 1
        ? 'Chatbots appear in apps, websites, games, search, shopping, and support.'
        : 'A chatbot can answer questions, explain ideas, and help people complete tasks.';

    return Positioned(
      left: 23,
      top: 278,
      width: 344,
      height: 421,
      child: IgnorePointer(
        child: ColoredBox(
          color: const Color(0xFFFBF9F1),
          child: Stack(
            children: [
              const Positioned(
                left: 57,
                top: 34,
                width: 264,
                child: _ArtworkChatBubble(
                  text:
                      'Hi! I’m BearFetch Bot. Ask me a question, and I’ll reply with an answer.',
                  color: Color(0xFFA9EDBE),
                ),
              ),
              const Positioned(
                left: 16,
                top: 93,
                child: _ArtworkChatAvatar(bot: true),
              ),
              Positioned(
                right: 28,
                top: 141,
                width: 252,
                child: _ArtworkChatBubble(
                  text: question,
                  color: const Color(0xFFFFCEB8),
                  compact: true,
                ),
              ),
              const Positioned(
                right: 5,
                top: 151,
                child: _ArtworkChatAvatar(bot: false),
              ),
              Positioned(
                left: 57,
                top: 201,
                width: 264,
                child: _ArtworkChatBubble(
                  text: answer,
                  color: const Color(0xFFA9EDBE),
                ),
              ),
              const Positioned(
                left: 16,
                top: 260,
                child: _ArtworkChatAvatar(bot: true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArtworkChatBubble extends StatelessWidget {
  const _ArtworkChatBubble({
    required this.text,
    required this.color,
    this.compact = false,
  });

  final String text;
  final Color color;
  final bool compact;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(
      horizontal: compact ? 15 : 16,
      vertical: compact ? 9 : 11,
    ),
    decoration: BoxDecoration(
      color: color,
      border: Border.all(color: const Color(0xFF293033), width: 2),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
        bottomRight: Radius.circular(15),
      ),
    ),
    child: Text(
      text,
      style: const TextStyle(
        fontFamily: 'Nunito',
        fontSize: 15,
        height: 1.35,
        fontWeight: FontWeight.w700,
        color: Color(0xFF293033),
      ),
    ),
  );
}

class _ArtworkChatAvatar extends StatelessWidget {
  const _ArtworkChatAvatar({required this.bot});

  final bool bot;

  @override
  Widget build(BuildContext context) => Container(
    width: 32,
    height: 32,
    decoration: BoxDecoration(
      color: bot ? const Color(0xFF9DD9F1) : const Color(0xFFFFF4DB),
      shape: BoxShape.circle,
      border: Border.all(color: const Color(0xFF293033), width: 2),
    ),
    child: Icon(
      bot ? Icons.smart_toy_rounded : Icons.face_rounded,
      size: 17,
      color: const Color(0xFF293033),
    ),
  );
}

class _ArtworkSequenceSlot extends StatelessWidget {
  const _ArtworkSequenceSlot({
    required this.top,
    required this.label,
    required this.color,
  });

  final double top;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Positioned(
    left: 75,
    top: top,
    width: 240,
    height: 56,
    child: IgnorePointer(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: const Color(0xFF293033), width: 2),
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(color: Color(0xFF293033), offset: Offset(0, 4)),
          ],
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 15,
            fontWeight: FontWeight.w900,
            color: Color(0xFF293033),
          ),
        ),
      ),
    ),
  );
}

class _ArtworkPlacedWordChip extends StatelessWidget {
  const _ArtworkPlacedWordChip({
    required this.left,
    required this.top,
    required this.width,
    required this.label,
  });

  final double left;
  final double top;
  final double width;
  final String label;

  @override
  Widget build(BuildContext context) => Positioned(
    left: left,
    top: top,
    width: width,
    height: 50,
    child: IgnorePointer(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFE5E2DA),
          border: Border.all(color: const Color(0xFF8B8D89), width: 2),
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(color: Color(0xFF8B8D89), offset: Offset(0, 4)),
          ],
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: Color(0xFF8B8D89),
          ),
        ),
      ),
    ),
  );
}

class _ArtworkPredictionBlank extends StatelessWidget {
  const _ArtworkPredictionBlank({
    required this.left,
    required this.top,
    required this.width,
    required this.label,
    this.height = 50,
  });

  final double left;
  final double top;
  final double width;
  final String label;
  final double height;

  @override
  Widget build(BuildContext context) => Positioned(
    left: left,
    top: top,
    width: width,
    height: height,
    child: IgnorePointer(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFFFCEB8),
          border: Border.all(color: const Color(0xFFFF9F43), width: 2),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(color: Color(0xFFFF9F43), offset: Offset(0, 4)),
          ],
        ),
        child: Text(
          label,
          maxLines: 1,
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 15,
            fontWeight: FontWeight.w900,
            color: Color(0xFFFFA45E),
          ),
        ),
      ),
    ),
  );
}

class _ArtworkPredictionChoice extends StatelessWidget {
  const _ArtworkPredictionChoice({
    required this.left,
    required this.top,
    required this.width,
    required this.label,
    required this.selected,
    this.height = 38,
  });

  final double left;
  final double top;
  final double width;
  final String label;
  final bool selected;
  final double height;

  @override
  Widget build(BuildContext context) => Positioned(
    left: left,
    top: top,
    width: width,
    height: height,
    child: IgnorePointer(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFD5D5D5) : const Color(0xFFFFFDF8),
          border: selected
              ? Border.all(color: const Color(0xFFD5B98A), width: 2)
              : null,
          borderRadius: BorderRadius.circular(13),
        ),
        child: Text(
          label,
          maxLines: 1,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 13,
            fontWeight: FontWeight.w900,
            color: selected ? const Color(0xFFD7C2A2) : const Color(0xFF514338),
          ),
        ),
      ),
    ),
  );
}

class _ArtworkMemoryReplyCard extends StatelessWidget {
  const _ArtworkMemoryReplyCard({
    required this.top,
    required this.height,
    required this.reply,
    required this.body,
    required this.tag,
    required this.positiveTag,
    required this.selected,
  });

  final double top;
  final double height;
  final String reply;
  final String body;
  final String tag;
  final bool positiveTag;
  final bool selected;

  @override
  Widget build(BuildContext context) => Positioned(
    left: 20,
    top: top,
    width: 350,
    height: height,
    child: IgnorePointer(
      child: Container(
        padding: const EdgeInsets.fromLTRB(25, 25, 46, 20),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFD6BF) : const Color(0xFFFBF9F1),
          border: Border.all(
            color: selected ? const Color(0xFF9B5700) : const Color(0xFF4B3333),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: selected
                  ? const Color(0xFF9B5700)
                  : const Color(0xFF4B3333),
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '$reply ',
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                        TextSpan(text: body),
                      ],
                    ),
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 16,
                      height: 1.45,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF171713),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: positiveTag
                          ? const Color(0xFFE5F3DE)
                          : const Color(0xFFFFF0EA),
                      border: Border.all(
                        color: positiveTag
                            ? const Color(0xFF72DDC5)
                            : const Color(0xFFD91F26),
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${positiveTag ? '⚙' : '⊘'} $tag',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: positiveTag
                            ? const Color(0xFF007B63)
                            : const Color(0xFFD91F26),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: -20,
              top: -3,
              child: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF9B5700)
                      : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected
                        ? const Color(0xFF9B5700)
                        : const Color(0xFF4B3333),
                    width: 2,
                  ),
                ),
                child: selected
                    ? const Icon(
                        Icons.check_rounded,
                        size: 17,
                        color: Colors.white,
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _ArtworkBotTestSelection extends StatelessWidget {
  const _ArtworkBotTestSelection({required this.selectYes});

  final bool selectYes;

  @override
  Widget build(BuildContext context) {
    Widget option({
      required double left,
      required double width,
      required String label,
      required bool selected,
    }) => Positioned(
      left: left,
      top: 1021,
      width: width,
      height: 56,
      child: IgnorePointer(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFA8EDBD) : Colors.white,
            border: Border.all(color: const Color(0xFF293033), width: 2),
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [
              BoxShadow(color: Color(0xFF293033), offset: Offset(0, 5)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (selected) ...[
                Container(
                  width: 21,
                  height: 21,
                  decoration: const BoxDecoration(
                    color: Color(0xFF256245),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF293033),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return Stack(
      children: [
        option(
          left: 20,
          width: 180,
          label: 'Yes, it helped',
          selected: selectYes,
        ),
        option(left: 213, width: 156, label: 'Not yet', selected: !selectYes),
      ],
    );
  }
}

class _ArtworkTrainingSelection extends StatelessWidget {
  const _ArtworkTrainingSelection({required this.selectedIndex});

  final int selectedIndex;

  static const _cardBounds = [
    (20.0, 675.0, 348.0, 220.0),
    (20.0, 912.0, 348.0, 221.0),
    (16.0, 1148.0, 354.0, 292.0),
    (20.0, 1457.0, 348.0, 258.0),
  ];

  @override
  Widget build(BuildContext context) {
    final selectedBounds = _cardBounds[selectedIndex];
    return Stack(
      children: [
        const Positioned(
          left: 340,
          top: 1131,
          width: 50,
          height: 20,
          child: ColoredBox(color: Color(0xFFFFF8EF)),
        ),
        Positioned(
          left: 16,
          top: 1148,
          width: 354,
          height: 292,
          child: IgnorePointer(
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 22, 18),
              decoration: BoxDecoration(
                color: const Color(0xFFFCFAF3),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFF4B3333), width: 2),
                boxShadow: const [
                  BoxShadow(color: Color(0xFF4B3333), offset: Offset(0, 6)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Study Coach\nExamples',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 21,
                      height: 1.25,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF4B3333),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Helpful study advice, reminders, and\nlearning support.',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 16,
                      height: 1.45,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B5652),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(
                        width: 75,
                        height: 52,
                        child: Stack(
                          children: [
                            _ArtworkTrainingIcon(
                              left: 0,
                              icon: Icons.menu_book_rounded,
                              color: Color(0xFF7650B6),
                            ),
                            _ArtworkTrainingIcon(
                              left: 31,
                              icon: Icons.emoji_events_rounded,
                              color: Color(0xFF9B5700),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 98,
                          padding: const EdgeInsets.all(13),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F6F1),
                            border: Border.all(
                              color: const Color(0xFFD0CAC5),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'User: I have a test\ntomorrow\nBot: Let’s make a review\nplan...',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 11,
                              height: 1.35,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF574A43),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: selectedBounds.$1,
          top: selectedBounds.$2,
          width: selectedBounds.$3,
          height: selectedBounds.$4,
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFFF9F43), width: 3),
              ),
            ),
          ),
        ),
        Positioned(
          left: selectedBounds.$1 + selectedBounds.$3 - 24,
          top: selectedBounds.$2 - 10,
          width: 39,
          height: 39,
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFF9F43),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF4B3333), width: 2),
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 25,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ArtworkTrainingIcon extends StatelessWidget {
  const _ArtworkTrainingIcon({
    required this.left,
    required this.icon,
    required this.color,
  });

  final double left;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Positioned(
    left: left,
    bottom: 0,
    width: 45,
    height: 45,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF4B3333), width: 2),
      ),
      child: Icon(icon, color: color, size: 23),
    ),
  );
}

class _ArtworkChatbotTypeCards extends StatelessWidget {
  const _ArtworkChatbotTypeCards({required this.selectedIndex});

  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    const cards = [
      (
        top: 514.0,
        height: 136.0,
        title: 'Math Bot',
        tag: 'Learn & Solve',
        description:
            'Helps solve simple math\nquestions and explain steps\nclearly.',
        icon: Icons.calculate_outlined,
        color: Color(0xFF9BD2EC),
        iconColor: Color(0xFF007568),
      ),
      (
        top: 665.0,
        height: 112.0,
        title: 'Fun Bot',
        tag: 'Play & Explore',
        description: 'Shares jokes, fun facts, and\nplayful answers.',
        icon: Icons.star_rounded,
        color: Color(0xFFFFCBB4),
        iconColor: Color(0xFF9B5700),
      ),
      (
        top: 792.0,
        height: 135.0,
        title: 'Study Coach',
        tag: 'Guide & Grow',
        description:
            'Guides you with study\ntips, reminders, and\nencouragement.',
        icon: Icons.emoji_events_rounded,
        color: Color(0xFFA8EDBD),
        iconColor: Color(0xFF9B5700),
      ),
      (
        top: 942.0,
        height: 111.0,
        title: 'Helper Bot',
        tag: 'Help & Support',
        description: 'Answers general questions\nand gives useful support.',
        icon: Icons.support_agent_rounded,
        color: Color(0xFFFCFAF3),
        iconColor: Color(0xFF7650B6),
      ),
    ];

    return Stack(
      children: [
        const Positioned(
          right: 12,
          top: 779,
          width: 43,
          height: 18,
          child: ColoredBox(color: Color(0xFFFFF8EF)),
        ),
        for (var index = 0; index < cards.length; index++)
          Positioned(
            left: 20,
            top: cards[index].top,
            width: 338,
            height: cards[index].height,
            child: IgnorePointer(
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 14, 12),
                decoration: BoxDecoration(
                  color: index == selectedIndex
                      ? cards[index].color
                      : const Color(0xFFFCFAF3),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        cards[index].icon,
                        size: 31,
                        color: cards[index].iconColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  cards[index].title,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 21,
                                    height: 1.05,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF171914),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 9,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  cards[index].tag,
                                  style: const TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF5A4B42),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 7),
                          Text(
                            cards[index].description,
                            style: const TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 16,
                              height: 1.45,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF5A4438),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        Positioned(
          right: 14,
          top: cards[selectedIndex].top - 5,
          width: 35,
          height: 35,
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFA8EDBD),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF4B3333), width: 2),
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 24,
                color: Color(0xFF164E35),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ArtworkYesNoSelection extends StatelessWidget {
  const _ArtworkYesNoSelection({required this.selectYes});

  final bool selectYes;

  @override
  Widget build(BuildContext context) {
    Widget option({
      required double left,
      required String label,
      required bool selected,
    }) => Positioned(
      left: selected ? left : left - 1,
      top: selected ? 833 : 832,
      width: selected ? 166 : 168,
      height: selected ? 69 : 71,
      child: IgnorePointer(
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFFFCBB4) : const Color(0xFFFBF9F1),
            border: Border.all(
              color: selected
                  ? const Color(0xFFFF9F43)
                  : const Color(0xFFE5E2DA),
              width: 3,
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: selected
                    ? const Color(0xFF9B5700)
                    : const Color(0xFFE5E2DA),
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Center(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF4B3B32),
                  ),
                ),
              ),
              if (selected)
                Positioned(
                  right: -13,
                  top: -18,
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: const Color(0xFFA8EBBD),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF4B3333),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Color(0xFF3C674F),
                      size: 22,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );

    return Positioned.fill(
      child: Stack(
        children: [
          option(left: 20, label: 'Yes', selected: selectYes),
          option(left: 203, label: 'No', selected: !selectYes),
          if (!selectYes)
            const Positioned(
              left: 159,
              top: 815,
              width: 38,
              height: 38,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Color(0xFFFBF5EB),
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ArtworkChatFlowPill extends StatelessWidget {
  const _ArtworkChatFlowPill({
    required this.left,
    required this.top,
    required this.width,
    required this.label,
    required this.selected,
  });

  final double left;
  final double top;
  final double width;
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) => Positioned(
    left: left,
    top: top,
    width: width,
    height: 45,
    child: IgnorePointer(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFA8EBBD) : const Color(0xFFFBF9F1),
          border: Border.all(color: const Color(0xFF293033), width: 2),
          borderRadius: BorderRadius.circular(23),
          boxShadow: const [
            BoxShadow(color: Color(0xFF293033), offset: Offset(0, 4)),
          ],
        ),
        child: Text(
          '${selected ? '● ' : ''}$label',
          maxLines: 1,
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Color(0xFF4B3B32),
          ),
        ),
      ),
    ),
  );
}

class _ArtworkUiLayoutSelection extends StatelessWidget {
  const _ArtworkUiLayoutSelection();

  @override
  Widget build(BuildContext context) => Positioned.fill(
    child: IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            left: 20,
            top: 316,
            width: 349,
            height: 294,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFFF9F43), width: 4),
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
          Positioned(
            right: 7,
            top: 303,
            child: IgnorePointer(
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9F43),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF4B3333), width: 3),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: 630,
            width: 349,
            height: 299,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF4B3333), width: 4),
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
          Positioned(
            right: 7,
            top: 617,
            child: IgnorePointer(
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFFBF9F1),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF4B3333), width: 3),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _ArtworkSystemSlot extends StatelessWidget {
  const _ArtworkSystemSlot({
    required this.top,
    required this.label,
    required this.color,
    required this.partIndex,
  });

  final double top;
  final String label;
  final Color color;
  final int partIndex;

  @override
  Widget build(BuildContext context) => Positioned(
    left: 44,
    top: top,
    width: 300,
    height: 61,
    child: IgnorePointer(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: const Color(0xFF9B5700), width: 2),
          borderRadius: BorderRadius.circular(13),
          boxShadow: const [
            BoxShadow(color: Color(0xFF9B5700), offset: Offset(0, 5)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 39,
              height: 39,
              decoration: const BoxDecoration(
                color: Color(0xFFFBF9F1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                switch (partIndex) {
                  0 => Icons.question_answer_rounded,
                  2 => Icons.smart_toy_rounded,
                  3 => Icons.storage_rounded,
                  _ => Icons.reply_rounded,
                },
                color: const Color(0xFF9B5700),
                size: 23,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF171815),
                ),
              ),
            ),
            Container(
              width: 25,
              height: 25,
              decoration: const BoxDecoration(
                color: Color(0xFF9B5700),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 17,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _ArtworkUsedSystemPart extends StatelessWidget {
  const _ArtworkUsedSystemPart({
    required this.left,
    required this.top,
    required this.width,
    required this.label,
  });

  final double left;
  final double top;
  final double width;
  final String label;

  @override
  Widget build(BuildContext context) => Positioned(
    left: left,
    top: top,
    width: width,
    height: 38,
    child: IgnorePointer(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFE5E2DA),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: Color(0xFF9B978E),
          ),
        ),
      ),
    ),
  );
}

class _ArtworkRoleOption extends StatelessWidget {
  const _ArtworkRoleOption({
    required this.top,
    required this.roleIndex,
    required this.selected,
  });

  final double top;
  final int roleIndex;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    const labels = ['Be Rude', 'Be Complicated', 'Be Respectful'];
    const icons = [
      Icons.warning_rounded,
      Icons.psychology,
      Icons.volunteer_activism,
    ];
    const iconColors = [
      Color(0xFFC82E32),
      Color(0xFF5E5047),
      Color(0xFF9B5700),
    ];
    return Positioned(
      left: 20,
      top: top,
      width: 350,
      height: 80,
      child: IgnorePointer(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFFFCBB4) : const Color(0xFFFFFFFF),
            border: Border.all(
              color: selected
                  ? const Color(0xFF9B5700)
                  : const Color(0xFF4B3333),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: selected
                    ? const Color(0xFF9B5700)
                    : const Color(0xFF4B3333),
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: roleIndex == 0
                      ? const Color(0xFFFFDADA)
                      : const Color(0xFFFBF9F1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: roleIndex == 0
                        ? const Color(0xFFE8797C)
                        : const Color(0xFFDCC9BA),
                    width: 2,
                  ),
                ),
                child: Icon(
                  icons[roleIndex],
                  size: 25,
                  color: iconColors[roleIndex],
                ),
              ),
              const SizedBox(width: 16),
              Text(
                labels[roleIndex],
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                  color: selected
                      ? const Color(0xFF9B5700)
                      : const Color(0xFF171815),
                ),
              ),
              const Spacer(),
              Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF9B5700)
                      : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected
                        ? const Color(0xFF9B5700)
                        : const Color(0xFFDECBBB),
                    width: 2,
                  ),
                ),
                child: selected
                    ? const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 17,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArtworkStyleAnswer extends StatelessWidget {
  const _ArtworkStyleAnswer({required this.styleIndex});

  final int styleIndex;

  @override
  Widget build(BuildContext context) {
    final isSerious = styleIndex == 1;
    final styleName = isSerious ? 'Serious style' : 'Friendly style';
    final answer = isSerious
        ? '“A black hole is a region of space where gravity is so strong that nothing, including light, can escape.”'
        : '“A black hole is a super-strong space neighbor that pulls everything close—even light—but it stays very far away from us.”';
    return Positioned(
      left: 20,
      top: 409,
      width: 350,
      height: 260,
      child: IgnorePointer(
        child: Container(
          padding: const EdgeInsets.fromLTRB(26, 26, 26, 20),
          decoration: BoxDecoration(
            color: const Color(0xFF9FD2E9),
            border: Border.all(color: const Color(0xFF293033), width: 2),
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(color: Color(0xFF293033), offset: Offset(0, 4)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 39,
                    height: 39,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBF9F1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF293033),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.smart_toy_rounded,
                      color: Color(0xFF7750B8),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'AI ANSWER',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF293033),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9F43),
                      border: Border.all(
                        color: const Color(0xFF293033),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      styleName,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF754000),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Text(
                answer,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 18,
                  height: 1.52,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF293033),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArtworkStyleOption extends StatelessWidget {
  const _ArtworkStyleOption({
    required this.top,
    required this.styleIndex,
    required this.selected,
  });

  final double top;
  final int styleIndex;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    const labels = ['Funny', 'Serious', 'Friendly'];
    const icons = [
      Icons.star_rounded,
      Icons.bookmark_rounded,
      Icons.waving_hand,
    ];
    return Positioned(
      left: 20,
      top: top,
      width: 350,
      height: 89,
      child: IgnorePointer(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 17),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFFFCBB4) : const Color(0xFFFBF9F1),
            border: Border.all(
              color: selected
                  ? const Color(0xFF9B5700)
                  : const Color(0xFF8B7B6D),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(13),
            boxShadow: [
              BoxShadow(
                color: selected
                    ? const Color(0xFF9B5700)
                    : const Color(0xFF8B7B6D),
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFFBF9F1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected
                        ? const Color(0xFF9B5700)
                        : const Color(0xFF8B7B6D),
                    width: 2,
                  ),
                ),
                child: Icon(
                  icons[styleIndex],
                  size: 25,
                  color: selected
                      ? const Color(0xFF9B5700)
                      : const Color(0xFF5C4B40),
                ),
              ),
              const SizedBox(width: 17),
              Text(
                labels[styleIndex],
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                  color: selected
                      ? const Color(0xFF8B4E00)
                      : const Color(0xFF4B3B32),
                ),
              ),
              const Spacer(),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF9B5700)
                      : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected
                        ? const Color(0xFF9B5700)
                        : const Color(0xFF8B7B6D),
                    width: 2,
                  ),
                ),
                child: selected
                    ? const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 21,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArtworkMultiSelectOption extends StatelessWidget {
  const _ArtworkMultiSelectOption({
    required this.top,
    required this.label,
    required this.selected,
  });

  final double top;
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) => Positioned(
    left: 19,
    top: top,
    width: 350,
    height: 53,
    child: IgnorePointer(
      child: Container(
        padding: const EdgeInsets.fromLTRB(17, 0, 13, 0),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFCEB8) : const Color(0xFFFBF9F1),
          border: Border.all(
            color: selected ? const Color(0xFF9B5700) : const Color(0xFF293033),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(11),
          boxShadow: [
            BoxShadow(
              color: selected
                  ? const Color(0xFF9B5700)
                  : const Color(0xFF293033),
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: selected
                      ? const Color(0xFF7B3F00)
                      : const Color(0xFF293033),
                ),
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: selected ? const Color(0xFF9B5700) : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? const Color(0xFF9B5700)
                      : const Color(0xFF293033),
                  width: 2,
                ),
              ),
              child: selected
                  ? const Icon(
                      Icons.check_rounded,
                      size: 17,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    ),
  );
}

class _DashedRoundRectPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF938277)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(11)),
      );
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final end = distance + 6 < metric.length ? distance + 6 : metric.length;
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += 10;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ActivityHeader extends StatelessWidget {
  const _ActivityHeader({required this.activity});
  final ActivityDefinition activity;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
    decoration: const BoxDecoration(
      color: Color(0xFFFFFBF5),
      border: Border(bottom: BorderSide(color: Color(0x225C3317))),
    ),
    child: Column(
      children: [
        Row(
          children: [
            IconButton.filledTonal(
              onPressed: () => context.go('/courses'),
              icon: const Icon(Icons.arrow_back_rounded),
            ),
            Expanded(
              child: Column(
                children: [
                  const Text(
                    'AI Course',
                    style: TextStyle(
                      fontFamily: 'Fredoka',
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Unit ${activity.unit} of 5',
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            IconButton.outlined(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none_rounded),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: activity.step / 36,
          minHeight: 7,
          borderRadius: BorderRadius.circular(99),
          color: BearfetchColors.orange,
          backgroundColor: const Color(0xFFE7E1DA),
        ),
        const SizedBox(height: 6),
        Text(
          'Step ${activity.step} of 36',
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: Color(0xFF74675F),
          ),
        ),
      ],
    ),
  );
}

class _AnswerOption extends StatelessWidget {
  const _AnswerOption({
    required this.label,
    required this.selected,
    required this.onTap,
    this.number,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final int? number;
  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    selected: selected,
    child: InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFD1BC) : const Color(0xFFFFFBF5),
          border: Border.all(
            color: selected ? BearfetchColors.orange : const Color(0xFF817269),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(color: Color(0xFF5D5048), offset: Offset(0, 3)),
          ],
        ),
        child: Row(
          children: [
            if (number != null && number! > 0) ...[
              CircleAvatar(
                radius: 14,
                backgroundColor: BearfetchColors.orange,
                child: Text(
                  '$number',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: BearfetchColors.cocoa,
                ),
              ),
            ),
            Icon(
              selected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: selected
                  ? const Color(0xFFA45C00)
                  : const Color(0xFF8A7C72),
            ),
          ],
        ),
      ),
    ),
  );
}
