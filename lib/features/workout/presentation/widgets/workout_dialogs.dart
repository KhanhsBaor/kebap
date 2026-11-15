import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kebap/core/theme/kebap_colors.dart';
import 'package:kebap/core/theme/kebap_spacing.dart';
import 'package:kebap/features/workout/domain/entities/workout_session.dart';
import 'package:kebap/features/workout/presentation/providers/active_workout_notifier.dart';
import 'package:kebap/l10n/app_localizations.dart';

enum InProgressChoice { continueIt, discardAndStartNew }

enum StaleWorkoutChoice { save, discard, resume }

/// S04 gate when a session is still open.
Future<InProgressChoice?> showInProgressWorkoutDialog(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  return _showChoiceDialog<InProgressChoice>(
    context,
    title: l10n.workoutInProgressTitle,
    actions: [
      _DialogAction.safe(
        key: const ValueKey('continue-that-workout'),
        label: l10n.continueThatWorkout,
        value: InProgressChoice.continueIt,
      ),
      _DialogAction.danger(
        key: const ValueKey('discard-and-start-new'),
        label: l10n.discardAndStartNew,
        value: InProgressChoice.discardAndStartNew,
      ),
    ],
  );
}

/// True when the user picks "Hủy buổi". The safe button is the default.
Future<bool> confirmDiscardWorkout(
  BuildContext context, {
  required int savedSetCount,
}) async {
  final l10n = AppLocalizations.of(context);
  final confirmed = await _showChoiceDialog<bool>(
    context,
    title: l10n.discardConfirmTitle(savedSetCount),
    actions: [
      _DialogAction.safe(
        key: const ValueKey('discard-keep-training'),
        label: l10n.keepTraining,
        value: false,
      ),
      _DialogAction.danger(
        key: const ValueKey('discard-confirm'),
        label: l10n.discardSession,
        value: true,
      ),
    ],
  );
  return confirmed ?? false;
}

/// `docs/06` mục 3.4. [canSave] is false for a session without sets,
/// which cannot become a completed workout.
Future<StaleWorkoutChoice?> showStaleWorkoutDialog(
  BuildContext context, {
  required String startedAtLabel,
  required bool canSave,
}) {
  final l10n = AppLocalizations.of(context);
  return _showChoiceDialog<StaleWorkoutChoice>(
    context,
    title: l10n.staleWorkoutTitle(startedAtLabel),
    actions: [
      _DialogAction.safe(
        key: const ValueKey('stale-resume'),
        label: l10n.continueWorkout,
        value: StaleWorkoutChoice.resume,
      ),
      if (canSave)
        _DialogAction.neutral(
          key: const ValueKey('stale-save'),
          label: l10n.saveAsCompleted,
          value: StaleWorkoutChoice.save,
        ),
      _DialogAction.danger(
        key: const ValueKey('stale-discard'),
        label: l10n.discardSession,
        value: StaleWorkoutChoice.discard,
      ),
    ],
  );
}

/// `docs/06` mục 4: no sets means nothing to lose, so delete at once.
/// Otherwise ask first. True when the session was deleted.
Future<bool> discardWorkoutWithConfirm(
  BuildContext context,
  WidgetRef ref,
  WorkoutSession session,
) async {
  final count = session.savedSetCount;
  if (count > 0) {
    final confirmed = await confirmDiscardWorkout(
      context,
      savedSetCount: count,
    );
    if (!confirmed) return false;
  }
  await ref.read(activeWorkoutCommandsProvider.notifier).cancelWorkout();
  return ref.read(activeWorkoutCommandsProvider) == null;
}

enum _ActionTone { safe, neutral, danger }

class _DialogAction<T> {
  const _DialogAction.safe({
    required this.key,
    required this.label,
    required this.value,
  }) : tone = _ActionTone.safe;

  const _DialogAction.neutral({
    required this.key,
    required this.label,
    required this.value,
  }) : tone = _ActionTone.neutral;

  const _DialogAction.danger({
    required this.key,
    required this.label,
    required this.value,
  }) : tone = _ActionTone.danger;

  final Key key;
  final String label;
  final T value;
  final _ActionTone tone;
}

Future<T?> _showChoiceDialog<T>(
  BuildContext context, {
  required String title,
  required List<_DialogAction<T>> actions,
}) {
  final colors = Theme.of(context).extension<KebapColors>()!;
  final spacing = Theme.of(context).extension<KebapSpacing>()!;
  return showDialog<T>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: colors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(spacing.radiusCard),
          side: BorderSide(color: colors.border),
        ),
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final (index, action) in actions.indexed) ...[
              if (index > 0) SizedBox(height: spacing.sm),
              _button(dialogContext, action, colors, spacing),
            ],
          ],
        ),
      );
    },
  );
}

Widget _button<T>(
  BuildContext dialogContext,
  _DialogAction<T> action,
  KebapColors colors,
  KebapSpacing spacing,
) {
  void onPressed() => Navigator.of(dialogContext).pop(action.value);
  final shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(spacing.radiusCard),
  );
  return switch (action.tone) {
    _ActionTone.safe => FilledButton(
      key: action.key,
      autofocus: true,
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        minimumSize: Size.fromHeight(spacing.touch),
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
      ),
      child: Text(action.label),
    ),
    _ActionTone.neutral => OutlinedButton(
      key: action.key,
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: colors.foreground,
        minimumSize: Size.fromHeight(spacing.touch),
        side: BorderSide(color: colors.border),
        shape: shape,
      ),
      child: Text(action.label),
    ),
    _ActionTone.danger => OutlinedButton(
      key: action.key,
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: colors.trendDown,
        minimumSize: Size.fromHeight(spacing.touch),
        side: BorderSide(color: colors.trendDown),
        shape: shape,
      ),
      child: Text(action.label),
    ),
  };
}
