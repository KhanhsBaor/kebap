import 'package:kebap/features/workout/data/providers/workout_repository_providers.dart';
import 'package:kebap/features/workout/domain/entities/workout_session.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'active_workout.g.dart';

/// The in-progress session, or null. Groups, exercises, and saved sets
/// come from the workout repository watch.
@riverpod
Stream<WorkoutSession?> activeWorkout(Ref ref) {
  return ref.watch(workoutRepositoryProvider).watchInProgress();
}
