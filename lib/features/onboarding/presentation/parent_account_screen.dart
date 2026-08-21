import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/state/app_state.dart';
import '../../../core/theme/bearfetch_theme.dart';

class ParentAccountScreen extends ConsumerStatefulWidget {
  const ParentAccountScreen({super.key});

  @override
  ConsumerState<ParentAccountScreen> createState() =>
      _ParentAccountScreenState();
}

class _ParentAccountScreenState extends ConsumerState<ParentAccountScreen> {
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();

  static const _designSize = Size(390, 844);

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_refresh);
    _contactController.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    _nameController.removeListener(_refresh);
    _contactController.removeListener(_refresh);
    _nameController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    final name = _nameController.text.trim();
    final contact = _contactController.text.trim();
    final isEmail = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(contact);
    final isPhone = RegExp(r'^\+?[0-9][0-9\s-]{7,14}$').hasMatch(contact);

    if (name.length < 2) {
      _showValidationMessage('Enter your name.');
      return;
    }
    if (!isEmail && !isPhone) {
      _showValidationMessage('Enter a valid email or mobile number.');
      return;
    }
    await ref.read(appStateControllerProvider.notifier).setParentName(name);
    if (mounted) context.go('/signup/verify');
  }

  void _showValidationMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFFFF8EF),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final scale = (constraints.maxWidth / _designSize.width).clamp(
            0.0,
            constraints.maxHeight / _designSize.height,
          );
          final canvasWidth = _designSize.width * scale;
          final canvasHeight = _designSize.height * scale;

          return Stack(
            children: [
              const Positioned.fill(
                child: ColoredBox(color: Color(0xFFFFF8EF)),
              ),
              Positioned(
                top: 0,
                left: (constraints.maxWidth - canvasWidth) / 2,
                width: canvasWidth,
                height: canvasHeight,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: SizedBox.fromSize(
                    size: _designSize,
                    child: _ParentAccountArtboard(
                      nameController: _nameController,
                      contactController: _contactController,
                      onBack: () => context.pop(),
                      onSendOtp: _sendOtp,
                      onSignIn: () => context.go('/home-started'),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ParentAccountArtboard extends StatelessWidget {
  const _ParentAccountArtboard({
    required this.nameController,
    required this.contactController,
    required this.onBack,
    required this.onSendOtp,
    required this.onSignIn,
  });

  final TextEditingController nameController;
  final TextEditingController contactController;
  final VoidCallback onBack;
  final VoidCallback onSendOtp;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      const Image(
        image: AssetImage('assets/illustrations/onboarding_02.png'),
        fit: BoxFit.fill,
        filterQuality: FilterQuality.high,
      ),
      Positioned(
        left: 19,
        top: 46,
        width: 48,
        height: 48,
        child: _TransparentHitTarget(semanticLabel: 'Go back', onTap: onBack),
      ),
      _ArtboardField(
        top: 359,
        semanticLabel: 'Parent name',
        controller: nameController,
        keyboardType: TextInputType.name,
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.next,
        autofillHints: const [AutofillHints.name],
      ),
      _ArtboardField(
        top: 457,
        semanticLabel: 'Email or mobile number',
        controller: contactController,
        keyboardType: TextInputType.emailAddress,
        textCapitalization: TextCapitalization.none,
        textInputAction: TextInputAction.done,
        autofillHints: const [
          AutofillHints.email,
          AutofillHints.telephoneNumber,
        ],
        onSubmitted: (_) => onSendOtp(),
      ),
      Positioned(
        left: 19,
        top: 710,
        width: 352,
        height: 70,
        child: _TransparentHitTarget(
          semanticLabel: 'Send OTP',
          onTap: onSendOtp,
        ),
      ),
      Positioned(
        left: 76,
        top: 780,
        width: 238,
        height: 48,
        child: _TransparentHitTarget(
          semanticLabel: 'Already have an account? Sign in',
          onTap: onSignIn,
        ),
      ),
    ],
  );
}

class _ArtboardField extends StatelessWidget {
  const _ArtboardField({
    required this.top,
    required this.semanticLabel,
    required this.controller,
    required this.keyboardType,
    required this.textCapitalization,
    required this.textInputAction,
    required this.autofillHints,
    this.onSubmitted,
  });

  final double top;
  final String semanticLabel;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction textInputAction;
  final Iterable<String> autofillHints;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) => Positioned(
    left: 44,
    top: top,
    width: 302,
    height: 53,
    child: Stack(
      children: [
        if (controller.text.isNotEmpty)
          const Positioned(
            left: 43,
            top: 6,
            right: 10,
            bottom: 6,
            child: ColoredBox(color: Color(0xFFF5EBD8)),
          ),
        Semantics(
          label: semanticLabel,
          textField: true,
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            textCapitalization: textCapitalization,
            textInputAction: textInputAction,
            autofillHints: autofillHints,
            onSubmitted: onSubmitted,
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
              contentPadding: EdgeInsets.fromLTRB(46, 16, 10, 14),
            ),
          ),
        ),
      ],
    ),
  );
}

class _TransparentHitTarget extends StatelessWidget {
  const _TransparentHitTarget({
    required this.semanticLabel,
    required this.onTap,
  });

  final String semanticLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    label: semanticLabel,
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

class _StepChip extends StatelessWidget {
  const _StepChip({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
    decoration: BoxDecoration(
      color: const Color(0x33F9C46B),
      border: Border.all(color: BearfetchColors.honey),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      label,
      style: const TextStyle(
        fontFamily: 'Nunito',
        color: Color(0xFF7A4A10),
        fontSize: 12,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});
  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _controller = TextEditingController();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: const Icon(Icons.arrow_back_rounded),
      ),
      backgroundColor: Colors.transparent,
    ),
    body: SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _StepChip(label: 'Step 2 of 4'),
            const SizedBox(height: 28),
            Text(
              'Verify your contact',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            const Text(
              'Enter the six-digit code sent to your email or mobile. For this local prototype, use any six digits.',
              style: BearfetchTheme.bodyTextStyle,
            ),
            const SizedBox(height: 36),
            TextFormField(
              controller: _controller,
              autofocus: true,
              maxLength: 6,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Fredoka',
                fontSize: 28,
                letterSpacing: 12,
              ),
              decoration: const InputDecoration(
                counterText: '',
                hintText: '••••••',
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 58,
              child: ElevatedButton(
                onPressed: () {
                  if (_controller.text.length != 6) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Enter all six digits to continue.'),
                      ),
                    );
                    return;
                  }
                  context.go('/signup/learner');
                },
                child: const Text('Verify and continue'),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
