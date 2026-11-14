import 'package:kebap/features/catalog/data/providers/catalog_repository_providers.dart';
import 'package:kebap/features/catalog/domain/entities/exercise.dart';
import 'package:kebap/features/workout/presentation/providers/active_workout.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'active_workout_exercises.g.dart';

/// Catalog exercises for the muscle groups on the open session.
@riverpod
Stream<List<Exercise>> activeWorkoutExercises(Ref ref) {
  final session = ref.watch(activeWorkoutProvider).asData?.value;
  if (session == null || session.muscleGroupIds.isEmpty) {
    return Stream.value(const []);
  }
  return ref
      .watch(exerciseRepositoryProvider)
      .watchByMuscleGroupIds(session.muscleGroupIds.toSet());
}
