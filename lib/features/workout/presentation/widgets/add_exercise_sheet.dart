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
import 'package:kebap/features/workout/presentation/widgets/add_exercise_sheet_logic.dart';
import 'package:kebap/features/workout/presentation/widgets/custom_exercise_sheet.dart';
import 'package:kebap/l10n/app_localizations.dart';

/// Returns the session-exercise id that was added, if any.
class AddExerciseSheet extends ConsumerStatefulWidget {
  const AddExerciseSheet({super.key});

  @override
  ConsumerState<AddExerciseSheet> createState() => _AddExerciseSheetState();
}

class _AddExerciseSheetState extends ConsumerState<AddExerciseSheet> {
  final _scroll = ScrollController();
  final _listKey = GlobalKey();
  final _sectionKeys = <int, GlobalKey>{};
  String _query = '';

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

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
    final groupIds = session?.muscleGroupIds ?? const <int>[];

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.55,
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
                  key: _listKey,
                  controller: _scroll,
                  shrinkWrap: true,
                  children: [
                    for (final groupId in groupIds)
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
                  onPressed: () => _openCreate(groupIds, exercises),
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size.fromHeight(spacing.touch),
                  ),
                  child: Text(l10n.createExercise),
                ),
              ),
            ],
          ),
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
    final headerKey = _sectionKeys.putIfAbsent(groupId, GlobalKey.new);
    return [
      Padding(
        key: headerKey,
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

  int _visibleGroupId(List<int> groupIds) {
    if (groupIds.isEmpty) return 0;
    if (!_scroll.hasClients) return groupIds.first;

    final listBox = _listKey.currentContext?.findRenderObject() as RenderBox?;
    final viewportTop = listBox?.localToGlobal(Offset.zero).dy ?? 0;
    final tops = <int, double>{};
    for (final id in groupIds) {
      final box =
          _sectionKeys[id]?.currentContext?.findRenderObject() as RenderBox?;
      if (box == null || !box.hasSize) continue;
      tops[id] = box.localToGlobal(Offset.zero).dy;
    }
    return visibleMuscleGroupId(
      groupIds: groupIds,
      sectionTops: tops,
      viewportTop: viewportTop,
    );
  }

  Future<void> _openCreate(List<int> groupIds, List<Exercise> exercises) async {
    if (groupIds.isEmpty) return;
    final matching = exercises.where(_matches).toList();
    final initialName = customExercisePrefill(
      query: _query,
      hasMatches: matching.isNotEmpty,
    );
    final initialGroupId = _visibleGroupId(groupIds);
    final added = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      builder: (context) => CustomExerciseSheet(
        initialName: initialName,
        initialGroupId: initialGroupId,
      ),
    );
    if (!mounted || added == null) return;
    Navigator.of(context).pop(added);
  }

  Future<void> _add(int exerciseId) async {
    final id = await ref
        .read(activeWorkoutCommandsProvider.notifier)
        .addExercise(exerciseId: exerciseId);
    if (!mounted) return;
    Navigator.of(context).pop(id);
  }
}
