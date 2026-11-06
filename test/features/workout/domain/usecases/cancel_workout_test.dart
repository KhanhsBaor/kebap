import 'package:flutter_test/flutter_test.dart';
import 'package:kebap/features/workout/domain/entities/workout_status.dart';
import 'package:kebap/features/workout/domain/failures/workout_rule_exception.dart';
import 'package:kebap/features/workout/domain/usecases/cancel_workout.dart';
import 'package:mocktail/mocktail.dart';

import '../support/mock_repositories.dart';
import '../support/workout_fixtures.dart';

void main() {
  late MockWorkoutRepository workouts;
  late CancelWorkout useCase;

  setUp(() {
    workouts = MockWorkoutRepository();
    useCase = CancelWorkout(workoutRepository: workouts);
    when(() => workouts.deleteWorkout(any())).thenAnswer((_) async {});
  });

  test('deletes an in-progress workout that already has sets', () async {
    when(() => workouts.findById(1)).thenAnswer(
      (_) async => workoutSession(
        exercises: [
          sessionExercise(sets: [setLog(id: 1, position: 1)]),
        ],
      ),
    );

    await useCase.call(workoutId: 1);

    verify(() => workouts.deleteWorkout(1)).called(1);
  });

  test('deletes an in-progress workout that has no sets', () async {
    when(() => workouts.findById(1)).thenAnswer((_) async => workoutSession());

    await useCase.call(workoutId: 1);

    verify(() => workouts.deleteWorkout(1)).called(1);
  });

  test('throws when the workout does not exist and does not delete', () async {
    when(() => workouts.findById(1)).thenAnswer((_) async => null);

    await expectLater(
      useCase.call(workoutId: 1),
      throwsA(isA<WorkoutNotFound>()),
    );
    verifyNever(() => workouts.deleteWorkout(any()));
  });

  test('throws when the workout is completed and does not delete', () async {
    when(
      () => workouts.findById(1),
    ).thenAnswer((_) async => workoutSession(status: WorkoutStatus.completed));

    await expectLater(
      useCase.call(workoutId: 1),
      throwsA(isA<WorkoutNotInProgress>()),
    );
    verifyNever(() => workouts.deleteWorkout(any()));
  });
}
