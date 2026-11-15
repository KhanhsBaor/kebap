import 'package:kebap/features/catalog/domain/repositories/exercise_repository.dart';
import 'package:kebap/features/catalog/domain/repositories/muscle_group_repository.dart';
import 'package:kebap/features/workout/domain/repositories/workout_repository.dart';
import 'package:kebap/features/workout/domain/repositories/workout_transaction_runner.dart';
import 'package:mocktail/mocktail.dart';

class MockWorkoutRepository extends Mock implements WorkoutRepository {}

class MockExerciseRepository extends Mock implements ExerciseRepository {}

class MockMuscleGroupRepository extends Mock implements MuscleGroupRepository {}

/// Runs the action immediately. Unit tests do not need a real DB transaction.
class PassthroughTransactionRunner implements WorkoutTransactionRunner {
  const PassthroughTransactionRunner();

  @override
  Future<T> run<T>(Future<T> Function() action) => action();
}

void registerWorkoutFallbacks() {
  registerFallbackValue(<int>[]);
  registerFallbackValue(<int, int>{});
}
