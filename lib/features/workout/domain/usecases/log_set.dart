import 'package:kebap/features/workout/domain/entities/set_log.dart';
import 'package:kebap/features/workout/domain/repositories/workout_repository.dart';
import 'package:kebap/features/workout/domain/usecases/set_load.dart';
import 'package:kebap/features/workout/domain/usecases/workout_lookup.dart';

class LogSet {
  const LogSet({required WorkoutRepository workoutRepository})
    : _workouts = workoutRepository;

  final WorkoutRepository _workouts;

  Future<SetLog> call({
    required int workoutId,
    required int sessionExerciseId,
    required bool isWarmup,
    required DateTime savedAt,
    double? kg,
    int? reps,
  }) async {
    requireValidSetLoad(kg: kg, reps: reps);
    final workout = await requireInProgressWorkout(_workouts, workoutId);
    final exercise = requireSessionExercise(workout, sessionExerciseId);
    var position = 1;
    for (final set in exercise.sets) {
      if (set.position >= position) {
        position = set.position + 1;
      }
    }
    return _workouts.insertSet(
      sessionExerciseId: sessionExerciseId,
      position: position,
      isWarmup: isWarmup,
      kg: kg,
      reps: reps,
      savedAt: savedAt,
    );
  }
}
