import 'package:kebap/features/workout/domain/entities/set_log.dart';
import 'package:kebap/features/workout/domain/repositories/workout_repository.dart';
import 'package:kebap/features/workout/domain/usecases/set_load.dart';
import 'package:kebap/features/workout/domain/usecases/workout_lookup.dart';

class UpdateSet {
  const UpdateSet({required WorkoutRepository workoutRepository})
    : _workouts = workoutRepository;

  final WorkoutRepository _workouts;

  /// Rewrites kg, reps, and warmup. The saved position stays as it is.
  Future<SetLog> call({
    required int workoutId,
    required int setId,
    required bool isWarmup,
    double? kg,
    int? reps,
  }) async {
    requireValidSetLoad(kg: kg, reps: reps);
    final workout = await requireInProgressWorkout(_workouts, workoutId);
    requireExerciseOwningSet(workout, setId);
    return _workouts.updateSet(
      id: setId,
      isWarmup: isWarmup,
      kg: kg,
      reps: reps,
    );
  }
}
