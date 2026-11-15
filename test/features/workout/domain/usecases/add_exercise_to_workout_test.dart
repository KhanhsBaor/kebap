import 'package:flutter_test/flutter_test.dart';
import 'package:kebap/features/workout/domain/entities/workout_status.dart';
import 'package:kebap/features/workout/domain/failures/workout_rule_exception.dart';
import 'package:kebap/features/workout/domain/usecases/add_exercise_to_workout.dart';
import 'package:mocktail/mocktail.dart';

import '../support/mock_repositories.dart';
import '../support/workout_fixtures.dart';

void main() {
  late MockWorkoutRepository workouts;
  late MockExerciseRepository exercises;
  late AddExerciseToWorkout useCase;

  setUpAll(registerWorkoutFallbacks);

  setUp(() {
    workouts = MockWorkoutRepository();
    exercises = MockExerciseRepository();
    useCase = AddExerciseToWorkout(
      workoutRepository: workouts,
      exerciseRepository: exercises,
    );
  });

  test('adds an exercise whose muscle group is on the workout', () async {
    final added = sessionExercise();
    when(() => workouts.findById(1)).thenAnswer((_) async => workoutSession());
    when(
      () => exercises.findById(benchId),
    ).thenAnswer((_) async => catalogExercise());
    when(
      () => workouts.addExercise(workoutId: 1, exerciseId: benchId),
    ).thenAnswer((_) async => added);

    final result = await useCase.call(workoutId: 1, exerciseId: benchId);

    expect(result, same(added));
    verify(
      () => workouts.addExercise(workoutId: 1, exerciseId: benchId),
    ).called(1);
  });

  test('adds the same exercise a second time', () async {
    when(() => workouts.findById(1)).thenAnswer((_) async => workoutSession());
    when(
      () => exercises.findById(benchId),
    ).thenAnswer((_) async => catalogExercise());
    when(
      () => workouts.addExercise(workoutId: 1, exerciseId: benchId),
    ).thenAnswer((_) async => sessionExercise());

    await useCase.call(workoutId: 1, exerciseId: benchId);
    await useCase.call(workoutId: 1, exerciseId: benchId);

    verify(
      () => workouts.addExercise(workoutId: 1, exerciseId: benchId),
    ).called(2);
  });

  test('throws when the workout does not exist', () async {
    when(() => workouts.findById(1)).thenAnswer((_) async => null);

    await expectLater(
      useCase.call(workoutId: 1, exerciseId: benchId),
      throwsA(isA<WorkoutNotFound>()),
    );
    verifyNever(
      () => workouts.addExercise(
        workoutId: any(named: 'workoutId'),
        exerciseId: any(named: 'exerciseId'),
      ),
    );
  });

  test('throws when the workout is not in progress', () async {
    when(
      () => workouts.findById(1),
    ).thenAnswer((_) async => workoutSession(status: WorkoutStatus.completed));

    await expectLater(
      useCase.call(workoutId: 1, exerciseId: benchId),
      throwsA(isA<WorkoutNotInProgress>()),
    );
    verifyNever(
      () => workouts.addExercise(
        workoutId: any(named: 'workoutId'),
        exerciseId: any(named: 'exerciseId'),
      ),
    );
  });

  test('throws when the exercise does not exist', () async {
    when(() => workouts.findById(1)).thenAnswer((_) async => workoutSession());
    when(() => exercises.findById(benchId)).thenAnswer((_) async => null);

    await expectLater(
      useCase.call(workoutId: 1, exerciseId: benchId),
      throwsA(isA<ExerciseNotFound>()),
    );
    verifyNever(
      () => workouts.addExercise(
        workoutId: any(named: 'workoutId'),
        exerciseId: any(named: 'exerciseId'),
      ),
    );
  });

  test('throws when the exercise is outside the workout groups', () async {
    when(() => workouts.findById(1)).thenAnswer((_) async => workoutSession());
    when(() => exercises.findById(squatId)).thenAnswer(
      (_) async => catalogExercise(id: squatId, muscleGroupId: quadricepsId),
    );

    await expectLater(
      useCase.call(workoutId: 1, exerciseId: squatId),
      throwsA(isA<MuscleGroupNotOnWorkout>()),
    );
    verifyNever(
      () => workouts.addExercise(
        workoutId: any(named: 'workoutId'),
        exerciseId: any(named: 'exerciseId'),
      ),
    );
  });
}
