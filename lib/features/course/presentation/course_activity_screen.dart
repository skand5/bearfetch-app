import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/bearfetch_theme.dart';
import '../../../core/widgets/bearfetch_ui.dart';
import '../../../domain/content/course_catalog.dart' as content;

class CourseActivityScreen extends ConsumerStatefulWidget {
  const CourseActivityScreen({
    super.key,
    required this.activityId,
    this.chatbotTypeIndex,
  });

  final String activityId;

  /// Ephemeral scripted-simulation choice. It travels only through this
  /// course route; it is never written to learner data or the sync outbox.
  final int? chatbotTypeIndex;
  @override
  ConsumerState<CourseActivityScreen> createState() =>
      _CourseActivityScreenState();
}

class _CourseActivityScreenState extends ConsumerState<CourseActivityScreen> {
  final Set<int> selected = {};
  final List<int> sequence = [];
  Timer? _lessonRevealTimer;
  Timer? _botTestLoadingTimer;
  int _lessonRevealCount = 0;
  int? _activeChatQuestion;
  int? _activeStyleIndex;
  bool _botTestPromptTried = false;
  bool _botTestLoaded = false;

  content.ActivityDefinition get activity =>
      ref.read(content.courseCatalogProvider).activity(widget.activityId);

  @override
  void initState() {
    super.initState();
    _resetInteractionState();
    _startLessonReveal();
    _startBotTestLoading();
  }

  @override
  void didUpdateWidget(covariant CourseActivityScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activityId != widget.activityId) {
      _resetInteractionState();
      _startLessonReveal();
      _startBotTestLoading();
    }
  }

  @override
  void dispose() {
    _lessonRevealTimer?.cancel();
    _botTestLoadingTimer?.cancel();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    _resetInteractionState();
    _startBotTestLoading();
  }

  void _resetInteractionState() {
    selected.clear();
    sequence.clear();
    _activeChatQuestion = null;
    _activeStyleIndex = null;
    _botTestPromptTried = false;
    _botTestLoaded = false;
  }

  void _startBotTestLoading() {
    _botTestLoadingTimer?.cancel();
    if (widget.activityId != 'unit-04-07') return;
    _botTestLoadingTimer = Timer(const Duration(seconds: 1), () {
      if (mounted) setState(() => _botTestLoaded = true);
    });
  }

  void _startLessonReveal() {
    _lessonRevealTimer?.cancel();
    _lessonRevealCount = widget.activityId == 'unit-01-01' ? 0 : 9;
    if (widget.activityId != 'unit-01-01') return;

    _lessonRevealTimer = Timer.periodic(const Duration(milliseconds: 420), (
      timer,
    ) {
      if (!mounted || _lessonRevealCount == 9) {
        timer.cancel();
        return;
      }
      setState(() => _lessonRevealCount++);
    });
  }

  void _selectPredictionOption(int group, int index) {
    setState(() {
      selected.removeWhere((item) => item ~/ 3 == group);
      selected.add(index);
    });
  }

  void _toggle(int index) {
    setState(() {
      if (widget.activityId == 'unit-01-04') {
        // This is an exploration, not a scored question: each option must be
        // tried once and the latest reply remains visible in the chat panel.
        selected.add(index);
        _activeChatQuestion = index;
      } else if (widget.activityId == 'unit-03-02') {
        // Tone exploration is deliberately not a scored choice. Keep track of
        // every tone the learner tries, while rendering only the latest one.
        selected.add(index);
        _activeStyleIndex = index;
      } else if (widget.activityId == 'unit-01-03') {
        // Word-bank choices fill blanks in tap order. Any order remains valid
        // for scoring; sequence only controls visual placement.
        if (selected.remove(index)) {
          sequence.remove(index);
        } else if (sequence.length < 3) {
          selected.add(index);
          sequence.add(index);
        }
      } else if (activity.kind == content.ActivityKind.multiSelect) {
        selected.contains(index) ? selected.remove(index) : selected.add(index);
      } else if (activity.kind == content.ActivityKind.sequence) {
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
    if (widget.activityId == 'unit-01-04') {
      if (selected.length < activity.options.length) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Try all three questions to complete this activity.'),
          ),
        );
        return;
      }
      context.go('/result/${activity.id}?correct=true');
      return;
    }
    if (widget.activityId == 'unit-03-02') {
      if (selected.length < activity.options.length) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Try Funny, Serious, and Friendly before continuing.',
            ),
          ),
        );
        return;
      }
      context.go('/result/${activity.id}?correct=true');
      return;
    }
    if (widget.activityId == 'unit-04-01') {
      // Chat Screen is the fixed, already-placed first component in the
      // design. The learner places the other four components in slots 2–5.
      const expectedParts = [0, 2, 3, 4];
      final isCorrect =
          selected.length == expectedParts.length &&
          selected.containsAll(expectedParts) &&
          sequence.length == expectedParts.length &&
          List.generate(
            expectedParts.length,
            (index) => sequence[index] == expectedParts[index],
          ).every((matches) => matches);
      context.go('/result/${activity.id}?correct=$isCorrect');
      return;
    }
    if (widget.activityId == 'unit-01-03') {
      const expectedSequence = [0, 1, 2];
      final isCorrect =
          sequence.length == expectedSequence.length &&
          List.generate(
            expectedSequence.length,
            (index) => sequence[index] == expectedSequence[index],
          ).every((matches) => matches);
      context.go('/result/${activity.id}?correct=$isCorrect');
      return;
    }
    if (widget.activityId == 'unit-04-05') {
      if (selected.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Choose a chatbot type to continue.')),
        );
        return;
      }
      // This is a choice, not a quiz. The selected type configures the next
      // scripted training-example simulation without being persisted.
      context.go(
        '/result/${activity.id}?correct=true&chatbotType=${selected.first}',
      );
      return;
    }
    if (widget.activityId == 'unit-04-06') {
      if (selected.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Choose matching training examples.')),
        );
        return;
      }
      final expectedExample = widget.chatbotTypeIndex ?? 2;
      context.go(
        '/result/${activity.id}?correct=${selected.single == expectedExample}&chatbotType=$expectedExample',
      );
      return;
    }
    if (widget.activityId == 'unit-04-07') {
      if (!_botTestPromptTried) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Try the example prompt first.')),
        );
        return;
      }
      if (selected.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Choose whether the response helped.')),
        );
        return;
      }
      context.go('/result/${activity.id}?correct=${selected.single == 0}');
      return;
    }
    if (activity.kind == content.ActivityKind.lesson) {
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
    final expectedSequence = activity.correctSequence.isEmpty
        ? List.generate(sequence.length, (index) => index)
        : activity.correctSequence;
    final orderCorrect =
        activity.kind != content.ActivityKind.sequence ||
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
            contentHeight: 1298,
            overlays: [
              _LessonMessageSequence(revealedCount: _lessonRevealCount),
            ],
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
                top: 1214,
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
              for (var index = 0; index < tiles.length; index++)
                _ArtworkLogoTile(
                  left: tiles[index].$2,
                  top: tiles[index].$3,
                  selected: selected.contains(index),
                  assetPath:
                      'assets/illustrations/unit_01_02_logos/${tiles[index].$4}.png',
                ),
              for (var index = 0; index < tiles.length; index++)
                if (selected.contains(index))
                  _ArtworkSelectionBadge(
                    left: tiles[index].$2 + 89,
                    top: tiles[index].$3 - 6,
                  ),
              for (var index = 0; index < tiles.length; index++)
                _ArtworkHitTarget(
                  label: tiles[index].$1,
                  left: tiles[index].$2 - 5,
                  top: tiles[index].$3 - 6,
                  width: 119,
                  height: 121,
                  selected: selected.contains(index),
                  onTap: () => _toggle(index),
                ),
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
      const slotTargets = [
        (52.0, 444.0, 162.0),
        (52.0, 534.0, 120.0),
        (52.0, 669.0, 120.0),
      ];
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
              for (var slot = 0; slot < slotTargets.length; slot++)
                _ArtworkWordSlot(
                  left: slotTargets[slot].$1,
                  top: slotTargets[slot].$2,
                  width: slotTargets[slot].$3,
                  label: slot < sequence.length
                      ? sequence[slot] == 2
                            ? 'Answer Questions'
                            : a.options[sequence[slot]]
                      : 'Tap word',
                  filled: slot < sequence.length,
                ),
              if (!selected.contains(0))
                const _ArtworkWordBankChip(
                  left: 20,
                  top: 923,
                  width: 180,
                  label: 'Human language',
                  placed: false,
                  fontFamily: 'Fredoka',
                  fontWeight: FontWeight.w700,
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
                  label: 'Answer Questions',
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
            overlays: [
              _ArtworkChatConversation(questionIndex: _activeChatQuestion),
              // The approved Figma export includes the first question's selected
              // styling. Cover the complete static option region before drawing the
              // live controls so a fresh activity starts with no selected question.
              const Positioned(
                left: 0,
                top: 750,
                width: 390,
                height: 178,
                child: ColoredBox(color: Color(0xFFFCF6EC)),
              ),
              for (var index = 0; index < questions.length; index++)
                _ArtworkQuestionOption(
                  top: const [758.0, 814.0, 870.0][index],
                  label: questions[index],
                  selected: selected.contains(index),
                ),
            ],
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
              for (var index = 0; index < questions.length; index++)
                _ArtworkHitTarget(
                  label: questions[index],
                  left: 16,
                  top: const [752.0, 808.0, 864.0][index],
                  width: 358,
                  height: 61,
                  selected: selected.contains(index),
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
      final words = [
        (a.options[0], 124.0, 835.0, 142.0, const Color(0xFF7DE8D2)),
        (a.options[1], 71.0, 898.0, 127.0, const Color(0xFFFFCEB8)),
        (a.options[2], 212.0, 898.0, 108.0, const Color(0xFFFFCEB8)),
        (a.options[3], 92.0, 961.0, 92.0, const Color(0xFFCDB0F5)),
        (a.options[4], 199.0, 961.0, 100.0, const Color(0xFF99CEE8)),
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
              for (var group = 0; group < 3; group++)
                _ArtworkPredictionSlot(
                  left: [241.0, 246.0, 213.0][group],
                  top: [323.0, 499.0, 662.0][group],
                  width: [89.0, 94.0, 94.0][group],
                  height: group == 0 ? 50 : 40,
                  backgroundColor: group == 0
                      ? const Color(0xFFA0D2EB)
                      : const Color(0xFFF5F4EC),
                  label: groupSelections[group] == null
                      ? null
                      : choices[groupSelections[group]!].$1,
                ),
              // The artwork's first option includes a static orange selected
              // outline. Mask it before drawing the live option so all three
              // initial choices share the same neutral button treatment.
              const Positioned(
                left: 42,
                top: 393,
                width: 78,
                height: 42,
                child: ColoredBox(color: Color(0xFFA0D2EB)),
              ),
              for (var index = 0; index < choices.length; index++)
                _ArtworkPredictionChoice(
                  left: choices[index].$2,
                  top: choices[index].$3,
                  width: choices[index].$4,
                  label: choices[index].$1,
                  selected: groupSelections[index ~/ 3] == index,
                  height: index < 3 ? 38 : 34,
                ),
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
      final selectedReply = selected.isEmpty ? null : selected.first;
      return Scaffold(
        body: SafeArea(
          child: _ActivityArtwork(
            semanticLabel: a.title,
            assetPath: 'assets/illustrations/unit_02_03.png',
            assetHeight: 1246,
            hitTargets: [
              const Positioned(
                left: 0,
                top: 700,
                width: 390,
                height: 430,
                child: ColoredBox(color: Color(0xFFFFF8EF)),
              ),
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
              _ArtworkMemoryReplyCard(
                top: 721,
                height: 150,
                reply: 'Reply A:',
                body:
                    'Mars is called the Red Planet. It has dusty red soil, tall volcanoes, and two small moons.',
                selected: selectedReply == 0,
              ),
              _ArtworkMemoryReplyCard(
                top: 888,
                height: 120,
                reply: 'Reply B:',
                body:
                    'Which planet do you mean? Please tell me the planet name first.',
                selected: selectedReply == 1,
              ),
              const Positioned(
                left: 0,
                top: 1060,
                width: 390,
                height: 186,
                child: IgnorePointer(
                  child: ColoredBox(color: Color(0xFFFFF8EF)),
                ),
              ),
              Positioned(
                left: 0,
                top: 1060,
                width: 390,
                height: 116,
                child: IgnorePointer(
                  child: ClipRect(
                    child: OverflowBox(
                      alignment: Alignment.topLeft,
                      minWidth: 390,
                      maxWidth: 390,
                      minHeight: 1246,
                      maxHeight: 1246,
                      child: Transform.translate(
                        offset: const Offset(0, -1130),
                        child: Image.asset(
                          'assets/illustrations/unit_02_03.png',
                          width: 390,
                          height: 1246,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              _ArtworkHitTarget(
                label: 'Reply A uses memory',
                left: 20,
                top: 721,
                width: 350,
                height: 150,
                selected: selectedReply == 0,
                onTap: () => _toggle(0),
              ),
              _ArtworkHitTarget(
                label: 'Reply B has no memory',
                left: 20,
                top: 888,
                width: 350,
                height: 120,
                selected: selectedReply == 1,
                onTap: () => _toggle(1),
              ),
              _ArtworkHitTarget(
                label: 'Hint',
                left: 20,
                top: 1123,
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
                top: 1123,
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
            overlays: const [_PromptTitleOverlay()],
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
              for (var index = 0; index < answerRows.length; index++)
                _ArtworkMultiSelectOption(
                  top: answerRows[index].$2,
                  label: answerRows[index].$1,
                  selected: selected.contains(index),
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
      final int? selectedStyle = _activeStyleIndex;
      return Scaffold(
        body: SafeArea(
          child: _ActivityArtwork(
            semanticLabel: a.title,
            assetPath: 'assets/illustrations/unit_03_02.png',
            assetHeight: 1195,
            overlays: const [_Step17BackButtonOverlay()],
            // The Figma export has an opaque black tail below the final action
            // row. It is outside the designed screen content, so retain the
            // artwork but restore the intended page background in that tail.
            artworkTailFillTop: 1152,
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
              if (selectedStyle != null)
                _ArtworkStyleAnswer(styleIndex: selectedStyle),
              for (var index = 0; index < styleRows.length; index++)
                _ArtworkStyleOption(
                  top: styleRows[index].$2,
                  styleIndex: index,
                  selected: selectedStyle == index,
                ),
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
        ('Be Complicated', 751.0),
        ('Be Respectful', 846.0),
      ];
      final int? selectedRole = selected.isEmpty ? null : selected.first;
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
              const Positioned(
                left: 0,
                top: 645,
                width: 390,
                height: 289,
                child: IgnorePointer(
                  child: ColoredBox(color: Color(0xFFFFF8EF)),
                ),
              ),
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
              for (var slot = 0; slot < sequence.length; slot++)
                _ArtworkSystemSlot(
                  top: slotTops[slot + 1],
                  label: parts[sequence[slot]].$1,
                  color: parts[sequence[slot]].$5,
                  partIndex: sequence[slot],
                ),
              for (var slot = 0; slot < sequence.length; slot++)
                _ArtworkHitTarget(
                  label:
                      'Remove ${parts[sequence[slot]].$1} from slot ${slot + 2}',
                  left: 44,
                  top: slotTops[slot + 1],
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
      final int? selectedLayout = selected.isEmpty ? null : selected.first;
      return Scaffold(
        body: SafeArea(
          child: _ActivityArtwork(
            semanticLabel: a.title,
            assetPath: 'assets/illustrations/unit_04_02.png',
            assetHeight: 1130,
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
              _ArtworkUiLayoutSelection(selectedIndex: selectedLayout),
              _ArtworkHitTarget(
                label: 'Streaming Layout',
                left: 20,
                top: 340,
                width: 349,
                height: 298,
                selected: selectedLayout == 0,
                onTap: () => _toggle(0),
              ),
              _ArtworkHitTarget(
                label: 'BearFetch Chat',
                left: 20,
                top: 654,
                width: 349,
                height: 299,
                selected: selectedLayout == 1,
                onTap: () => _toggle(1),
              ),
              _ArtworkHitTarget(
                label: 'Hint',
                left: 20,
                top: 1065,
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
              const Positioned(
                left: 98,
                top: 87,
                width: 194,
                height: 21,
                child: IgnorePointer(
                  child: ColoredBox(color: Color(0xFFFFF8EF)),
                ),
              ),
              const Positioned(
                left: 98,
                top: 87,
                width: 194,
                height: 21,
                child: IgnorePointer(
                  child: Center(
                    child: Text(
                      'Step 26 of 36',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF74675F),
                      ),
                    ),
                  ),
                ),
              ),
              // Mask only connector pixels; keep card borders untouched.
              const Positioned(
                left: 43,
                top: 553,
                width: 4,
                height: 16,
                child: ColoredBox(color: Color(0xFFFBF9F1)),
              ),
              const Positioned(
                left: 43,
                top: 778,
                width: 4,
                height: 13,
                child: ColoredBox(color: Color(0xFFFBF9F1)),
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
      final int? selectedAnswer = selected.isEmpty ? null : selected.first;
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
              _ArtworkYesNoSelection(
                selectYes: selectedAnswer == null ? null : selectedAnswer == 0,
              ),
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
      final int? selectedBot = selected.isEmpty ? null : selected.first;
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
            assetHeight: 1213,
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
              const Positioned(
                left: 320,
                top: 755,
                width: 35,
                height: 23,
                child: IgnorePointer(
                  child: CustomPaint(painter: _ArtworkFunBotCornerRepair()),
                ),
              ),
              const _ArtworkChatbotTypeBadge(
                cardColor: Color(0xFFA0D2EB),
                maskLeft: 236,
                maskTop: 526,
                maskWidth: 112,
                maskHeight: 34,
                left: 250,
                top: 531,
                width: 100,
                label: 'Learn & Solve',
              ),
              const _ArtworkChatbotTypeBadge(
                cardColor: Color(0xFFFFD1BA),
                maskLeft: 236,
                maskTop: 677,
                maskWidth: 112,
                maskHeight: 34,
                left: 250,
                top: 682,
                width: 100,
                label: 'Play & Explore',
              ),
              const _ArtworkChatbotTypeBadge(
                cardColor: Color(0xFFB0F2C2),
                maskLeft: 235,
                maskTop: 810,
                maskWidth: 97,
                maskHeight: 25,
                left: 255,
                top: 811,
                width: 95,
                label: 'Guide & Grow',
              ),
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
      final int? selectedExample = selected.isEmpty ? null : selected.first;
      final chatbotTypeIndex = widget.chatbotTypeIndex;
      const cardBounds = [
        (20.0, 674.0, 350.0, 218.0),
        (20.0, 912.0, 350.0, 218.0),
        (16.0, 1147.0, 358.0, 259.0),
        (20.0, 1456.0, 350.0, 218.0),
      ];
      return Scaffold(
        body: SafeArea(
          child: _ActivityArtwork(
            semanticLabel: a.title,
            assetPath: 'assets/illustrations/unit_04_06.png',
            assetHeight: 1841,
            overlays: [
              // The approved Figma frame is the Study Coach variation. Keep it
              // untouched for the initial route and for Study Coach; only the
              // other locally selected bot types replace this contextual copy.
              if (chatbotTypeIndex != null && chatbotTypeIndex != 2)
                _ArtworkChatbotTrainingSummary(botIndex: chatbotTypeIndex),
            ],
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
      final int? selectedResponse = selected.isEmpty ? null : selected.first;
      return Scaffold(
        body: SafeArea(
          child: _ActivityArtwork(
            semanticLabel: a.title,
            assetPath: 'assets/illustrations/unit_04_07.png',
            assetHeight: 1261,
            overlays: [
              _ArtworkBotTestOutput(
                ready: _botTestLoaded,
                promptTried: _botTestPromptTried,
                botIndex: widget.chatbotTypeIndex ?? 2,
              ),
              if (!_botTestLoaded) const _ArtworkBotTestLoading(),
              if (_botTestPromptTried)
                _ArtworkBotTestSelection(
                  selectYes: selectedResponse == null
                      ? null
                      : selectedResponse == 0,
                ),
            ],
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
              if (_botTestLoaded)
                _ArtworkHitTarget(
                  label: 'Try Example Prompt',
                  left: 47,
                  top: _botTestPromptTried ? 863 : 562,
                  width: 297,
                  height: 57,
                  onTap: () {
                    setState(() => _botTestPromptTried = true);
                  },
                ),
              if (_botTestPromptTried) ...[
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
              ],
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
                  if (a.kind == content.ActivityKind.sequence &&
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
                          number: a.kind == content.ActivityKind.sequence
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
                label: a.kind == content.ActivityKind.lesson
                    ? 'Start'
                    : 'Check',
                icon: a.kind == content.ActivityKind.lesson
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
    this.overlays = const [],
    this.contentHeight,
    this.artworkTailFillTop,
  });

  static const _designWidth = 390.0;

  final String semanticLabel;
  final String assetPath;
  final double assetHeight;
  final double? contentHeight;
  final double? artworkTailFillTop;
  final List<Widget> hitTargets;
  final List<Widget> overlays;

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
                      if (artworkTailFillTop != null)
                        Positioned(
                          left: 0,
                          top: artworkTailFillTop!,
                          width: _designWidth,
                          height: assetHeight - artworkTailFillTop!,
                          child: const ColoredBox(color: Color(0xFFFFF8EF)),
                        ),
                      _ArtworkCourseTitle(assetPath: assetPath),
                      ...overlays,
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

/// The Step 17 exported artwork clips its back-control circle at y=0.
/// Mask only that broken fragment and draw a complete control in its place.
class _Step17BackButtonOverlay extends StatelessWidget {
  const _Step17BackButtonOverlay();

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      const Positioned(
        left: 12,
        top: 0,
        width: 56,
        height: 42,
        child: ColoredBox(color: Color(0xFFFFF8EF)),
      ),
      Positioned(
        left: 20,
        // Match other activity headers: circle ends at y=40, leaving 6px
        // before the fixed progress bar at y=46.
        top: 0,
        width: 40,
        height: 40,
        child: IgnorePointer(
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: Color(0xFFE9E9E4),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_rounded,
              size: 26,
              color: Color(0xFF293033),
            ),
          ),
        ),
      ),
    ],
  );
}

class _ArtworkCourseTitle extends StatelessWidget {
  const _ArtworkCourseTitle({required this.assetPath});

  final String assetPath;

  int get _unit {
    final match = RegExp(r'unit_(\d{2})').firstMatch(assetPath);
    return match == null ? 1 : int.parse(match.group(1)!);
  }

  double get _progressTop => switch (assetPath.split('/').last) {
    'unit_01_04.png' || 'unit_02_01.png' => 53,
    'unit_02_03.png' => 62,
    'unit_03_02.png' => 47,
    'unit_03_01.png' ||
    'unit_03_03.png' ||
    'unit_04_01.png' ||
    'unit_04_03.png' => 72,
    'unit_04_02.png' => 71,
    _ => 73,
  };

  @override
  Widget build(BuildContext context) {
    // Step 17 artwork has a shorter header. Its title began at y=0 and its
    // bold glyphs clipped against the top edge. Reserve a 4px top inset only
    // for that header; unit copy still ends inside its 45px title region.
    final titleTop = assetPath.endsWith('unit_03_02.png')
        ? 4.0
        : (_progressTop - 48).clamp(0.0, 25.0);
    final unitTop = titleTop + 26;
    return Positioned(
      left: 82,
      top: 0,
      width: 226,
      height: _progressTop - 2,
      child: Stack(
        children: [
          const Positioned.fill(child: ColoredBox(color: Color(0xFFFFF8EF))),
          Positioned(
            top: titleTop,
            width: 226,
            height: 16,
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'From Understanding to Building LLMs',
                  style: const TextStyle(
                    fontFamily: 'BeVietnamPro',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF293033),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: unitTop,
            width: 226,
            height: 14,
            child: Center(
              child: Text(
                'Unit $_unit of 5',
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF293033),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PromptTitleOverlay extends StatelessWidget {
  const _PromptTitleOverlay();

  @override
  Widget build(BuildContext context) => const Positioned(
    left: 19,
    top: 180,
    width: 350,
    height: 32,
    child: ColoredBox(
      color: Color(0xFFFFF8EF),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Talk to AI Properly',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: Color(0xFF293033),
          ),
        ),
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
    // The approved Figma export includes initial check badges. The surrounding
    // page-colour layer masks those static badges before drawing live state.
    left: left - 10,
    top: top - 12,
    width: 129,
    height: 130,
    child: IgnorePointer(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Positioned.fill(child: ColoredBox(color: Color(0xFFFCF6EC))),
          Positioned(
            left: 10,
            top: 12,
            width: 109,
            height: 109,
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
            left: 18,
            top: 32,
            width: 93,
            height: 79,
            child: Image.asset(
              assetPath,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
              excludeFromSemantics: true,
            ),
          ),
        ],
      ),
    ),
  );
}

class _ArtworkSelectionBadge extends StatelessWidget {
  const _ArtworkSelectionBadge({required this.left, required this.top});

  final double left;
  final double top;

  @override
  Widget build(BuildContext context) => Positioned(
    left: left,
    top: top,
    child: const IgnorePointer(child: _ArtworkCheckmark()),
  );
}

class _LessonMessageSequence extends StatelessWidget {
  const _LessonMessageSequence({required this.revealedCount});

  final int revealedCount;

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Positioned(
        left: 0,
        top: 240,
        width: 390,
        height: 960,
        child: ColoredBox(color: Color(0xFFFFF8EF)),
      ),
      _LessonBubble(
        top: 244,
        width: 202,
        height: 66,
        text: 'Hi! I’m BearFetch AI 👋',
        visible: revealedCount > 0,
      ),
      _LessonBubble(
        top: 322,
        height: 89,
        text: 'Today we’ll learn about AI\nchatbots.',
        visible: revealedCount > 1,
      ),
      _LessonBubble(
        top: 423,
        height: 87,
        color: const Color(0xFFB4E6C9),
        text:
            'A chatbot is an AI tool that uses\nlanguage to engage with its user',
        visible: revealedCount > 2,
      ),
      _LessonBubble(
        top: 522,
        height: 113,
        text:
            'Chatbots can answer questions,\nsuggest ideas, and help you\ninside apps or websites.',
        visible: revealedCount > 3,
      ),
      _LessonExamplesBubble(visible: revealedCount > 4),
      _LessonBubble(
        top: 834,
        height: 62,
        text: 'Every app doesn’t always need a\nchatbot.',
        visible: revealedCount > 5,
      ),
      _LessonBubble(
        top: 908,
        height: 87,
        text:
            'Chatbots normally engage users\nwith words, hence the name\nchatbot!',
        visible: revealedCount > 6,
      ),
      _LessonBubble(
        top: 1007,
        height: 111,
        color: const Color(0xFFA0D2EB),
        text:
            'In the next activity, you’ll sort\nexamples into “Chatbot” and\n“Not Chatbot.”',
        visible: revealedCount > 7,
      ),
      _LessonBubble(
        top: 1130,
        width: 164,
        height: 64,
        text: 'Ready to begin?',
        visible: revealedCount > 8,
      ),
      Positioned(
        left: 14,
        top: 1214,
        width: 362,
        height: 72,
        child: IgnorePointer(
          child: BearfetchPrimaryButton(
            label: 'Start',
            icon: Icons.play_arrow_rounded,
            onPressed: () {},
          ),
        ),
      ),
    ],
  );
}

class _LessonBubble extends StatelessWidget {
  const _LessonBubble({
    required this.top,
    required this.height,
    required this.text,
    required this.visible,
    this.width = 300,
    this.color = Colors.white,
  });

  final double top;
  final double width;
  final double height;
  final Color color;
  final String text;
  final bool visible;

  static const _textStyle = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 15,
    height: 1.25,
    fontWeight: FontWeight.w700,
    color: Color(0xFF5A4840),
  );

  @override
  Widget build(BuildContext context) => Positioned(
    left: 20,
    top: top,
    width: width,
    height: height,
    child: IgnorePointer(
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: const Color(0xFF6B5149), width: 2),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Color(0xFF6B5149),
                offset: Offset(0, 3),
                blurRadius: 0,
              ),
            ],
          ),
          child: Text(text, style: _textStyle),
        ),
      ),
    ),
  );
}

class _LessonExamplesBubble extends StatelessWidget {
  const _LessonExamplesBubble({required this.visible});

  final bool visible;

  @override
  Widget build(BuildContext context) => Positioned(
    left: 20,
    top: 647,
    width: 300,
    height: 175,
    child: IgnorePointer(
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 9),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFF6B5149), width: 2),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Color(0xFF6B5149),
                offset: Offset(0, 3),
                blurRadius: 0,
              ),
            ],
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You may have seen chatbots in\nplaces like:',
                style: _LessonBubble._textStyle,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  _LessonExampleChip(label: 'Games', color: Color(0xFFFFCEB8)),
                  SizedBox(width: 8),
                  _LessonExampleChip(
                    label: 'Shopping',
                    color: Color(0xFFC5A9F6),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  _LessonExampleChip(label: 'Search', color: Color(0xFF86F6DA)),
                  SizedBox(width: 8),
                  _LessonExampleChip(
                    label: 'Support',
                    color: Color(0xFFFFA247),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _LessonExampleChip extends StatelessWidget {
  const _LessonExampleChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    height: 28,
    padding: const EdgeInsets.symmetric(horizontal: 12),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: color,
      border: Border.all(color: const Color(0xFF6B5149), width: 2),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Text(label, style: _LessonBubble._textStyle.copyWith(fontSize: 13)),
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
              child: FittedBox(
                fit: BoxFit.scaleDown,
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
                      fontFamily: 'Fredoka',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
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
    this.fontFamily = 'Nunito',
    this.fontWeight = FontWeight.w800,
  });

  final double left;
  final double top;
  final double width;
  final String label;
  final bool placed;
  final String fontFamily;
  final FontWeight fontWeight;

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
            fontFamily: fontFamily,
            fontSize: 14,
            fontWeight: fontWeight,
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

  final int? questionIndex;

  @override
  Widget build(BuildContext context) {
    const questions = [
      'What is an AI chatbot?',
      'Where do chatbots appear?',
      'What can a chatbot do?',
    ];
    const answers = [
      'An AI chatbot is a smart helper that can reply to your questions using words.',
      'Chatbots can appear in apps, websites, games, search, shopping, and support.',
      'A chatbot can answer questions, explain ideas, and help people complete tasks.',
    ];

    return Positioned(
      left: 20,
      top: 275,
      width: 350,
      height: 434,
      child: IgnorePointer(
        child: Stack(
          children: [
            const Positioned.fill(child: ColoredBox(color: Color(0xFFFCF6EC))),
            Positioned(
              left: 1,
              top: 1,
              width: 348,
              height: 428,
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF293033), width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: ColoredBox(
                    color: Colors.transparent,
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
                        if (questionIndex case final selectedQuestion?) ...[
                          Positioned(
                            right: 28,
                            top: 141,
                            width: 252,
                            child: _ArtworkChatBubble(
                              text: questions[selectedQuestion],
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
                              text: answers[selectedQuestion],
                              color: const Color(0xFFA9EDBE),
                            ),
                          ),
                          const Positioned(
                            left: 16,
                            top: 260,
                            child: _ArtworkChatAvatar(bot: true),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
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

class _ArtworkPredictionSlot extends StatelessWidget {
  const _ArtworkPredictionSlot({
    required this.left,
    required this.top,
    required this.width,
    required this.label,
    required this.backgroundColor,
    this.height = 50,
  });

  final double left;
  final double top;
  final double width;
  final String? label;
  final Color backgroundColor;
  final double height;

  @override
  Widget build(BuildContext context) => Positioned(
    left: left,
    top: top,
    width: width,
    height: height,
    child: IgnorePointer(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: -2,
            top: -2,
            width: width + 4,
            height: height + 8,
            child: ColoredBox(color: backgroundColor),
          ),
          Positioned.fill(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: label == null
                    ? const Color(0xFFFFFDF8)
                    : const Color(0xFFFFCEB8),
                border: Border.all(color: const Color(0xFFFF9F43), width: 2),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Color(0xFFFF9F43), offset: Offset(0, 4)),
                ],
              ),
              child: label == null
                  ? null
                  : Text(
                      label!,
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
        ],
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
    required this.selected,
  });

  final double top;
  final double height;
  final String reply;
  final String body;
  final bool selected;

  @override
  Widget build(BuildContext context) => Positioned(
    left: 20,
    top: top,
    width: 350,
    height: height,
    child: LayoutBuilder(
      builder: (context, constraints) {
        const padding = EdgeInsets.fromLTRB(25, 20, 46, 16);
        const bodyFontSize = 16.0;
        const bodyHeight = 1.45;

        return IgnorePointer(
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: selected
                  ? const Color(0xFFFFD6BF)
                  : const Color(0xFFFBF9F1),
              border: Border.all(
                color: selected
                    ? const Color(0xFF9B5700)
                    : const Color(0xFF4B3333),
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
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '$reply ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              TextSpan(text: body),
                            ],
                          ),
                          style:
                              const TextStyle(
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF171713),
                              ).copyWith(
                                fontSize: bodyFontSize,
                                height: bodyHeight,
                              ),
                        ),
                      ],
                    ),
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
        );
      },
    ),
  );
}

class _ArtworkBotTestOutput extends StatelessWidget {
  const _ArtworkBotTestOutput({
    required this.ready,
    required this.promptTried,
    required this.botIndex,
  });

  final bool ready;
  final bool promptTried;
  final int botIndex;

  @override
  Widget build(BuildContext context) {
    if (!ready) {
      return const Positioned(
        left: 0,
        top: 461,
        width: 390,
        height: 659,
        child: IgnorePointer(child: ColoredBox(color: Color(0xFFFFF8EF))),
      );
    }
    if (promptTried) {
      return _ArtworkBotTestExampleOverlay(botIndex: botIndex);
    }

    // The exported artwork is the expanded, post-prompt state. Cover it with
    // the compact Figma default state until the learner taps the prompt.
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            const Positioned(
              left: 0,
              top: 461,
              width: 390,
              height: 659,
              child: ColoredBox(color: Color(0xFFFFF8EF)),
            ),
            Positioned(
              left: 20,
              top: 461,
              width: 350,
              height: 184,
              child: Container(
                padding: const EdgeInsets.fromLTRB(26, 25, 26, 24),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F2EA),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF293033), width: 2),
                  boxShadow: const [
                    BoxShadow(color: Color(0x1A293033), offset: Offset(0, 7)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.psychology_alt_outlined,
                          color: Color(0xFF9B5700),
                          size: 24,
                        ),
                        SizedBox(width: 9),
                        Text(
                          'Bot Output',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 21,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF9B5700),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 17),
                    const Divider(height: 2, color: Color(0xFFE0DDD4)),
                    const Spacer(),
                    Container(
                      height: 57,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: const Color(0xFF293033),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(29),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xFF293033),
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.play_arrow_rounded, size: 30),
                              SizedBox(width: 7),
                              Text(
                                'Try Example Prompt',
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF293033),
                                ),
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
          ],
        ),
      ),
    );
  }
}

class _ArtworkBotTestExampleOverlay extends StatelessWidget {
  const _ArtworkBotTestExampleOverlay({required this.botIndex});

  final int botIndex;

  static const _examples = [
    (
      prompt: 'What is 7 × 8?',
      response: '7 × 8 = 56. You can think of it as 7 groups of 8.',
    ),
    (
      prompt: 'Tell me a fun fact about space.',
      response:
          'A day on Venus is longer than a year on Venus. That is a very slow spin!',
    ),
    (
      prompt: 'How can I study for a science test?',
      response:
          'Start with the topics you find hardest. Review one topic at a time, make short notes, and take a quick break after 20 minutes.',
    ),
    (
      prompt: 'What can you help me with?',
      response:
          'I can answer questions, explain ideas, and help you find a useful next step.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final index = botIndex >= 0 && botIndex < _examples.length ? botIndex : 2;
    final example = _examples[index];
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            Positioned(
              left: 46,
              top: 571,
              width: 298,
              height: 75,
              child: Container(
                padding: const EdgeInsets.fromLTRB(13, 11, 13, 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: const Color(0xFFDAB2A1),
                    width: 1.2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  example.prompt,
                  maxLines: 2,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 16,
                    height: 1.35,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF293033),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 42,
              top: 694,
              width: 306,
              height: 139,
              child: const ColoredBox(color: Color(0xFFF4F2EA)),
            ),
            Positioned(
              left: 46,
              top: 698,
              width: 298,
              height: 131,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD1BA),
                  border: Border.all(color: const Color(0xFF293033), width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  example.response,
                  maxLines: 4,
                  overflow: TextOverflow.clip,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 16,
                    height: 1.35,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF293033),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArtworkBotTestLoading extends StatelessWidget {
  const _ArtworkBotTestLoading();

  @override
  Widget build(BuildContext context) => Positioned(
    left: 89,
    top: 375,
    width: 262,
    height: 30,
    child: IgnorePointer(
      child: ColoredBox(
        color: const Color(0xFFA0D2EB),
        child: Stack(
          children: [
            const Positioned(
              left: 1,
              top: 1,
              child: Text(
                'In-Progress',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF293033),
                ),
              ),
            ),
            const Positioned(
              right: 9,
              top: 4,
              width: 22,
              height: 22,
              child: RepaintBoundary(
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Color(0xFF00796B),
                ),
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

  final bool? selectYes;

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
                child: FittedBox(
                  fit: BoxFit.scaleDown,
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
          selected: selectYes == true,
        ),
        option(
          left: 213,
          width: 156,
          label: 'Not yet',
          selected: selectYes == false,
        ),
      ],
    );
  }
}

class _ArtworkChatbotTrainingSummary extends StatelessWidget {
  const _ArtworkChatbotTrainingSummary({required this.botIndex});

  final int botIndex;

  static const _names = ['Math Bot', 'Fun Bot', 'Study Coach', 'Helper Bot'];
  static const _descriptions = [
    'This bot helps with\nmath questions and\nclear solutions.',
    'This bot shares jokes,\nfun facts, and\nplayful answers.',
    'This bot helps with\nstudy tips and\nreminders.',
    'This bot answers\ngeneral questions and\ngives support.',
  ];
  static const _icons = [
    Icons.calculate_rounded,
    Icons.star_rounded,
    Icons.emoji_events_rounded,
    Icons.support_agent_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final index = botIndex.clamp(0, _names.length - 1).toInt();
    return Positioned(
      left: 20,
      top: 452,
      width: 348,
      height: 186,
      child: IgnorePointer(
        child: Container(
          padding: const EdgeInsets.fromLTRB(25, 25, 20, 20),
          decoration: BoxDecoration(
            color: const Color(0xFFB0F2C2),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: const Color(0xFF4B3333), width: 3),
            boxShadow: const [
              BoxShadow(color: Color(0xFF4B3333), offset: Offset(0, 7)),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF4B3333), width: 2),
                ),
                child: Icon(
                  _icons[index],
                  size: 32,
                  color: const Color(0xFF00796B),
                ),
              ),
              const SizedBox(width: 17),
              Expanded(
                child: FittedBox(
                  alignment: Alignment.topLeft,
                  fit: BoxFit.scaleDown,
                  child: SizedBox(
                    width: 216,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your chatbot: ${_names[index]}',
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 20,
                            height: 1.2,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF00796B),
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          _descriptions[index],
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 16,
                            height: 1.3,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF00796B),
                          ),
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
    );
  }
}

class _ArtworkTrainingSelection extends StatelessWidget {
  const _ArtworkTrainingSelection({required this.selectedIndex});

  final int? selectedIndex;

  static const _cardBounds = [
    (20.0, 674.0, 350.0, 218.0),
    (20.0, 912.0, 350.0, 218.0),
    (16.0, 1147.0, 358.0, 259.0),
    (20.0, 1456.0, 350.0, 218.0),
  ];

  @override
  Widget build(BuildContext context) {
    if (selectedIndex == null) return const SizedBox.shrink();

    final selectedBounds = _cardBounds[selectedIndex!];
    return Stack(
      children: [
        Positioned(
          left: selectedBounds.$1,
          top: selectedBounds.$2,
          width: selectedBounds.$3,
          height: selectedBounds.$4,
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
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

class _ArtworkFunBotCornerRepair extends CustomPainter {
  const _ArtworkFunBotCornerRepair();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-300, -90, 335, 113),
        const Radius.circular(20),
      ),
      Paint()..color = const Color(0xFFFFD1BA),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ArtworkChatbotTypeBadge extends StatelessWidget {
  const _ArtworkChatbotTypeBadge({
    required this.cardColor,
    required this.maskLeft,
    required this.maskTop,
    required this.maskWidth,
    required this.maskHeight,
    required this.left,
    required this.top,
    required this.width,
    required this.label,
  });

  final Color cardColor;
  final double maskLeft;
  final double maskTop;
  final double maskWidth;
  final double maskHeight;
  final double left;
  final double top;
  final double width;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: maskLeft,
          top: maskTop,
          width: maskWidth,
          height: maskHeight,
          child: IgnorePointer(child: ColoredBox(color: cardColor)),
        ),
        Positioned(
          left: left,
          top: top,
          width: width,
          height: 27,
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFFFFFDF8),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF675C54),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ArtworkChatbotTypeCards extends StatelessWidget {
  const _ArtworkChatbotTypeCards({required this.selectedIndex});

  final int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    const cardTops = [514.0, 665.0, 792.0, 942.0];
    if (selectedIndex == null) return const SizedBox.shrink();
    return Positioned(
      right: 14,
      top: cardTops[selectedIndex!] - 9,
      width: 35,
      height: 35,
      child: IgnorePointer(
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFFA247),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF4B3333), width: 2),
          ),
          child: const Icon(Icons.check_rounded, size: 24, color: Colors.white),
        ),
      ),
    );
  }
}

class _ArtworkYesNoSelection extends StatelessWidget {
  const _ArtworkYesNoSelection({required this.selectYes});

  final bool? selectYes;

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
          option(left: 20, label: 'Yes', selected: selectYes == true),
          option(left: 203, label: 'No', selected: selectYes == false),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (selected) ...[
              const Icon(
                Icons.check_circle_rounded,
                size: 16,
                color: Color(0xFF2F5C49),
              ),
              const SizedBox(width: 4),
            ],
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF4B3B32),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _ArtworkUiLayoutSelection extends StatelessWidget {
  const _ArtworkUiLayoutSelection({required this.selectedIndex});

  final int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    if (selectedIndex == null) return const SizedBox.shrink();

    final isStreaming = selectedIndex == 0;
    final cardTop = isStreaming ? 340.0 : 654.0;
    final cardHeight = isStreaming ? 298.0 : 299.0;
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            Positioned(
              left: 20,
              top: cardTop,
              width: 349,
              height: cardHeight,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFFF9F43), width: 4),
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            Positioned(
              right: 7,
              top: cardTop - 13,
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
          ],
        ),
      ),
    );
  }
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
              Expanded(
                child: Text(
                  labels[roleIndex],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                    color: selected
                        ? const Color(0xFF9B5700)
                        : const Color(0xFF171815),
                  ),
                ),
              ),
              const SizedBox(width: 12),
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
    const styleNames = ['Funny style', 'Serious style', 'Friendly style'];
    const answers = [
      '“A black hole is like a cosmic vacuum cleaner with a huge appetite. If something gets too close, even light cannot escape its pull.”',
      '“A black hole is a region of space where gravity is so strong that nothing, including light, can escape.”',
      '“A black hole is a super-strong space neighbor that pulls everything close—even light—but it stays very far away from us.”',
    ];
    final styleName = styleNames[styleIndex];
    final answer = answers[styleIndex];
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
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'AI ANSWER',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF293033),
                      ),
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 92),
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
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
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
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                answer,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 18,
                  height: 1.35,
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
  final content.ActivityDefinition activity;
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
                  const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'From Understanding to Building LLMs',
                      style: TextStyle(
                        fontFamily: 'Fredoka',
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                      ),
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
