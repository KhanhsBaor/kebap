import 'package:kebap/features/catalog/domain/repositories/exercise_repository.dart';
import 'package:kebap/features/catalog/domain/repositories/muscle_group_repository.dart';
import 'package:kebap/features/workout/domain/repositories/workout_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockWorkoutRepository extends Mock implements WorkoutRepository {}

class MockExerciseRepository extends Mock implements ExerciseRepository {}

class MockMuscleGroupRepository extends Mock implements MuscleGroupRepository {}

void registerWorkoutFallbacks() {
  registerFallbackValue(<int>[]);
  registerFallbackValue(<int, int>{});
}
