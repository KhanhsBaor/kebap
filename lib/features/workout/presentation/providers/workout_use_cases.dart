import 'package:kebap/features/catalog/data/providers/catalog_repository_providers.dart';
import 'package:kebap/features/workout/data/providers/workout_repository_providers.dart';
import 'package:kebap/features/workout/domain/usecases/add_exercise_to_workout.dart';
import 'package:kebap/features/workout/domain/usecases/cancel_workout.dart';
import 'package:kebap/features/workout/domain/usecases/create_custom_exercise.dart';
import 'package:kebap/features/workout/domain/usecases/delete_set.dart';
import 'package:kebap/features/workout/domain/usecases/finish_workout.dart';
import 'package:kebap/features/workout/domain/usecases/log_set.dart';
import 'package:kebap/features/workout/domain/usecases/start_workout.dart';
import 'package:kebap/features/workout/domain/usecases/update_set.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'workout_use_cases.g.dart';

@riverpod
StartWorkout startWorkout(Ref ref) {
  return StartWorkout(
    workoutRepository: ref.watch(workoutRepositoryProvider),
    muscleGroupRepository: ref.watch(muscleGroupRepositoryProvider),
  );
}

@riverpod
AddExerciseToWorkout addExerciseToWorkout(Ref ref) {
  return AddExerciseToWorkout(
    workoutRepository: ref.watch(workoutRepositoryProvider),
    exerciseRepository: ref.watch(exerciseRepositoryProvider),
  );
}

@riverpod
CreateCustomExercise createCustomExercise(Ref ref) {
  return CreateCustomExercise(
    workoutRepository: ref.watch(workoutRepositoryProvider),
    exerciseRepository: ref.watch(exerciseRepositoryProvider),
    transactionRunner: ref.watch(workoutTransactionRunnerProvider),
  );
}

@riverpod
LogSet logSet(Ref ref) {
  return LogSet(workoutRepository: ref.watch(workoutRepositoryProvider));
}

@riverpod
UpdateSet updateSet(Ref ref) {
  return UpdateSet(workoutRepository: ref.watch(workoutRepositoryProvider));
}

@riverpod
DeleteSet deleteSet(Ref ref) {
  return DeleteSet(workoutRepository: ref.watch(workoutRepositoryProvider));
}

@riverpod
FinishWorkout finishWorkout(Ref ref) {
  return FinishWorkout(workoutRepository: ref.watch(workoutRepositoryProvider));
}

@riverpod
CancelWorkout cancelWorkout(Ref ref) {
  return CancelWorkout(workoutRepository: ref.watch(workoutRepositoryProvider));
}
