import 'package:kebap/features/workout/domain/entities/session_exercise.dart';
import 'package:kebap/features/workout/domain/entities/workout_session.dart';
import 'package:kebap/features/workout/domain/entities/workout_status.dart';
import 'package:kebap/features/workout/domain/failures/workout_rule_exception.dart';
import 'package:kebap/features/workout/domain/repositories/workout_repository.dart';

Future<WorkoutSession> requireInProgressWorkout(
  WorkoutRepository repository,
  int workoutId,
) async {
  final workout = await repository.findById(workoutId);
  if (workout == null) {
    throw const WorkoutNotFound();
  }
  if (workout.status != WorkoutStatus.inProgress) {
    throw const WorkoutNotInProgress();
  }
  return workout;
}

SessionExercise requireSessionExercise(
  WorkoutSession workout,
  int sessionExerciseId,
) {
  for (final exercise in workout.exercises) {
    if (exercise.id == sessionExerciseId) {
      return exercise;
    }
  }
  throw const SessionExerciseNotFound();
}

SessionExercise requireExerciseOwningSet(WorkoutSession workout, int setId) {
  for (final exercise in workout.exercises) {
    for (final set in exercise.sets) {
      if (set.id == setId) {
        return exercise;
      }
    }
  }
  throw const SetNotFound();
}
