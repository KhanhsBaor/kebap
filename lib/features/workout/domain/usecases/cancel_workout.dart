import 'package:kebap/features/workout/domain/repositories/workout_repository.dart';
import 'package:kebap/features/workout/domain/usecases/workout_lookup.dart';

class CancelWorkout {
  const CancelWorkout({required WorkoutRepository workoutRepository})
    : _workouts = workoutRepository;

  final WorkoutRepository _workouts;

  /// Hard-deletes the in-progress session and its sets.
  /// Asking before a session that already has sets is a UI step.
  Future<void> call({required int workoutId}) async {
    await requireInProgressWorkout(_workouts, workoutId);
    await _workouts.deleteWorkout(workoutId);
  }
}
