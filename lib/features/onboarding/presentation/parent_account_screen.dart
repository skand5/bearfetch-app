import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/state/app_state.dart';
import '../../../core/state/auth_state.dart';
import '../../../core/theme/bearfetch_theme.dart';

class ParentAccountScreen extends ConsumerStatefulWidget {
  const ParentAccountScreen({super.key, this.isSignIn = false});

  final bool isSignIn;

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
    final email = _contactController.text.trim();
    final isEmail = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);

    if (!widget.isSignIn && name.length < 2) {
      _showValidationMessage('Enter your name.');
      return;
    }
    if (!isEmail) {
      _showValidationMessage('Enter a valid email address.');
      return;
    }
    try {
      if (!widget.isSignIn) {
        await ref.read(appStateControllerProvider.notifier).setParentName(name);
      }
      await ref.read(authFlowControllerProvider.notifier).requestOtp(email);
      if (mounted) context.go('/signup/verify');
    } catch (_) {
      if (mounted) {
        _showValidationMessage(
          'Could not send the code. Check your connection and try again.',
        );
      }
    }
  }

  void _showValidationMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isSignIn) {
      return _ReturningParentAccountScreen(
        controller: _contactController,
        onBack: () => context.pop(),
        onSendOtp: _sendOtp,
        onCreateAccount: () => context.go('/signup/account'),
      );
    }
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
                      isSignIn: false,
                      nameController: _nameController,
                      contactController: _contactController,
                      onBack: () => context.pop(),
                      onSendOtp: _sendOtp,
                      onSignIn: () =>
                          context.go('/signup/account?mode=sign-in'),
                      onCreateAccount: () => context.go('/signup/account'),
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

class _ReturningParentAccountScreen extends StatelessWidget {
  const _ReturningParentAccountScreen({
    required this.controller,
    required this.onBack,
    required this.onSendOtp,
    required this.onCreateAccount,
  });
  final TextEditingController controller;
  final VoidCallback onBack;
  final VoidCallback onSendOtp;
  final VoidCallback onCreateAccount;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFFFF8EF),
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, c) {
          final scale = (c.maxWidth / 390).clamp(0.0, c.maxHeight / 844);
          return Center(
            child: SizedBox(
              width: 390 * scale,
              height: 844 * scale,
              child: FittedBox(
                fit: BoxFit.fill,
                child: SizedBox(
                  width: 390,
                  height: 844,
                  child: Stack(
                    children: [
                      const Positioned.fill(
                        child: ColoredBox(color: Color(0xFFFFF8EF)),
                      ),
                      const Positioned(
                        top: -65,
                        right: -54,
                        child: _SignInBlob(size: 180, color: Color(0xFFDDF1E5)),
                      ),
                      const Positioned(
                        bottom: -72,
                        left: -55,
                        child: _SignInBlob(size: 175, color: Color(0xFFFCE7A8)),
                      ),
                      Positioned(
                        left: 20,
                        top: 22,
                        child: IconButton(
                          onPressed: onBack,
                          icon: const Icon(Icons.arrow_back_rounded),
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFFF2EDE5),
                            foregroundColor: const Color(0xFF482C23),
                          ),
                        ),
                      ),
                      const Positioned(
                        top: 30,
                        right: 28,
                        child: Text(
                          'Sign in',
                          style: TextStyle(
                            fontFamily: 'Fredoka',
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF7A4A10),
                          ),
                        ),
                      ),
                      const Positioned(
                        left: 28,
                        top: 128,
                        child: Text(
                          'Welcome back',
                          style: TextStyle(
                            fontFamily: 'Fredoka',
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF482C23),
                          ),
                        ),
                      ),
                      const Positioned(
                        left: 28,
                        top: 178,
                        right: 28,
                        child: Text(
                          'Sign in to your BearFetch family account.',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 18,
                            height: 1.35,
                            color: Color(0xFF805333),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 255,
                        width: 350,
                        height: 230,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFCF8),
                            border: Border.all(
                              color: const Color(0xFFECE5DD),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(26),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Parent email',
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF633B21),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Semantics(
                                  label: 'Email address',
                                  textField: true,
                                  child: TextField(
                                    controller: controller,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.done,
                                    autofillHints: const [AutofillHints.email],
                                    onSubmitted: (_) => onSendOtp(),
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.mail_outline_rounded,
                                        color: Color(0xFFA77038),
                                      ),
                                      hintText: 'Enter your email',
                                      filled: true,
                                      fillColor: const Color(0xFFF5EBD8),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(17),
                                        borderSide: const BorderSide(
                                          color: Color(0xFFE1D2BA),
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    style: const TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'We will send a six-digit sign-in code to this email.',
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 14,
                                    height: 1.4,
                                    color: Color(0xFF38638E),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 515,
                        width: 350,
                        height: 64,
                        child: ElevatedButton.icon(
                          onPressed: onSendOtp,
                          icon: const Icon(Icons.lock_outline_rounded),
                          label: const Text('Send sign-in code'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: BearfetchColors.orange,
                            foregroundColor: Colors.white,
                            shape: const StadiumBorder(),
                            textStyle: const TextStyle(
                              fontFamily: 'Fredoka',
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 60,
                        top: 595,
                        width: 270,
                        child: TextButton(
                          onPressed: onCreateAccount,
                          child: const Text(
                            'New to BearFetch? Create account',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 15,
                              color: BearfetchColors.orange,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
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

class _SignInBlob extends StatelessWidget {
  const _SignInBlob({required this.size, required this.color});
  final double size;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}

class _ParentAccountArtboard extends StatelessWidget {
  const _ParentAccountArtboard({
    required this.isSignIn,
    required this.nameController,
    required this.contactController,
    required this.onBack,
    required this.onSendOtp,
    required this.onSignIn,
    required this.onCreateAccount,
  });

  final bool isSignIn;
  final TextEditingController nameController;
  final TextEditingController contactController;
  final VoidCallback onBack;
  final VoidCallback onSendOtp;
  final VoidCallback onSignIn;
  final VoidCallback onCreateAccount;

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
      if (isSignIn)
        _ReturningParentAccountOverlay(
          controller: contactController,
          onBack: onBack,
          onSendOtp: onSendOtp,
          onCreateAccount: onCreateAccount,
        )
      else ...[
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
          semanticLabel: 'Email address',
          controller: contactController,
          keyboardType: TextInputType.emailAddress,
          textCapitalization: TextCapitalization.none,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.email],
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
    ],
  );
}

class _ReturningParentAccountOverlay extends StatelessWidget {
  const _ReturningParentAccountOverlay({
    required this.controller,
    required this.onBack,
    required this.onSendOtp,
    required this.onCreateAccount,
  });

  final TextEditingController controller;
  final VoidCallback onBack;
  final VoidCallback onSendOtp;
  final VoidCallback onCreateAccount;

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      // Replace creation-only copy and fields while retaining the approved
      // artboard background and illustration.
      const Positioned(
        left: 18,
        top: 116,
        width: 154,
        height: 28,
        child: _ArtboardPatch(left: 18, top: 116),
      ),
      const Positioned(
        left: 21,
        top: 120,
        child: Text(
          'Account sign in',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 12,
            color: Color(0xFFA77038),
          ),
        ),
      ),
      Positioned(
        left: 18,
        top: 152,
        width: 238,
        height: 166,
        child: _ArtboardPatch(
          left: 18,
          top: 152,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome back',
                style: TextStyle(
                  fontFamily: 'Fredoka',
                  fontSize: 28,
                  height: 1.15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF482C23),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Sign in to your BearFetch family account.',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 16,
                  height: 1.35,
                  color: Color(0xFF805333),
                ),
              ),
            ],
          ),
        ),
      ),
      Positioned(
        left: 18,
        top: 330,
        width: 354,
        height: 300,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFFFFFCF8),
            border: Border.all(color: const Color(0xFFECE5DD), width: 2),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(26, 30, 26, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Parent email',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF633B21),
                  ),
                ),
                const SizedBox(height: 12),
                Semantics(
                  label: 'Email address',
                  textField: true,
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.none,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.email],
                    onSubmitted: (_) => onSendOtp(),
                    cursorColor: BearfetchColors.orange,
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 16,
                      color: BearfetchColors.bodyBrown,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.mail_outline_rounded,
                        color: Color(0xFFA77038),
                      ),
                      hintText: 'Enter your email',
                      hintStyle: const TextStyle(color: Color(0xFFA2907D)),
                      filled: true,
                      fillColor: const Color(0xFFF5EBD8),
                      contentPadding: const EdgeInsets.symmetric(vertical: 17),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(17),
                        borderSide: const BorderSide(
                          color: Color(0xFFE1D2BA),
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(17),
                        borderSide: const BorderSide(
                          color: BearfetchColors.orange,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color(0xFFEAF4FF),
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(13),
                    child: Text(
                      'We will send a six-digit sign-in code to this email.',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 13,
                        height: 1.35,
                        color: Color(0xFF38638E),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      Positioned(
        left: 19,
        top: 710,
        width: 352,
        height: 64,
        child: ElevatedButton.icon(
          onPressed: onSendOtp,
          icon: const Icon(Icons.lock_outline_rounded, size: 21),
          label: const Text('Send sign-in code'),
          style: ElevatedButton.styleFrom(
            backgroundColor: BearfetchColors.orange,
            foregroundColor: Colors.white,
            elevation: 3,
            shadowColor: BearfetchColors.orangeDark,
            shape: const StadiumBorder(),
            textStyle: const TextStyle(
              fontFamily: 'Fredoka',
              fontSize: 19,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      const Positioned(
        left: 18,
        top: 778,
        width: 354,
        height: 50,
        child: _ArtboardPatch(left: 18, top: 778),
      ),
      Positioned(
        left: 58,
        top: 782,
        width: 274,
        height: 44,
        child: TextButton(
          onPressed: onCreateAccount,
          child: const Text.rich(
            TextSpan(
              text: 'New to BearFetch? ',
              style: TextStyle(
                fontFamily: 'Nunito',
                color: Color(0xFF805333),
                fontSize: 15,
              ),
              children: [
                TextSpan(
                  text: 'Create account',
                  style: TextStyle(
                    color: BearfetchColors.orange,
                    fontWeight: FontWeight.w800,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

class _ArtboardPatch extends StatelessWidget {
  const _ArtboardPatch({required this.left, required this.top, this.child});

  final double left;
  final double top;
  final Widget? child;

  @override
  Widget build(BuildContext context) => ClipRect(
    child: Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          left: -left,
          top: -top,
          width: 390,
          height: 844,
          child: const Image(
            image: AssetImage('assets/illustrations/onboarding_02.png'),
            fit: BoxFit.fill,
            filterQuality: FilterQuality.high,
          ),
        ),
        if (child != null) Positioned.fill(child: child!),
      ],
    ),
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

class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({super.key});
  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
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
              'Enter the six-digit code sent to your email.',
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
                onPressed: () async {
                  if (_controller.text.length != 6) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Enter all six digits to continue.'),
                      ),
                    );
                    return;
                  }
                  try {
                    await ref
                        .read(authFlowControllerProvider.notifier)
                        .verifyOtp(_controller.text);
                    final parentName = ref
                        .read(appViewStateProvider)
                        .parentName;
                    await ref
                        .read(appStateControllerProvider.notifier)
                        .setParentName(parentName);
                    if (context.mounted) context.go('/signup/learner');
                  } catch (_) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Code expired or invalid. Request a new code.',
                          ),
                        ),
                      );
                    }
                  }
                },
                child: const Text('Verify and continue'),
              ),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await ref
                      .read(authFlowControllerProvider.notifier)
                      .resendOtp();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('New code sent.')),
                    );
                  }
                } catch (_) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Could not resend the code.'),
                      ),
                    );
                  }
                }
              },
              child: const Text('Resend code'),
            ),
          ],
        ),
      ),
    ),
  );
}
