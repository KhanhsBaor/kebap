import 'package:kebap/features/workout/domain/entities/workout_session.dart';
import 'package:kebap/features/workout/domain/failures/workout_rule_exception.dart';
import 'package:kebap/features/workout/domain/usecases/create_custom_exercise.dart';
import 'package:kebap/features/workout/domain/usecases/finish_workout.dart';
import 'package:kebap/features/workout/presentation/notices/active_workout_notice.dart';
import 'package:kebap/features/workout/presentation/providers/active_workout.dart';
import 'package:kebap/features/workout/presentation/providers/rest_timer_notifier.dart';
import 'package:kebap/features/workout/presentation/providers/workout_use_cases.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'active_workout_notifier.g.dart';

/// Session commands. Each method calls one use case and stores a notice
/// when the screen has to ask or explain.
///
/// [requestFinish] / [confirmFinish] take [plannedSetsByExercise] keyed by
/// session exercise id. Omit a key to use
/// [FinishWorkout.defaultPlannedSetsPerExercise]. For an unsaved draft row
/// (`docs/06` mục 5), pass saved count + 1 for that exercise so the confirm
/// dialog counts it; the draft itself is not written here.
@riverpod
class ActiveWorkoutCommands extends _$ActiveWorkoutCommands {
  @override
  ActiveWorkoutNotice? build() {
    // Keep the session stream hot while commands are watched, without
    // rebuilding this notifier (a watch would wipe notices on every emit).
    ref.listen(activeWorkoutProvider, (_, _) {});
    return null;
  }

  void clearNotice() => state = null;

  Future<void> startWorkout({
    required int regionId,
    required List<int> muscleGroupIds,
  }) {
    return _run(() async {
      await ref
          .read(startWorkoutProvider)
          .call(
            regionId: regionId,
            muscleGroupIds: muscleGroupIds,
            startedAt: DateTime.now(),
          );
    });
  }

  Future<void> addExercise({required int exerciseId}) {
    return _run(() async {
      final session = _session();
      if (session == null) return;
      await ref
          .read(addExerciseToWorkoutProvider)
          .call(workoutId: session.id, exerciseId: exerciseId);
    });
  }

  Future<void> createCustomExercise({
    required String name,
    required int muscleGroupId,
  }) async {
    final session = _session();
    if (session == null) return;
    try {
      final result = await ref
          .read(createCustomExerciseProvider)
          .call(
            workoutId: session.id,
            name: name,
            muscleGroupId: muscleGroupId,
          );
      if (!ref.mounted) return;
      switch (result) {
        case CustomExerciseCreated():
          state = null;
        case CustomExerciseDuplicate(:final exercise):
          state = ActiveWorkoutDuplicateName(exercise);
      }
    } on WorkoutRuleException catch (error) {
      if (!ref.mounted) return;
      state = ActiveWorkoutRejected(error);
    }
  }

  Future<void> logSet({
    required int sessionExerciseId,
    bool isWarmup = false,
    double? kg,
    int? reps,
  }) {
    return _run(() async {
      final session = _session();
      if (session == null) return;
      await ref
          .read(logSetProvider)
          .call(
            workoutId: session.id,
            sessionExerciseId: sessionExerciseId,
            isWarmup: isWarmup,
            kg: kg,
            reps: reps,
          );
      if (!ref.mounted) return;
      ref.read(restTimerProvider.notifier).start();
    });
  }

  Future<void> updateSet({
    required int setId,
    required bool isWarmup,
    double? kg,
    int? reps,
  }) {
    return _run(() async {
      final session = _session();
      if (session == null) return;
      await ref
          .read(updateSetProvider)
          .call(
            workoutId: session.id,
            setId: setId,
            isWarmup: isWarmup,
            kg: kg,
            reps: reps,
          );
    });
  }

  Future<void> deleteSet({required int setId}) {
    return _run(() async {
      final session = _session();
      if (session == null) return;
      await ref
          .read(deleteSetProvider)
          .call(workoutId: session.id, setId: setId);
    });
  }

  Future<void> requestFinish({
    Map<int, int> plannedSetsByExercise = const {},
  }) => _finish(
    confirmSkipRemaining: false,
    plannedSetsByExercise: plannedSetsByExercise,
  );

  Future<void> confirmFinish({
    Map<int, int> plannedSetsByExercise = const {},
  }) => _finish(
    confirmSkipRemaining: true,
    plannedSetsByExercise: plannedSetsByExercise,
  );

  Future<void> cancelWorkout() {
    return _run(() async {
      final session = _session();
      if (session == null) return;
      await ref.read(cancelWorkoutProvider).call(workoutId: session.id);
      if (!ref.mounted) return;
      ref.read(restTimerProvider.notifier).dismiss();
    });
  }

  Future<void> _finish({
    required bool confirmSkipRemaining,
    required Map<int, int> plannedSetsByExercise,
  }) async {
    final session = _session();
    if (session == null) return;
    try {
      final result = await ref
          .read(finishWorkoutProvider)
          .call(
            workoutId: session.id,
            endedAt: DateTime.now(),
            plannedSetsByExercise: plannedSetsByExercise,
            confirmSkipRemaining: confirmSkipRemaining,
          );
      if (!ref.mounted) return;
      switch (result) {
        case FinishWorkoutNeedsConfirmation(
          :final unloggedSetCount,
          :final exerciseCount,
        ):
          state = ActiveWorkoutNeedsConfirmation(
            unloggedSetCount: unloggedSetCount,
            exerciseCount: exerciseCount,
          );
        case FinishWorkoutCompleted():
          state = null;
          ref.read(restTimerProvider.notifier).dismiss();
      }
    } on WorkoutHasNoSavedSets {
      if (!ref.mounted) return;
      state = const ActiveWorkoutNoSavedSets();
    } on WorkoutRuleException catch (error) {
      if (!ref.mounted) return;
      state = ActiveWorkoutRejected(error);
    }
  }

  /// Latest session from the stream. Null becomes [WorkoutNotInProgress].
  WorkoutSession? _session() {
    final session = ref.read(activeWorkoutProvider).asData?.value;
    if (session == null) {
      state = const ActiveWorkoutRejected(WorkoutNotInProgress());
    }
    return session;
  }

  Future<void> _run(Future<void> Function() action) async {
    try {
      await action();
      if (!ref.mounted || state is ActiveWorkoutRejected) return;
      state = null;
    } on WorkoutRuleException catch (error) {
      if (!ref.mounted) return;
      state = ActiveWorkoutRejected(error);
    }
  }
}
