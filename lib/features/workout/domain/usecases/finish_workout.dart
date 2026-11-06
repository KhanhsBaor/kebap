import 'package:kebap/features/workout/domain/entities/workout_session.dart';
import 'package:kebap/features/workout/domain/failures/workout_rule_exception.dart';
import 'package:kebap/features/workout/domain/repositories/workout_repository.dart';
import 'package:kebap/features/workout/domain/usecases/workout_lookup.dart';

sealed class FinishWorkoutResult {
  const FinishWorkoutResult();
}

final class FinishWorkoutNeedsConfirmation extends FinishWorkoutResult {
  const FinishWorkoutNeedsConfirmation({
    required this.unloggedSetCount,
    required this.exerciseCount,
  });

  final int unloggedSetCount;
  final int exerciseCount;
}

final class FinishWorkoutCompleted extends FinishWorkoutResult {
  const FinishWorkoutCompleted(this.session);

  final WorkoutSession session;
}

class FinishWorkout {
  const FinishWorkout({required WorkoutRepository workoutRepository})
    : _workouts = workoutRepository;

  final WorkoutRepository _workouts;

  /// Planned sets per exercise when the caller omits that exercise.
  /// M2 has no training-goal profile yet (docs/06: 3 sets).
  static const defaultPlannedSetsPerExercise = 3;

  /// [plannedSetsByExercise] is keyed by session exercise id.
  /// It is how many set rows count as the plan for this tap. Unknown keys
  /// are ignored. A missing key uses [defaultPlannedSetsPerExercise].
  ///
  /// A row the user has started typing and has not saved counts as unlogged
  /// (`docs/06` mục 5) and is not written here. Include that row in the
  /// exercise's count (saved sets + 1). Leave an empty placeholder past the
  /// goal out of the count, so a finished plan can end immediately.
  Future<FinishWorkoutResult> call({
    required int workoutId,
    required DateTime endedAt,
    required Map<int, int> plannedSetsByExercise,
    required bool confirmSkipRemaining,
  }) async {
    final workout = await requireInProgressWorkout(_workouts, workoutId);
    for (final exercise in workout.exercises) {
      final planned = plannedSetsByExercise[exercise.id];
      if (planned != null && planned < 0) {
        throw const InvalidPlannedSetCount();
      }
    }

    final savedCount = workout.exercises.fold<int>(
      0,
      (sum, exercise) => sum + exercise.sets.length,
    );
    if (savedCount == 0) {
      throw const WorkoutHasNoSavedSets();
    }

    var unloggedSetCount = 0;
    var exerciseCount = 0;
    for (final exercise in workout.exercises) {
      final planned =
          plannedSetsByExercise[exercise.id] ?? defaultPlannedSetsPerExercise;
      final remaining = planned - exercise.sets.length;
      if (remaining > 0) {
        unloggedSetCount += remaining;
        exerciseCount += 1;
      }
    }
    if (unloggedSetCount > 0 && !confirmSkipRemaining) {
      return FinishWorkoutNeedsConfirmation(
        unloggedSetCount: unloggedSetCount,
        exerciseCount: exerciseCount,
      );
    }

    final dropSessionExerciseIds = [
      for (final exercise in workout.exercises)
        if (exercise.sets.isEmpty) exercise.id,
    ];
    final completed = await _workouts.complete(
      id: workoutId,
      endedAt: endedAt,
      dropSessionExerciseIds: dropSessionExerciseIds,
    );
    return FinishWorkoutCompleted(completed);
  }
}
