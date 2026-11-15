import 'package:flutter/material.dart';
import 'package:kebap/core/theme/kebap_colors.dart';
import 'package:kebap/core/theme/kebap_spacing.dart';
import 'package:kebap/features/catalog/domain/entities/muscle_group.dart';
import 'package:kebap/features/catalog/presentation/catalog_name.dart';
import 'package:kebap/features/workout/domain/entities/workout_session.dart';
import 'package:kebap/features/workout/presentation/workout_start_time.dart';
import 'package:kebap/l10n/app_localizations.dart';

/// S01 "Buổi đang dở". Takes the place of the start button.
class InProgressBanner extends StatelessWidget {
  const InProgressBanner({
    super.key,
    required this.session,
    required this.groups,
    required this.now,
    required this.onContinue,
    required this.onDiscard,
  });

  final WorkoutSession session;
  final List<MuscleGroup> groups;
  final DateTime now;
  final VoidCallback onContinue;
  final VoidCallback onDiscard;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = Theme.of(context).extension<KebapSpacing>()!;
    final colors = Theme.of(context).extension<KebapColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context);
    final byId = {for (final group in groups) group.id: group};
    final names = [
      for (final id in session.muscleGroupIds)
        if (byId[id] case final group?)
          catalogName(
            nameEn: group.nameEn,
            nameVi: group.nameVi,
            locale: locale,
          ),
    ].join(' · ');
    final startedAt = formatWorkoutStart(
      context,
      startedAt: session.startedAt,
      now: now,
    );
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(spacing.radiusCard),
    );

    return Container(
      key: const ValueKey('in-progress-banner'),
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(spacing.radiusCard),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.inProgressBannerTitle,
            style: textTheme.labelLarge?.copyWith(color: colors.muted),
          ),
          SizedBox(height: spacing.xs),
          if (names.isNotEmpty)
            Text(
              names,
              key: const ValueKey('in-progress-groups'),
              style: textTheme.titleMedium?.copyWith(color: colors.foreground),
            ),
          SizedBox(height: spacing.xs),
          Text(
            '${l10n.savedSetCount(session.savedSetCount)} · '
            '${l10n.startedAtLabel(startedAt)}',
            key: const ValueKey('in-progress-summary'),
            style: textTheme.bodyMedium?.copyWith(color: colors.muted),
          ),
          SizedBox(height: spacing.md),
          FilledButton(
            key: const ValueKey('today-continue-workout'),
            onPressed: onContinue,
            style: FilledButton.styleFrom(
              minimumSize: Size.fromHeight(spacing.touch),
              backgroundColor: colors.primary,
              foregroundColor: colors.onPrimary,
            ),
            child: Text(l10n.continueWorkout),
          ),
          SizedBox(height: spacing.sm),
          OutlinedButton(
            key: const ValueKey('today-discard-workout'),
            onPressed: onDiscard,
            style: OutlinedButton.styleFrom(
              foregroundColor: colors.trendDown,
              minimumSize: Size.fromHeight(spacing.touch),
              side: BorderSide(color: colors.trendDown),
              shape: shape,
            ),
            child: Text(l10n.discardSession),
          ),
        ],
      ),
    );
  }
}
