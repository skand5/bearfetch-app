import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/state/app_state.dart';
import '../../../core/state/auth_state.dart';
import '../../../core/state/sync_state.dart';
import '../../../domain/repositories/app_repositories.dart';

class ParentSettingsScreen extends ConsumerWidget {
  const ParentSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appViewStateProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/profile'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Privacy and family data',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text(
            'BearFetch stores only family account, learner profile, progress, rewards, and accessories. Activity answers and chatbot simulations are never stored.',
          ),
          const SizedBox(height: 24),
          _InfoCard(
            title: 'Family profile',
            detail: '${state.parentName} · ${state.learnerName}',
            icon: Icons.family_restroom_rounded,
          ),
          _InfoCard(
            title: 'Consent',
            detail: switch (state.consentStatus) {
              'active' => 'Active',
              'withdrawn' => 'Withdrawn',
              _ => 'Not yet approved',
            },
            icon: Icons.verified_user_outlined,
          ),
          if (state.hasPendingDeletion)
            _InfoCard(
              title: 'Deletion pending',
              detail:
                  'Learning access is restricted until you cancel or deletion completes.',
              icon: Icons.schedule,
            ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => _exportData(context, ref),
            icon: const Icon(Icons.download_outlined),
            label: const Text('Export family data'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: state.hasPendingDeletion
                ? () => _cancelDeletion(context, ref)
                : () => _withdrawConsent(context, ref),
            icon: Icon(
              state.hasPendingDeletion
                  ? Icons.undo_rounded
                  : Icons.pause_circle_outline,
            ),
            label: Text(
              state.hasPendingDeletion
                  ? 'Cancel pending deletion'
                  : 'Withdraw consent',
            ),
          ),
          const SizedBox(height: 24),
          Text('Deletion', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          const Text(
            'Deletion immediately restricts learning. The scheduled purge occurs after 30 days and can be cancelled before then.',
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: state.hasPendingDeletion
                ? null
                : () => _scheduleDeletion(context, ref, DeletionTarget.learner),
            icon: const Icon(Icons.person_remove_outlined),
            label: const Text('Delete learner profile'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red.shade800,
            ),
            onPressed: state.hasPendingDeletion
                ? null
                : () => _scheduleDeletion(context, ref, DeletionTarget.family),
            icon: const Icon(Icons.delete_forever_outlined),
            label: const Text('Delete family account'),
          ),
          const SizedBox(height: 24),
          TextButton.icon(
            onPressed: () async {
              await ref.read(authFlowControllerProvider.notifier).signOut();
              if (context.mounted) context.go('/onboarding');
            },
            icon: const Icon(Icons.logout),
            label: const Text('Sign out'),
          ),
        ],
      ),
    );
  }

  Future<void> _exportData(BuildContext context, WidgetRef ref) async {
    if (!await _confirmFreshOtp(context, ref)) {
      return;
    }
    final data = await ref.read(privacyRepositoryProvider).exportLocalData();
    if (!context.mounted) return;
    final export = const JsonEncoder.withIndent('  ').convert(data);
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Family data export'),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(child: SelectableText(export)),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: export));
              if (dialogContext.mounted) Navigator.of(dialogContext).pop();
            },
            child: const Text('Copy data'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _withdrawConsent(BuildContext context, WidgetRef ref) async {
    if (!await _confirmFreshOtp(context, ref) || !context.mounted) {
      return;
    }
    final confirmed = await _confirm(
      context,
      'Withdraw consent?',
      'Learning access will be restricted immediately.',
    );
    if (!confirmed || !context.mounted) {
      return;
    }
    await ref.read(privacyRepositoryProvider).withdrawConsent();
    await ref.read(syncControllerProvider.notifier).syncNow();
    await ref.read(appStateControllerProvider.notifier).refresh();
    if (context.mounted) {
      context.go('/access-restricted?state=consent-withdrawn');
    }
  }

  Future<void> _scheduleDeletion(
    BuildContext context,
    WidgetRef ref,
    DeletionTarget target,
  ) async {
    if (!await _confirmFreshOtp(context, ref) || !context.mounted) {
      return;
    }
    final label = target == DeletionTarget.family
        ? 'family account'
        : 'learner profile';
    final confirmed = await _confirm(
      context,
      'Schedule $label deletion?',
      'You can cancel within 30 days. Learning access is restricted now.',
    );
    if (!confirmed || !context.mounted) {
      return;
    }
    await ref.read(privacyRepositoryProvider).scheduleDeletion(target);
    await ref.read(syncControllerProvider.notifier).syncNow();
    await ref.read(appStateControllerProvider.notifier).refresh();
    if (context.mounted) {
      context.go('/access-restricted?state=pending-deletion');
    }
  }

  Future<void> _cancelDeletion(BuildContext context, WidgetRef ref) async {
    final state = await ref
        .read(privacyRepositoryProvider)
        .deletionRequestState();
    final requestId = state.requestId;
    if (!context.mounted || requestId == null) {
      return;
    }
    if (!await _confirmFreshOtp(context, ref)) {
      return;
    }
    await ref.read(privacyRepositoryProvider).cancelDeletion(requestId);
    await ref.read(syncControllerProvider.notifier).syncNow();
    await ref.read(appStateControllerProvider.notifier).refresh();
    if (context.mounted) context.go('/profile');
  }

  Future<bool> _confirmFreshOtp(BuildContext context, WidgetRef ref) async {
    final email = ref.read(authRepositoryProvider).currentEmail;
    if (email == null) return false;
    try {
      await ref.read(authFlowControllerProvider.notifier).requestOtp(email);
    } catch (_) {
      if (context.mounted) {
        _message(context, 'We could not send a verification code.');
      }
      return false;
    }
    if (!context.mounted) return false;
    final code = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => _OtpDialog(email: email),
    );
    if (code == null) return false;
    try {
      await ref.read(authFlowControllerProvider.notifier).verifyOtp(code);
      return true;
    } catch (_) {
      if (context.mounted) {
        _message(context, 'That code is invalid or expired.');
      }
      return false;
    }
  }

  Future<bool> _confirm(
    BuildContext context,
    String title,
    String message,
  ) async =>
      await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Continue'),
            ),
          ],
        ),
      ) ??
      false;

  void _message(BuildContext context, String text) =>
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(text)));
}

class AccessRestrictedScreen extends StatelessWidget {
  const AccessRestrictedScreen({super.key, required this.state});

  final String state;

  @override
  Widget build(BuildContext context) {
    final pendingDeletion = state == 'pending-deletion';
    return Scaffold(
      appBar: AppBar(title: const Text('Access restricted')),
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              pendingDeletion
                  ? Icons.schedule_outlined
                  : Icons.privacy_tip_outlined,
              size: 48,
            ),
            const SizedBox(height: 20),
            Text(
              pendingDeletion ? 'Deletion is pending' : 'Consent was withdrawn',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              pendingDeletion
                  ? 'Learning is paused while the deletion request is pending. You can cancel it from Parent settings before the scheduled deletion date.'
                  : 'Learning is paused because parent consent is no longer active. Review the family settings to manage your data.',
            ),
            const Spacer(),
            FilledButton(
              onPressed: () => context.go('/parent-settings'),
              child: const Text('Open Parent settings'),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.detail,
    required this.icon,
  });
  final String title;
  final String detail;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(detail),
    ),
  );
}

class _OtpDialog extends StatefulWidget {
  const _OtpDialog({required this.email});
  final String email;

  @override
  State<_OtpDialog> createState() => _OtpDialogState();
}

class _OtpDialogState extends State<_OtpDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Confirm it is you'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Enter the six-digit code sent to ${widget.email}.'),
        const SizedBox(height: 16),
        TextField(
          controller: _controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          maxLength: 6,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(labelText: 'Verification code'),
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Cancel'),
      ),
      FilledButton(
        onPressed: () {
          final code = _controller.text;
          if (code.length == 6) Navigator.of(context).pop(code);
        },
        child: const Text('Confirm'),
      ),
    ],
  );
}
