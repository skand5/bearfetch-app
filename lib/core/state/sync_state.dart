import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/app_repositories.dart';
import 'app_state.dart';
import 'auth_state.dart';

class SyncViewState {
  const SyncViewState({required this.result, this.isRunning = false});

  final SyncRunResult result;
  final bool isRunning;
}

final syncControllerProvider =
    AsyncNotifierProvider<SyncController, SyncViewState>(SyncController.new);

class SyncController extends AsyncNotifier<SyncViewState> {
  @override
  Future<SyncViewState> build() async {
    final auth = ref.watch(authFlowControllerProvider).valueOrNull;
    final initial = SyncViewState(
      result: const SyncRunResult(status: SyncRunStatus.skipped),
    );
    if (auth?.isAuthenticated == true) {
      scheduleMicrotask(() {
        unawaited(syncNow());
      });
    }
    return initial;
  }

  Future<SyncRunResult> syncNow() async {
    state = AsyncData(
      SyncViewState(
        result:
            state.valueOrNull?.result ??
            const SyncRunResult(status: SyncRunStatus.skipped),
        isRunning: true,
      ),
    );
    final result = await ref.read(syncRepositoryProvider).syncNow();
    if (result.status == SyncRunStatus.synced) {
      await ref.read(appStateControllerProvider.notifier).refresh();
    }
    state = AsyncData(SyncViewState(result: result));
    return result;
  }
}
