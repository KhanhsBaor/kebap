import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kebap/core/theme/kebap_spacing.dart';
import 'package:kebap/features/catalog/domain/entities/exercise.dart';
import 'package:kebap/features/catalog/presentation/catalog_name.dart';
import 'package:kebap/features/workout/domain/calculations/set_prefill.dart';
import 'package:kebap/features/workout/domain/entities/session_exercise.dart';
import 'package:kebap/features/workout/domain/entities/set_log.dart';
import 'package:kebap/features/workout/presentation/providers/previous_sets.dart';
import 'package:kebap/features/workout/presentation/widgets/set_log_row.dart';
import 'package:kebap/l10n/app_localizations.dart';

class ExerciseLogBlock extends ConsumerWidget {
  const ExerciseLogBlock({
    required this.sessionExercise,
    required this.exercise,
    required this.plannedRows,
    required this.extraRows,
    required this.drafts,
    required this.anchor,
    required this.onStepKg,
    required this.onStepReps,
    required this.onEdit,
    required this.onSave,
    required this.onToggleWarmup,
    required this.onUndo,
    required this.onAddRow,
    super.key,
  });

  final SessionExercise sessionExercise;
  final Exercise? exercise;
  final int plannedRows;
  final int extraRows;
  final Map<int, SetDraft> drafts;
  final GlobalKey anchor;
  final void Function(int position, SetLoadSuggestion suggestion, int direction)
  onStepKg;
  final void Function(int position, SetLoadSuggestion suggestion, int direction)
  onStepReps;
  final void Function(
    int position,
    LoadField field,
    SetLoadSuggestion suggestion,
  )
  onEdit;
  final void Function(int position, SetLoadSuggestion suggestion) onSave;
  final void Function(int position, SetLoadSuggestion suggestion)
  onToggleWarmup;
  final void Function(SetLog set) onUndo;
  final VoidCallback onAddRow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = Theme.of(context).extension<KebapSpacing>()!;
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final reference =
        ref
            .watch(previousSetsProvider(sessionExercise.exerciseId))
            .asData
            ?.value ??
        const <SetLog>[];
    final savedCount = sessionExercise.sets.length;
    final base = savedCount > plannedRows ? savedCount : plannedRows;
    final rowCount = base + extraRows;
    final name = exercise == null
        ? ''
        : catalogName(
            nameEn: exercise!.nameEn,
            nameVi: exercise!.nameVi,
            locale: locale,
          );

    return Card(
      key: anchor,
      margin: EdgeInsets.only(bottom: spacing.md),
      child: Padding(
        padding: EdgeInsets.all(spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(name, style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: spacing.xs),
            Text(
              reference.isEmpty
                  ? l10n.noPreviousSession
                  : reference
                        .map((set) => SetLogRow.pair(set, locale.languageCode))
                        .join(', '),
              key: Key('previous-line-${sessionExercise.exerciseId}'),
            ),
            SizedBox(height: spacing.sm),
            Text(
              '${l10n.setColumn}  ·  ${l10n.previousColumn}  ·  ${l10n.kgColumn}  ·  ${l10n.repsColumn}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            SizedBox(height: spacing.sm),
            for (var position = 1; position <= rowCount; position++)
              _row(position, reference),
            TextButton(
              key: Key('add-set-${sessionExercise.exerciseId}'),
              onPressed: onAddRow,
              child: Text(l10n.addSet),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(int position, List<SetLog> reference) {
    final saved = _at(sessionExercise.sets, position);
    final suggestion = suggestSetLoad(
      position: position,
      savedSets: sessionExercise.sets,
      referenceSets: reference,
      plannedSetCount: plannedRows,
    );
    final draft = drafts[position];
    final kg = saved?.kg ?? draft?.kg ?? suggestion.kg;
    final reps = saved?.reps ?? draft?.reps ?? suggestion.reps;
    final canSave = saved != null || kg != null || (reps != null && reps > 0);

    return SetLogRow(
      exerciseId: sessionExercise.exerciseId,
      position: position,
      saved: saved,
      draft: draft ?? SetDraft(kg: suggestion.kg, reps: suggestion.reps),
      reference: _at(reference, position),
      onStepKg: (direction) => onStepKg(position, suggestion, direction),
      onStepReps: (direction) => onStepReps(position, suggestion, direction),
      onEditKg: () => onEdit(position, LoadField.kg, suggestion),
      onEditReps: () => onEdit(position, LoadField.reps, suggestion),
      onSave: canSave ? () => onSave(position, suggestion) : null,
      onToggleWarmup: () => onToggleWarmup(position, suggestion),
      onUndo: () {
        final set = saved;
        if (set != null) onUndo(set);
      },
    );
  }

  SetLog? _at(List<SetLog> sets, int position) {
    for (final set in sets) {
      if (set.position == position) return set;
    }
    return null;
  }
}
