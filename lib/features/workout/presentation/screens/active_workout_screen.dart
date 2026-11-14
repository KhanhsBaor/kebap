import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kebap/core/theme/kebap_spacing.dart';
import 'package:kebap/features/catalog/presentation/catalog_name.dart';
import 'package:kebap/features/catalog/presentation/providers/catalog_providers.dart';
import 'package:kebap/features/workout/presentation/providers/active_workout.dart';
import 'package:kebap/l10n/app_localizations.dart';

/// Stand-in for S05 until the log screen is built.
/// Shows the muscle groups of the open session.
class ActiveWorkoutScreen extends ConsumerWidget {
  const ActiveWorkoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = Theme.of(context).extension<KebapSpacing>()!;
    final session = ref.watch(activeWorkoutProvider).asData?.value;
    final groups = ref.watch(muscleGroupsProvider).asData?.value ?? const [];
    final locale = Localizations.localeOf(context);
    final names = <String>[];
    if (session != null) {
      final byId = {for (final group in groups) group.id: group};
      for (final id in session.muscleGroupIds) {
        final group = byId[id];
        if (group == null) continue;
        names.add(
          catalogName(
            nameEn: group.nameEn,
            nameVi: group.nameVi,
            locale: locale,
          ),
        );
      }
    }

    return Scaffold(
      key: const ValueKey('active-workout-screen'),
      appBar: AppBar(title: Text(l10n.activeWorkoutTitle)),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.md,
          vertical: spacing.lg,
        ),
        child: Text(
          names.join(', '),
          key: const ValueKey('active-workout-groups'),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
