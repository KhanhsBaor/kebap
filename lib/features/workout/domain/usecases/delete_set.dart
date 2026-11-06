import 'package:kebap/features/workout/domain/repositories/workout_repository.dart';
import 'package:kebap/features/workout/domain/usecases/workout_lookup.dart';

class DeleteSet {
  const DeleteSet({required WorkoutRepository workoutRepository})
    : _workouts = workoutRepository;

  final WorkoutRepository _workouts;

  /// Removes the set and renumbers the remaining sets of that exercise
  /// from 1, keeping their previous order. Other exercises are left alone.
  Future<void> call({required int workoutId, required int setId}) async {
    final workout = await requireInProgressWorkout(_workouts, workoutId);
    final owner = requireExerciseOwningSet(workout, setId);
    final remaining = [...owner.sets.where((set) => set.id != setId)]
      ..sort((a, b) => a.position.compareTo(b.position));
    final positions = <int, int>{
      for (var index = 0; index < remaining.length; index++)
        remaining[index].id: index + 1,
    };
    await _workouts.deleteSet(id: setId, positions: positions);
  }
}
