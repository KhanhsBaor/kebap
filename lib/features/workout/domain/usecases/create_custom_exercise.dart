import 'package:kebap/features/catalog/domain/entities/exercise.dart';
import 'package:kebap/features/catalog/domain/repositories/exercise_repository.dart';
import 'package:kebap/features/workout/domain/entities/session_exercise.dart';
import 'package:kebap/features/workout/domain/failures/workout_rule_exception.dart';
import 'package:kebap/features/workout/domain/repositories/workout_repository.dart';
import 'package:kebap/features/workout/domain/repositories/workout_transaction_runner.dart';
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

/// Creates a custom exercise and appends it to the in-progress workout
/// in one transaction so a failed append leaves no orphan catalog row.
class CreateCustomExercise {
  const CreateCustomExercise({
    required WorkoutRepository workoutRepository,
    required ExerciseRepository exerciseRepository,
    required WorkoutTransactionRunner transactionRunner,
  }) : _workouts = workoutRepository,
       _exercises = exerciseRepository,
       _transactions = transactionRunner;

  final WorkoutRepository _workouts;
  final ExerciseRepository _exercises;
  final WorkoutTransactionRunner _transactions;

  Future<CreateCustomExerciseResult> call({
    required int workoutId,
    required String name,
    required int muscleGroupId,
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw const InvalidExerciseName();
    }

    return _transactions.run(() async {
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
    });
  }
}
