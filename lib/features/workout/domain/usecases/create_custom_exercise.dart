import 'package:kebap/features/catalog/domain/entities/exercise.dart';
import 'package:kebap/features/catalog/domain/repositories/exercise_repository.dart';
import 'package:kebap/features/workout/domain/entities/session_exercise.dart';
import 'package:kebap/features/workout/domain/failures/workout_rule_exception.dart';
import 'package:kebap/features/workout/domain/repositories/workout_repository.dart';
import 'package:kebap/features/workout/domain/usecases/workout_lookup.dart';

sealed class CreateCustomExerciseResult {
  const CreateCustomExerciseResult();
}

final class CustomExerciseCreated extends CreateCustomExerciseResult {
  const CustomExerciseCreated({
    required this.exercise,
    required this.sessionExercise,
  });

  final Exercise exercise;
  final SessionExercise sessionExercise;
}

final class CustomExerciseDuplicate extends CreateCustomExerciseResult {
  const CustomExerciseDuplicate(this.exercise);

  final Exercise exercise;
}

/// Creates a custom exercise and appends it to the in-progress workout.
///
/// The catalog insert and the workout append are separate calls today.
/// The Drift implementation (task 4) must run them in one transaction:
/// a failed append would leave a name that the next attempt reports as
/// a duplicate and does not add.
class CreateCustomExercise {
  const CreateCustomExercise({
    required WorkoutRepository workoutRepository,
    required ExerciseRepository exerciseRepository,
  }) : _workouts = workoutRepository,
       _exercises = exerciseRepository;

  final WorkoutRepository _workouts;
  final ExerciseRepository _exercises;

  Future<CreateCustomExerciseResult> call({
    required int workoutId,
    required String name,
    required int muscleGroupId,
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw const InvalidExerciseName();
    }

    final workout = await requireInProgressWorkout(_workouts, workoutId);
    if (!workout.muscleGroupIds.contains(muscleGroupId)) {
      throw const MuscleGroupNotOnWorkout();
    }

    final existing = await _exercises.findByNameInGroup(
      muscleGroupId: muscleGroupId,
      name: trimmed,
    );
    if (existing != null) {
      return CustomExerciseDuplicate(existing);
    }

    final created = await _exercises.insert(
      muscleGroupId: muscleGroupId,
      nameEn: trimmed,
      isCustom: true,
    );
    final sessionExercise = await _workouts.addExercise(
      workoutId: workoutId,
      exerciseId: created.id,
    );
    return CustomExerciseCreated(
      exercise: created,
      sessionExercise: sessionExercise,
    );
  }
}
