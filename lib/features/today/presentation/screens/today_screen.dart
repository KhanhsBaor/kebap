import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kebap/core/router/app_routes.dart';
import 'package:kebap/core/theme/kebap_colors.dart';
import 'package:kebap/core/theme/kebap_spacing.dart';
import 'package:kebap/features/catalog/domain/entities/muscle_group.dart';
import 'package:kebap/features/catalog/presentation/providers/catalog_providers.dart';
import 'package:kebap/features/today/presentation/widgets/in_progress_banner.dart';
import 'package:kebap/features/workout/domain/calculations/workout_staleness.dart';
import 'package:kebap/features/workout/domain/entities/workout_session.dart';
import 'package:kebap/features/workout/presentation/providers/active_workout.dart';
import 'package:kebap/features/workout/presentation/providers/active_workout_notifier.dart';
import 'package:kebap/features/workout/presentation/providers/rest_timer_notifier.dart';
import 'package:kebap/features/workout/presentation/widgets/workout_dialogs.dart';
import 'package:kebap/features/workout/presentation/workout_start_time.dart';
import 'package:kebap/l10n/app_localizations.dart';

/// S01. An open session shows the "Buổi đang dở" banner instead of the
/// start button. A stale session (`docs/06` mục 3.4) is checked on cold
/// start, on resume, and before "Tiếp tục". S05 never opens by itself.
class TodayScreen extends ConsumerStatefulWidget {
  const TodayScreen({super.key});

  @override
  ConsumerState<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends ConsumerState<TodayScreen> {
  ProviderSubscription<AsyncValue<WorkoutSession?>>? _sessionSub;
  late final AppLifecycleListener _lifecycle;
  var _coldStartChecked = false;
  var _checkWhenBack = false;
  var _dialogOpen = false;

  /// Set after the user keeps a stale session. Cleared on the next resume.
  var _keptStaleThisForeground = false;

  @override
  void initState() {
    super.initState();
    _sessionSub = ref.listenManual(activeWorkoutProvider, (previous, next) {
      if (_coldStartChecked || !next.hasValue) return;
      _coldStartChecked = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _askIfStale();
      });
    }, fireImmediately: true);
    _lifecycle = AppLifecycleListener(onResume: _onResume);
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    _sessionSub?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(activeWorkoutCommandsProvider);

    final l10n = AppLocalizations.of(context);
    final spacing = Theme.of(context).extension<KebapSpacing>()!;
    final colors = Theme.of(context).extension<KebapColors>()!;
    final sessionAsync = ref.watch(activeWorkoutProvider);
    final session = sessionAsync.asData?.value;
    final groups =
        ref.watch(muscleGroupsProvider).asData?.value ?? const <MuscleGroup>[];

    return Scaffold(
      key: const ValueKey('today-screen'),
      appBar: AppBar(title: Text(l10n.todayLabel)),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.md,
          vertical: spacing.xl,
        ),
        children: [
          if (session != null)
            InProgressBanner(
              session: session,
              groups: groups,
              now: ref.read(workoutClockProvider)(),
              onContinue: _continue,
              onDiscard: () => _discard(session),
            ),
          if (sessionAsync.hasValue && session == null) ...[
            Text(l10n.todayEmpty, style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: spacing.lg),
            FilledButton(
              key: const ValueKey('today-start-workout'),
              onPressed: () => context.pushNamed(AppRoutes.startWorkoutName),
              style: FilledButton.styleFrom(
                minimumSize: Size.fromHeight(spacing.touch),
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
              ),
              child: Text(l10n.startWorkoutAction),
            ),
          ],
        ],
      ),
    );
  }

  void _onResume() {
    _keptStaleThisForeground = false;
    if (_isVisible()) {
      _askIfStale();
    } else {
      _checkWhenBack = true;
    }
  }

  bool _isVisible() {
    if (!mounted || !(ModalRoute.of(context)?.isCurrent ?? true)) return false;
    final router = GoRouter.maybeOf(context);
    if (router == null) return true;
    return router.routerDelegate.currentConfiguration.uri.path ==
        AppRoutes.today;
  }

  Future<void> _continue() async {
    if (_dialogOpen) return;
    final asked = await _askIfStale();
    if (!mounted || asked) return;
    await _openActiveWorkout();
  }

  Future<void> _openActiveWorkout() async {
    await context.pushNamed(AppRoutes.activeWorkoutName);
    if (!mounted || !_checkWhenBack) return;
    _checkWhenBack = false;
    await _askIfStale();
  }

  /// False when nothing was asked: no session, not stale, or the user
  /// already kept it in this foreground session.
  Future<bool> _askIfStale() async {
    final session = ref.read(activeWorkoutProvider).asData?.value;
    if (session == null || _dialogOpen || _keptStaleThisForeground) {
      return false;
    }
    final now = ref.read(workoutClockProvider)();
    if (!isStaleWorkout(
      lastActivityAt: lastWorkoutActivity(session),
      now: now,
    )) {
      return false;
    }

    _dialogOpen = true;
    final choice = await showStaleWorkoutDialog(
      context,
      startedAtLabel: formatWorkoutStart(
        context,
        startedAt: session.startedAt,
        now: now,
      ),
      canSave: session.savedSetCount > 0,
    );
    _dialogOpen = false;
    if (!mounted) return true;

    switch (choice) {
      case StaleWorkoutChoice.save:
        await ref
            .read(activeWorkoutCommandsProvider.notifier)
            .finishStaleWorkout();
      case StaleWorkoutChoice.discard:
        final discarded = await _discard(session);
        if (!discarded) _keptStaleThisForeground = true;
      case StaleWorkoutChoice.resume:
        _keptStaleThisForeground = true;
        unawaited(_openActiveWorkout());
      case null:
        break;
    }
    return true;
  }

  Future<bool> _discard(WorkoutSession session) async {
    if (_dialogOpen) return false;
    _dialogOpen = true;
    try {
      return await discardWorkoutWithConfirm(context, ref, session);
    } finally {
      _dialogOpen = false;
    }
  }
}
