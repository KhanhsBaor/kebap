import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kebap/core/theme/kebap_colors.dart';
import 'package:kebap/core/theme/kebap_spacing.dart';
import 'package:kebap/features/catalog/domain/entities/exercise.dart';
import 'package:kebap/features/catalog/domain/entities/muscle_group.dart';
import 'package:kebap/features/catalog/presentation/catalog_name.dart';
import 'package:kebap/features/catalog/presentation/providers/catalog_providers.dart';
import 'package:kebap/features/workout/domain/entities/workout_session.dart';
import 'package:kebap/features/workout/presentation/notices/active_workout_notice.dart';
import 'package:kebap/features/workout/presentation/providers/active_workout.dart';
import 'package:kebap/features/workout/presentation/providers/active_workout_notifier.dart';
import 'package:kebap/l10n/app_localizations.dart';

/// S06. Creates a custom exercise and appends it to the open session.
class CustomExerciseSheet extends ConsumerStatefulWidget {
  const CustomExerciseSheet({
    super.key,
    this.initialName = '',
    required this.initialGroupId,
  });

  final String initialName;
  final int initialGroupId;

  @override
  ConsumerState<CustomExerciseSheet> createState() =>
      _CustomExerciseSheetState();
}

class _CustomExerciseSheetState extends ConsumerState<CustomExerciseSheet> {
  late final TextEditingController _name;
  late int _groupId;
  Exercise? _duplicate;
  String? _error;
  var _submitting = false;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.initialName);
    _groupId = widget.initialGroupId;
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<KebapSpacing>()!;
    final colors = Theme.of(context).extension<KebapColors>()!;
    final l10n = AppLocalizations.of(context);
    final session = ref.watch(activeWorkoutProvider).asData?.value;
    final groups =
        ref.watch(muscleGroupsProvider).asData?.value ?? const <MuscleGroup>[];
    final groupIds = session?.muscleGroupIds ?? const <int>[];
    final canSubmit = _name.text.trim().isNotEmpty && !_submitting;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: spacing.md,
          right: spacing.md,
          top: spacing.md,
          bottom: MediaQuery.viewInsetsOf(context).bottom + spacing.md,
        ),
        child: Column(
          key: const Key('custom-exercise-sheet'),
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.createExercise,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: spacing.md),
            TextField(
              key: const Key('custom-exercise-name'),
              controller: _name,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l10n.exerciseNameLabel,
                errorText: _error,
                errorMaxLines: 2,
              ),
              onChanged: (_) {
                if (_error != null || _duplicate != null) {
                  setState(() {
                    _error = null;
                    _duplicate = null;
                  });
                } else {
                  setState(() {});
                }
              },
            ),
            if (_duplicate != null) ...[
              SizedBox(height: spacing.sm),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  key: const Key('use-existing-exercise'),
                  onPressed: _submitting
                      ? null
                      : () => _useExisting(session, _duplicate!),
                  style: TextButton.styleFrom(
                    foregroundColor: colors.primary,
                    minimumSize: Size(0, spacing.touch),
                    padding: EdgeInsets.symmetric(horizontal: spacing.sm),
                  ),
                  child: Text(l10n.useExistingExercise),
                ),
              ),
            ],
            SizedBox(height: spacing.md),
            Text(
              l10n.muscleGroupLabel,
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(color: colors.muted),
            ),
            SizedBox(height: spacing.sm),
            if (groupIds.length <= 1)
              Text(
                key: const Key('custom-exercise-single-group'),
                _groupTitle(
                  groups,
                  groupIds.isEmpty ? _groupId : groupIds.first,
                ),
                style: Theme.of(context).textTheme.titleMedium,
              )
            else
              Wrap(
                key: const Key('custom-exercise-group-chips'),
                spacing: spacing.sm,
                runSpacing: spacing.sm,
                children: [
                  for (final id in groupIds)
                    ConstrainedBox(
                      key: Key('custom-group-chip-$id'),
                      constraints: BoxConstraints(minHeight: spacing.touch),
                      child: ChoiceChip(
                        label: Text(_groupTitle(groups, id)),
                        selected: _groupId == id,
                        onSelected: (_) => _selectGroup(id),
                        showCheckmark: false,
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        visualDensity: VisualDensity.standard,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            spacing.radiusControl,
                          ),
                        ),
                        side: BorderSide(
                          color: _groupId == id
                              ? colors.primary
                              : colors.border,
                        ),
                        selectedColor: colors.primary.withValues(alpha: 0.12),
                        labelPadding: EdgeInsets.symmetric(
                          horizontal: spacing.sm,
                          vertical: spacing.sm,
                        ),
                      ),
                    ),
                ],
              ),
            SizedBox(height: spacing.lg),
            FilledButton(
              key: const Key('add-custom-to-workout'),
              onPressed: canSubmit ? _submit : null,
              style: FilledButton.styleFrom(
                minimumSize: Size.fromHeight(spacing.touch),
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
                disabledBackgroundColor: colors.border,
                disabledForegroundColor: colors.muted,
              ),
              child: Text(l10n.addToWorkout),
            ),
          ],
        ),
      ),
    );
  }

  void _pop(int id) {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop(id);
    }
  }

  void _selectGroup(int id) {
    setState(() {
      _groupId = id;
      _error = null;
      _duplicate = null;
    });
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

  Future<void> _submit() async {
    final name = _name.text.trim();
    if (name.isEmpty || _submitting) return;
    setState(() {
      _submitting = true;
      _error = null;
      _duplicate = null;
    });
    final commands = ref.read(activeWorkoutCommandsProvider.notifier);
    final id = await commands.createCustomExercise(
      name: name,
      muscleGroupId: _groupId,
    );
    if (!mounted) return;
    if (id != null) {
      _pop(id);
      return;
    }
    final notice = ref.read(activeWorkoutCommandsProvider);
    commands.clearNotice();
    setState(() {
      _submitting = false;
      switch (notice) {
        case ActiveWorkoutDuplicateName(:final exercise):
          _duplicate = exercise;
          _error = AppLocalizations.of(context).duplicateExerciseInGroup;
        case ActiveWorkoutSaveFailed():
        case ActiveWorkoutRejected():
          _error = AppLocalizations.of(context).customExerciseSaveFailed;
        case _:
          _error = AppLocalizations.of(context).customExerciseSaveFailed;
      }
    });
  }

  Future<void> _useExisting(WorkoutSession? session, Exercise exercise) async {
    if (_submitting) return;
    setState(() => _submitting = true);
    final existing = session?.exercises
        .where((item) => item.exerciseId == exercise.id)
        .firstOrNull;
    if (existing != null) {
      if (mounted) _pop(existing.id);
      return;
    }
    final id = await ref
        .read(activeWorkoutCommandsProvider.notifier)
        .addExercise(exerciseId: exercise.id);
    if (!mounted) return;
    if (id != null) {
      _pop(id);
      return;
    }
    ref.read(activeWorkoutCommandsProvider.notifier).clearNotice();
    setState(() {
      _submitting = false;
      _error = AppLocalizations.of(context).customExerciseSaveFailed;
    });
  }
}
