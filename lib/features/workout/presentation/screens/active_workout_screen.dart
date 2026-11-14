import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kebap/core/theme/kebap_spacing.dart';
import 'package:kebap/features/catalog/domain/entities/exercise.dart';
import 'package:kebap/features/catalog/domain/entities/muscle_group.dart';
import 'package:kebap/features/catalog/presentation/catalog_name.dart';
import 'package:kebap/features/catalog/presentation/providers/catalog_providers.dart';
import 'package:kebap/features/workout/domain/calculations/set_prefill.dart';
import 'package:kebap/features/workout/domain/entities/session_exercise.dart';
import 'package:kebap/features/workout/domain/entities/set_log.dart';
import 'package:kebap/features/workout/domain/entities/workout_session.dart';
import 'package:kebap/features/workout/domain/usecases/finish_workout.dart';
import 'package:kebap/features/workout/presentation/providers/active_workout.dart';
import 'package:kebap/features/workout/presentation/providers/active_workout_exercises.dart';
import 'package:kebap/features/workout/presentation/providers/active_workout_notifier.dart';
import 'package:kebap/features/workout/presentation/providers/rest_timer_notifier.dart';
import 'package:kebap/features/workout/presentation/widgets/add_exercise_sheet.dart';
import 'package:kebap/features/workout/presentation/widgets/exercise_log_block.dart';
import 'package:kebap/features/workout/presentation/widgets/load_format.dart';
import 'package:kebap/features/workout/presentation/widgets/rest_timer_bar.dart';
import 'package:kebap/features/workout/presentation/widgets/set_log_row.dart';
import 'package:kebap/l10n/app_localizations.dart';

class ActiveWorkoutScreen extends ConsumerStatefulWidget {
  const ActiveWorkoutScreen({super.key});

  @override
  ConsumerState<ActiveWorkoutScreen> createState() =>
      _ActiveWorkoutScreenState();
}

class _Pad {
  _Pad({
    required this.sessionExerciseId,
    required this.position,
    required this.field,
    required this.text,
    required this.suggestion,
  });

  final int sessionExerciseId;
  final int position;
  final LoadField field;
  final SetLoadSuggestion suggestion;
  String text;
}

class _ActiveWorkoutScreenState extends ConsumerState<ActiveWorkoutScreen> {
  final _drafts = <String, SetDraft>{};
  final _extra = <int, int>{};
  final _anchors = <int, GlobalKey>{};
  _Pad? _pad;
  var _scrolled = false;
  var _scrollQueued = false;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<KebapSpacing>()!;
    final l10n = AppLocalizations.of(context);
    ref.watch(activeWorkoutCommandsProvider);
    final session = ref.watch(activeWorkoutProvider).asData?.value;
    final catalog =
        ref.watch(activeWorkoutExercisesProvider).asData?.value ??
        const <Exercise>[];
    final groups =
        ref.watch(muscleGroupsProvider).asData?.value ?? const <MuscleGroup>[];
    final restVisible = ref.watch(restTimerProvider) != null;
    if (session != null) _scheduleScroll(session);

    final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;

    return Scaffold(
      key: const Key('active-workout-screen'),
      appBar: AppBar(
        title: Text(
          _title(session, groups, l10n),
          key: const Key('active-workout-groups'),
        ),
        actions: [
          PopupMenuButton<void>(
            key: const Key('workout-menu'),
            itemBuilder: (context) => [
              PopupMenuItem(onTap: _notYet, child: Text(l10n.discardWorkout)),
              PopupMenuItem(onTap: _notYet, child: Text(l10n.finishWorkout)),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: session == null
                  ? const SizedBox.shrink()
                  : ListView(
                      padding: EdgeInsets.all(spacing.md),
                      children: [
                        if (session.exercises.isEmpty)
                          Text(l10n.noExercisesInWorkout),
                        for (final item in session.exercises)
                          ExerciseLogBlock(
                            sessionExercise: item,
                            exercise: _catalog(catalog, item.exerciseId),
                            plannedRows:
                                FinishWorkout.defaultPlannedSetsPerExercise,
                            extraRows: _extra[item.id] ?? 0,
                            drafts: _draftsFor(item.id),
                            anchor: _anchors.putIfAbsent(
                              item.id,
                              GlobalKey.new,
                            ),
                            onStepKg: (position, suggestion, direction) =>
                                _stepKg(
                                  item.id,
                                  position,
                                  suggestion,
                                  direction,
                                ),
                            onStepReps: (position, suggestion, direction) =>
                                _stepReps(
                                  item.id,
                                  position,
                                  suggestion,
                                  direction,
                                ),
                            onEdit: (position, field, suggestion) =>
                                _openPad(item.id, position, field, suggestion),
                            onSave: (position, suggestion) =>
                                _save(item.id, position, suggestion),
                            onToggleWarmup: (position, suggestion) =>
                                _toggleWarmup(item, position, suggestion),
                            onUndo: _undo,
                            onAddRow: () => _addRow(item.id),
                          ),
                        TextButton(
                          key: const Key('add-exercise'),
                          onPressed: _openAddExercise,
                          child: Text(l10n.addExercise),
                        ),
                      ],
                    ),
            ),
            if (_pad != null) _padKeys(spacing),
            if (restVisible) const RestTimerBar(),
            if (!keyboardOpen && _pad == null)
              Padding(
                padding: EdgeInsets.fromLTRB(
                  spacing.md,
                  spacing.sm,
                  spacing.md,
                  spacing.md,
                ),
                child: FilledButton(
                  key: const Key('finish-workout'),
                  onPressed: _notYet,
                  child: Text(l10n.finishWorkout),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _title(
    WorkoutSession? session,
    List<MuscleGroup> groups,
    AppLocalizations l10n,
  ) {
    if (session == null || session.muscleGroupIds.isEmpty) {
      return l10n.activeWorkoutTitle;
    }
    final names = <String>[];
    for (final id in session.muscleGroupIds) {
      for (final group in groups) {
        if (group.id == id) {
          names.add(
            catalogName(
              nameEn: group.nameEn,
              nameVi: group.nameVi,
              locale: Localizations.localeOf(context),
            ),
          );
        }
      }
    }
    if (names.isEmpty) return l10n.activeWorkoutTitle;
    return names.join(', ');
  }

  Exercise? _catalog(List<Exercise> catalog, int exerciseId) {
    for (final exercise in catalog) {
      if (exercise.id == exerciseId) return exercise;
    }
    return null;
  }

  Map<int, SetDraft> _draftsFor(int sessionExerciseId) {
    final drafts = <int, SetDraft>{};
    for (final entry in _drafts.entries) {
      final parts = entry.key.split(':');
      if (parts.length == 2 && parts.first == '$sessionExerciseId') {
        drafts[int.parse(parts.last)] = entry.value;
      }
    }
    return drafts;
  }

  void _scheduleScroll(WorkoutSession session) {
    if (_scrolled) return;
    int? latestExerciseId;
    var latestSetId = -1;
    for (final exercise in session.exercises) {
      for (final set in exercise.sets) {
        if (set.id > latestSetId) {
          latestSetId = set.id;
          latestExerciseId = exercise.id;
        }
      }
    }
    if (latestExerciseId == null || _scrollQueued) return;
    _scrollQueued = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollQueued = false;
      final target = _anchors[latestExerciseId]?.currentContext;
      if (!mounted || target == null || !target.mounted) return;
      _scrolled = true;
      Scrollable.ensureVisible(target);
    });
  }

  SetDraft _ensure(
    int sessionExerciseId,
    int position,
    SetLoadSuggestion suggestion,
  ) {
    return _drafts.putIfAbsent(
      '$sessionExerciseId:$position',
      () => SetDraft(kg: suggestion.kg, reps: suggestion.reps),
    );
  }

  void _stepKg(
    int sessionExerciseId,
    int position,
    SetLoadSuggestion suggestion,
    int direction,
  ) {
    final draft = _ensure(sessionExerciseId, position, suggestion);
    setState(() {
      draft.kg = _nextKg(draft.kg, direction);
      _pad = null;
    });
  }

  void _stepReps(
    int sessionExerciseId,
    int position,
    SetLoadSuggestion suggestion,
    int direction,
  ) {
    final draft = _ensure(sessionExerciseId, position, suggestion);
    setState(() {
      draft.reps = _nextReps(draft.reps, direction);
      _pad = null;
    });
  }

  double? _nextKg(double? current, int direction) {
    if (current == null && direction < 0) return null;
    final next = (current ?? 0) + direction * 2.5;
    if (next < 0) return 0;
    return next;
  }

  int? _nextReps(int? current, int direction) {
    if (current == null && direction < 0) return null;
    final next = (current ?? 0) + direction;
    if (next < 0) return 0;
    return next;
  }

  void _openPad(
    int sessionExerciseId,
    int position,
    LoadField field,
    SetLoadSuggestion suggestion,
  ) {
    final draft = _drafts['$sessionExerciseId:$position'];
    final kg = draft?.kg ?? suggestion.kg;
    final reps = draft?.reps ?? suggestion.reps;
    final text = field == LoadField.kg
        ? (kg == null ? '' : formatKg(kg, 'en'))
        : (reps == null ? '' : '$reps');
    setState(() {
      _pad = _Pad(
        sessionExerciseId: sessionExerciseId,
        position: position,
        field: field,
        text: text,
        suggestion: suggestion,
      );
    });
  }

  void _type(String key) {
    final pad = _pad;
    if (pad == null) return;
    final next = _append(pad.text, key, pad.field);
    if (next == pad.text) return;
    final draft = _ensure(pad.sessionExerciseId, pad.position, pad.suggestion);
    setState(() {
      pad.text = next;
      if (pad.field == LoadField.kg) {
        draft.kg = parseKg(next);
      } else {
        draft.reps = parseReps(next);
      }
    });
  }

  String _append(String text, String key, LoadField field) {
    if (key == 'backspace') {
      if (text.isEmpty) return text;
      return text.substring(0, text.length - 1);
    }
    if (key == '.') {
      if (field == LoadField.reps || text.contains('.')) return text;
      return text.isEmpty ? '0.' : '$text.';
    }
    return '$text$key';
  }

  Future<void> _save(
    int sessionExerciseId,
    int position,
    SetLoadSuggestion suggestion,
  ) async {
    final draft = _drafts['$sessionExerciseId:$position'];
    final kg = draft?.kg ?? suggestion.kg;
    final repsRaw = draft?.reps ?? suggestion.reps;
    final reps = repsRaw == null || repsRaw < 1 ? null : repsRaw;
    if (kg == null && reps == null) return;
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _pad = null);
    await ref
        .read(activeWorkoutCommandsProvider.notifier)
        .logSet(
          sessionExerciseId: sessionExerciseId,
          isWarmup: draft?.isWarmup ?? false,
          kg: kg,
          reps: reps,
        );
    if (!mounted) return;
    setState(() => _drafts.remove('$sessionExerciseId:$position'));
  }

  Future<void> _toggleWarmup(
    SessionExercise item,
    int position,
    SetLoadSuggestion suggestion,
  ) async {
    final saved = _setAt(item.sets, position);
    if (saved != null) {
      await ref
          .read(activeWorkoutCommandsProvider.notifier)
          .updateSet(
            setId: saved.id,
            isWarmup: !saved.isWarmup,
            kg: saved.kg,
            reps: saved.reps,
          );
      return;
    }
    final draft = _ensure(item.id, position, suggestion);
    setState(() => draft.isWarmup = !draft.isWarmup);
  }

  Future<void> _undo(SetLog set) async {
    await ref
        .read(activeWorkoutCommandsProvider.notifier)
        .deleteSet(setId: set.id);
  }

  void _addRow(int sessionExerciseId) {
    setState(
      () => _extra[sessionExerciseId] = (_extra[sessionExerciseId] ?? 0) + 1,
    );
  }

  Future<void> _openAddExercise() {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const AddExerciseSheet(),
    );
  }

  Widget _padKeys(KebapSpacing spacing) {
    final locale = Localizations.localeOf(context).languageCode;
    final decimal = locale == 'vi' ? ',' : '.';
    final keys = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      decimal,
      '0',
      '⌫',
    ];
    return Padding(
      padding: EdgeInsets.all(spacing.sm),
      child: Wrap(
        spacing: spacing.xs,
        runSpacing: spacing.xs,
        children: [
          for (final key in keys)
            SizedBox(
              width: spacing.touch,
              height: spacing.touch,
              child: OutlinedButton(
                key: Key(
                  key == decimal
                      ? 'pad-decimal'
                      : key == '⌫'
                      ? 'pad-backspace'
                      : 'pad-$key',
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(spacing.touch, spacing.touch),
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () => _type(
                  key == decimal
                      ? '.'
                      : key == '⌫'
                      ? 'backspace'
                      : key,
                ),
                child: Text(key),
              ),
            ),
        ],
      ),
    );
  }

  SetLog? _setAt(List<SetLog> sets, int position) {
    for (final set in sets) {
      if (set.position == position) return set;
    }
    return null;
  }

  /// Task 11 owns discard and finish.
  void _notYet() {}
}
