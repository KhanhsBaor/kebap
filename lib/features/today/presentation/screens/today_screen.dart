import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kebap/core/router/app_routes.dart';
import 'package:kebap/core/theme/kebap_colors.dart';
import 'package:kebap/core/theme/kebap_spacing.dart';
import 'package:kebap/features/workout/presentation/providers/active_workout.dart';
import 'package:kebap/l10n/app_localizations.dart';

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = Theme.of(context).extension<KebapSpacing>()!;
    final colors = Theme.of(context).extension<KebapColors>()!;
    final session = ref.watch(activeWorkoutProvider);
    final inProgress = session.asData?.value != null;

    return Scaffold(
      key: const ValueKey('today-screen'),
      appBar: AppBar(title: Text(l10n.todayLabel)),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.md,
          vertical: spacing.xl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Full "Buổi đang dở" banner lands with the Home checklist task.
            // Until then, keep a continue path so an open session is not a dead end.
            if (session.hasValue && inProgress) ...[
              FilledButton(
                key: const ValueKey('today-continue-workout'),
                onPressed: () =>
                    context.pushNamed(AppRoutes.activeWorkoutName),
                style: FilledButton.styleFrom(
                  minimumSize: Size.fromHeight(spacing.touch),
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                ),
                child: Text(l10n.continueWorkout),
              ),
            ],
            if (session.hasValue && !inProgress) ...[
              Text(
                l10n.todayEmpty,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
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
      ),
    );
  }
}
