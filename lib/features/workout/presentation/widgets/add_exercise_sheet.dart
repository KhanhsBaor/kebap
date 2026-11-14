import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kebap/core/theme/kebap_colors.dart';
import 'package:kebap/core/theme/kebap_spacing.dart';
import 'package:kebap/features/catalog/domain/entities/exercise.dart';
import 'package:kebap/features/catalog/domain/entities/muscle_group.dart';
import 'package:kebap/features/catalog/presentation/catalog_name.dart';
import 'package:kebap/features/catalog/presentation/providers/catalog_providers.dart';
import 'package:kebap/features/workout/presentation/providers/active_workout.dart';
import 'package:kebap/features/workout/presentation/providers/active_workout_exercises.dart';
import 'package:kebap/features/workout/presentation/providers/active_workout_notifier.dart';
import 'package:kebap/l10n/app_localizations.dart';

class AddExerciseSheet extends ConsumerStatefulWidget {
  const AddExerciseSheet({super.key});

  @override
  ConsumerState<AddExerciseSheet> createState() => _AddExerciseSheetState();
}

class _AddExerciseSheetState extends ConsumerState<AddExerciseSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<KebapSpacing>()!;
    final colors = Theme.of(context).extension<KebapColors>()!;
    final l10n = AppLocalizations.of(context);
    final session = ref.watch(activeWorkoutProvider).asData?.value;
    final exercises =
        ref.watch(activeWorkoutExercisesProvider).asData?.value ??
        const <Exercise>[];
    final groups =
        ref.watch(muscleGroupsProvider).asData?.value ?? const <MuscleGroup>[];
    final taken =
        session?.exercises.map((item) => item.exerciseId).toSet() ??
        const <int>{};
    final allowed = session?.muscleGroupIds.toSet() ?? const <int>{};

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(spacing.md),
              child: TextField(
                key: const Key('exercise-search'),
                decoration: InputDecoration(hintText: l10n.searchExercises),
                onChanged: (value) => setState(() => _query = value.trim()),
              ),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final groupId
                      in session?.muscleGroupIds ?? const <int>[])
                    ..._group(
                      context,
                      groupId: groupId,
                      title: _groupTitle(groups, groupId),
                      exercises: exercises
                          .where(
                            (exercise) =>
                                exercise.muscleGroupId == groupId &&
                                allowed.contains(exercise.muscleGroupId) &&
                                _matches(exercise),
                          )
                          .toList(),
                      taken: taken,
                      colors: colors,
                    ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(spacing.md),
              child: OutlinedButton(
                key: const Key('create-exercise'),
                onPressed: _createExerciseLater,
                child: Text(l10n.createExercise),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _group(
    BuildContext context, {
    required int groupId,
    required String title,
    required List<Exercise> exercises,
    required Set<int> taken,
    required KebapColors colors,
  }) {
    if (exercises.isEmpty) return const [];
    final spacing = Theme.of(context).extension<KebapSpacing>()!;
    return [
      Padding(
        padding: EdgeInsets.fromLTRB(
          spacing.md,
          spacing.sm,
          spacing.md,
          spacing.xs,
        ),
        child: Text(title, style: Theme.of(context).textTheme.titleMedium),
      ),
      for (final exercise in exercises)
        ListTile(
          key: Key('exercise-option-${exercise.id}'),
          enabled: !taken.contains(exercise.id),
          title: Text(
            catalogName(
              nameEn: exercise.nameEn,
              nameVi: exercise.nameVi,
              locale: Localizations.localeOf(context),
            ),
            style: TextStyle(
              color: taken.contains(exercise.id) ? colors.muted : null,
            ),
          ),
          onTap: taken.contains(exercise.id) ? null : () => _add(exercise.id),
        ),
    ];
  }

  String _groupTitle(List<MuscleGroup> groups, int groupId) {
    for (final group in groups) {
      if (group.id == groupId) {
        return catalogName(
          nameEn: group.nameEn,
          nameVi: group.nameVi,
          locale: Localizations.localeOf(context),
        );
      }
    }
    return '';
  }

  bool _matches(Exercise exercise) {
    if (_query.isEmpty) return true;
    final query = _query.toLowerCase();
    return exercise.nameEn.toLowerCase().contains(query) ||
        (exercise.nameVi?.toLowerCase().contains(query) ?? false);
  }

  Future<void> _add(int exerciseId) async {
    await ref
        .read(activeWorkoutCommandsProvider.notifier)
        .addExercise(exerciseId: exerciseId);
    if (mounted) Navigator.of(context).pop();
  }

  /// S06 is task 10. The button stays visible and does not navigate.
  void _createExerciseLater() {}
}
