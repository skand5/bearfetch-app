import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/state/prototype_state.dart';
import '../../../core/theme/bearfetch_theme.dart';

class LearnerProfileScreen extends ConsumerStatefulWidget {
  const LearnerProfileScreen({super.key});
  @override
  ConsumerState<LearnerProfileScreen> createState() =>
      _LearnerProfileScreenState();
}

class _LearnerProfileScreenState extends ConsumerState<LearnerProfileScreen> {
  static const _designSize = Size(390, 973);

  final _nickname = TextEditingController();
  String? _age;
  String _language = 'English';

  bool get _canContinue => _nickname.text.trim().length >= 2 && _age != null;

  @override
  void initState() {
    super.initState();
    _nickname.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    _nickname.removeListener(_refresh);
    _nickname.dispose();
    super.dispose();
  }

  void _continue() {
    if (_nickname.text.trim().length < 2) {
      _showMessage('Enter a nickname.');
      return;
    }
    if (_age == null) {
      _showMessage('Choose an age range.');
      return;
    }
    ref
        .read(prototypeStateProvider)
        .saveLearner(
          nickname: _nickname.text.trim(),
          age: _age!,
          preferredLanguage: _language,
        );
    context.go('/signup/approval');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _chooseAvatar() async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              title: Text('Choose avatar'),
              subtitle: Text('Astronaut Bear is selected'),
            ),
            ListTile(
              leading: const CircleAvatar(child: Text('🐻')),
              title: const Text('Astronaut Bear'),
              trailing: const Icon(Icons.check_circle_rounded),
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _chooseLanguage() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(title: Text('Preferred language')),
            for (final language in const ['English', 'Hindi', 'Tamil'])
              ListTile(
                title: Text(language),
                trailing: language == _language
                    ? const Icon(Icons.check_circle_rounded)
                    : null,
                onTap: () => Navigator.of(context).pop(language),
              ),
          ],
        ),
      ),
    );
    if (selected != null) setState(() => _language = selected);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    resizeToAvoidBottomInset: false,
    backgroundColor: const Color(0xFFFFF8EF),
    body: LayoutBuilder(
      builder: (context, constraints) {
        final scale = constraints.maxWidth / _designSize.width;
        return SingleChildScrollView(
          child: SizedBox(
            width: constraints.maxWidth,
            height: _designSize.height * scale,
            child: FittedBox(
              fit: BoxFit.fill,
              child: SizedBox.fromSize(
                size: _designSize,
                child: _LearnerProfileArtboard(
                  nicknameController: _nickname,
                  age: _age,
                  language: _language,
                  canContinue: _canContinue,
                  onBack: () => context.pop(),
                  onChooseAvatar: _chooseAvatar,
                  onAgeChanged: (value) => setState(() => _age = value),
                  onChooseLanguage: _chooseLanguage,
                  onContinue: _continue,
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}

class _LearnerProfileArtboard extends StatelessWidget {
  const _LearnerProfileArtboard({
    required this.nicknameController,
    required this.age,
    required this.language,
    required this.canContinue,
    required this.onBack,
    required this.onChooseAvatar,
    required this.onAgeChanged,
    required this.onChooseLanguage,
    required this.onContinue,
  });

  final TextEditingController nicknameController;
  final String? age;
  final String language;
  final bool canContinue;
  final VoidCallback onBack;
  final VoidCallback onChooseAvatar;
  final ValueChanged<String> onAgeChanged;
  final VoidCallback onChooseLanguage;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      const Image(
        image: AssetImage('assets/illustrations/onboarding_03.png'),
        fit: BoxFit.fill,
        filterQuality: FilterQuality.high,
      ),
      const Positioned.fill(child: IgnorePointer(child: SizedBox.shrink())),
      Positioned(
        left: 19,
        top: 46,
        width: 48,
        height: 48,
        child: _LearnerHitTarget(label: 'Go back', onTap: onBack),
      ),
      Positioned(
        left: 119,
        top: 286,
        width: 150,
        height: 48,
        child: _LearnerHitTarget(
          label: 'Choose avatar. Astronaut Bear selected',
          onTap: onChooseAvatar,
        ),
      ),
      Positioned(
        left: 42,
        top: 408,
        width: 306,
        height: 55,
        child: Stack(
          children: [
            if (nicknameController.text.isNotEmpty)
              const Positioned(
                left: 43,
                top: 6,
                right: 10,
                bottom: 6,
                child: ColoredBox(color: Color(0xFFF5EBD8)),
              ),
            Semantics(
              label: "Child's nickname",
              textField: true,
              child: TextField(
                controller: nicknameController,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.nickname],
                cursorColor: BearfetchColors.orange,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 15,
                  color: BearfetchColors.bodyBrown,
                ),
                decoration: const InputDecoration(
                  isDense: true,
                  filled: false,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(46, 17, 10, 14),
                ),
              ),
            ),
          ],
        ),
      ),
      _AgeTarget(
        left: 42,
        emoji: '🐣',
        value: '3–5 yr',
        selected: age == '3–5 yr',
        onTap: onAgeChanged,
      ),
      _AgeTarget(
        left: 147,
        emoji: '🚀',
        value: '6–11 yr',
        selected: age == '6–11 yr',
        onTap: onAgeChanged,
      ),
      _AgeTarget(
        left: 253,
        emoji: '⭐',
        value: '12+ yr',
        selected: age == '12+ yr',
        onTap: onAgeChanged,
      ),
      if (language != 'English')
        Positioned(
          left: 84,
          top: 646,
          width: 205,
          height: 38,
          child: ColoredBox(
            color: const Color(0xFFF5EBD8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                language,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 15,
                  color: BearfetchColors.cocoa,
                ),
              ),
            ),
          ),
        ),
      Positioned(
        left: 42,
        top: 638,
        width: 306,
        height: 55,
        child: _LearnerHitTarget(
          label: 'Preferred language. $language selected',
          onTap: onChooseLanguage,
        ),
      ),
      if (canContinue)
        Positioned(
          left: 22,
          top: 850,
          width: 346,
          height: 62,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: BearfetchColors.orange,
              borderRadius: BorderRadius.circular(32),
              boxShadow: const [
                BoxShadow(
                  color: BearfetchColors.orangeDark,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: const Text(
              'Continue',
              style: TextStyle(
                fontFamily: 'Fredoka',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      Positioned(
        left: 19,
        top: 844,
        width: 352,
        height: 74,
        child: _LearnerHitTarget(label: 'Continue', onTap: onContinue),
      ),
    ],
  );
}

class _AgeTarget extends StatelessWidget {
  const _AgeTarget({
    required this.left,
    required this.emoji,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  final double left;
  final String emoji;
  final String value;
  final bool selected;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) => Positioned(
    left: left,
    top: 535,
    width: 95,
    height: 57,
    child: Stack(
      fit: StackFit.expand,
      children: [
        if (selected)
          Container(
            decoration: BoxDecoration(
              color: const Color(0x33E8762B),
              border: Border.all(color: BearfetchColors.orange, width: 2),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        Positioned(
          top: 8,
          left: 0,
          right: 0,
          child: ExcludeSemantics(
            child: Text(
              emoji,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, height: 1),
            ),
          ),
        ),
        _LearnerHitTarget(label: 'Age range $value', onTap: () => onTap(value)),
      ],
    ),
  );
}

class _LearnerHitTarget extends StatelessWidget {
  const _LearnerHitTarget({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    label: label,
    button: true,
    child: Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
    ),
  );
}

class ParentApprovalScreen extends ConsumerStatefulWidget {
  const ParentApprovalScreen({super.key});
  @override
  ConsumerState<ParentApprovalScreen> createState() =>
      _ParentApprovalScreenState();
}

class _ParentApprovalScreenState extends ConsumerState<ParentApprovalScreen> {
  static const _designSize = Size(390, 1038);
  final Set<int> _confirmed = {};

  void _toggle(int index) => setState(() {
    _confirmed.contains(index)
        ? _confirmed.remove(index)
        : _confirmed.add(index);
  });

  void _approve() {
    if (_confirmed.length != 3) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Confirm all three items to continue.')),
        );
      return;
    }
    ref.read(prototypeStateProvider).approveParent();
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    resizeToAvoidBottomInset: false,
    backgroundColor: const Color(0xFFFFF8EF),
    body: LayoutBuilder(
      builder: (context, constraints) {
        final scale = constraints.maxWidth / _designSize.width;
        return SingleChildScrollView(
          child: SizedBox(
            width: constraints.maxWidth,
            height: _designSize.height * scale,
            child: FittedBox(
              fit: BoxFit.fill,
              child: SizedBox.fromSize(
                size: _designSize,
                child: _ParentApprovalArtboard(
                  confirmed: _confirmed,
                  onBack: () => context.pop(),
                  onToggle: _toggle,
                  onApprove: _approve,
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}

class _ParentApprovalArtboard extends StatelessWidget {
  const _ParentApprovalArtboard({
    required this.confirmed,
    required this.onBack,
    required this.onToggle,
    required this.onApprove,
  });

  final Set<int> confirmed;
  final VoidCallback onBack;
  final ValueChanged<int> onToggle;
  final VoidCallback onApprove;

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      const Image(
        image: AssetImage('assets/illustrations/onboarding_04.png'),
        fit: BoxFit.fill,
        filterQuality: FilterQuality.high,
      ),
      Positioned(
        left: 19,
        top: 46,
        width: 48,
        height: 48,
        child: _LearnerHitTarget(label: 'Go back', onTap: onBack),
      ),
      _ApprovalCheckbox(
        index: 0,
        top: 528,
        label: 'I am the parent or guardian',
        selected: confirmed.contains(0),
        onToggle: onToggle,
      ),
      _ApprovalCheckbox(
        index: 1,
        top: 623,
        label: 'I approve creating a learner profile',
        selected: confirmed.contains(1),
        onToggle: onToggle,
      ),
      _ApprovalCheckbox(
        index: 2,
        top: 719,
        label: 'I can manage this later',
        selected: confirmed.contains(2),
        onToggle: onToggle,
      ),
      if (confirmed.length == 3)
        Positioned(
          left: 22,
          top: 927,
          width: 346,
          height: 61,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: BearfetchColors.orange,
              borderRadius: BorderRadius.circular(32),
              boxShadow: const [
                BoxShadow(
                  color: BearfetchColors.orangeDark,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: const ExcludeSemantics(
              child: Text(
                'Approve and Continue',
                style: TextStyle(
                  fontFamily: 'Fredoka',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      Positioned(
        left: 19,
        top: 921,
        width: 352,
        height: 74,
        child: _LearnerHitTarget(
          label: 'Approve and Continue',
          onTap: onApprove,
        ),
      ),
    ],
  );
}

class _ApprovalCheckbox extends StatelessWidget {
  const _ApprovalCheckbox({
    required this.index,
    required this.top,
    required this.label,
    required this.selected,
    required this.onToggle,
  });

  final int index;
  final double top;
  final String label;
  final bool selected;
  final ValueChanged<int> onToggle;

  @override
  Widget build(BuildContext context) => Positioned(
    left: 47,
    top: top,
    width: 306,
    height: 78,
    child: Stack(
      children: [
        if (selected)
          Positioned(
            left: 8,
            top: 12,
            width: 26,
            height: 26,
            child: Container(
              decoration: BoxDecoration(
                color: BearfetchColors.orange,
                borderRadius: BorderRadius.circular(7),
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 19,
                color: Colors.white,
              ),
            ),
          ),
        Positioned.fill(
          child: Semantics(
            label: label,
            checked: selected,
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: () => onToggle(index),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
