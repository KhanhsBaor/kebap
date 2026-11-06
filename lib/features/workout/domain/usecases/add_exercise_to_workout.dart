import 'package:kebap/features/catalog/domain/repositories/exercise_repository.dart';
import 'package:kebap/features/workout/domain/entities/session_exercise.dart';
import 'package:kebap/features/workout/domain/failures/workout_rule_exception.dart';
import 'package:kebap/features/workout/domain/repositories/workout_repository.dart';
import 'package:kebap/features/workout/domain/usecases/workout_lookup.dart';

class AddExerciseToWorkout {
  const AddExerciseToWorkout({
    required WorkoutRepository workoutRepository,
    required ExerciseRepository exerciseRepository,
  }) : _workouts = workoutRepository,
       _exercises = exerciseRepository;

  final WorkoutRepository _workouts;
  final ExerciseRepository _exercises;

  Future<SessionExercise> call({
    required int workoutId,
    required int exerciseId,
  }) async {
    final workout = await requireInProgressWorkout(_workouts, workoutId);
    final exercise = await _exercises.findById(exerciseId);
    if (exercise == null) {
      throw const ExerciseNotFound();
    }
    if (!workout.muscleGroupIds.contains(exercise.muscleGroupId)) {
      throw const MuscleGroupNotOnWorkout();
    }
    return _workouts.addExercise(workoutId: workoutId, exerciseId: exerciseId);
  }
}
