import 'package:flutter_test/flutter_test.dart';
import 'package:kebap/features/workout/domain/entities/workout_status.dart';
import 'package:kebap/features/workout/domain/failures/workout_rule_exception.dart';
import 'package:kebap/features/workout/domain/usecases/log_set.dart';
import 'package:mocktail/mocktail.dart';

import '../support/mock_repositories.dart';
import '../support/workout_fixtures.dart';

void main() {
  late MockWorkoutRepository workouts;
  late LogSet useCase;
  final savedAt = DateTime.utc(2026, 11, 15, 9);

  setUpAll(registerWorkoutFallbacks);

  setUp(() {
    workouts = MockWorkoutRepository();
    useCase = LogSet(workoutRepository: workouts);
    when(
      () => workouts.insertSet(
        sessionExerciseId: any(named: 'sessionExerciseId'),
        position: any(named: 'position'),
        isWarmup: any(named: 'isWarmup'),
        kg: any(named: 'kg'),
        reps: any(named: 'reps'),
        savedAt: any(named: 'savedAt'),
      ),
    ).thenAnswer((_) async => setLog(id: 1, position: 1, kg: null, reps: null));
  });

  test('assigns position 1 when the exercise has no sets', () async {
    when(
      () => workouts.findById(1),
    ).thenAnswer((_) async => workoutSession(exercises: [sessionExercise()]));

    await useCase.call(
      workoutId: 1,
      sessionExerciseId: 100,
      isWarmup: false,
      savedAt: savedAt,
      kg: 60,
      reps: 10,
    );

    verify(
      () => workouts.insertSet(
        sessionExerciseId: 100,
        position: 1,
        isWarmup: false,
        kg: 60,
        reps: 10,
        savedAt: savedAt,
      ),
    ).called(1);
  });

  test('assigns one past the highest position, including gaps', () async {
    when(() => workouts.findById(1)).thenAnswer(
      (_) async => workoutSession(
        exercises: [
          sessionExercise(
            sets: [setLog(id: 1, position: 1), setLog(id: 2, position: 4)],
          ),
        ],
      ),
    );

    await useCase.call(
      workoutId: 1,
      sessionExerciseId: 100,
      isWarmup: false,
      savedAt: savedAt,
      kg: 62.5,
      reps: 8,
    );

    verify(
      () => workouts.insertSet(
        sessionExerciseId: 100,
        position: 5,
        isWarmup: false,
        kg: 62.5,
        reps: 8,
        savedAt: savedAt,
      ),
    ).called(1);
  });

  test('throws when kg and reps are both empty and does not insert', () async {
    await expectLater(
      useCase.call(
        workoutId: 1,
        sessionExerciseId: 100,
        isWarmup: true,
        savedAt: savedAt,
      ),
      throwsA(isA<InvalidSetValue>()),
    );
    verifyNever(
      () => workouts.insertSet(
        sessionExerciseId: any(named: 'sessionExerciseId'),
        position: any(named: 'position'),
        isWarmup: any(named: 'isWarmup'),
        kg: any(named: 'kg'),
        reps: any(named: 'reps'),
        savedAt: any(named: 'savedAt'),
      ),
    );
  });

  test('stores a bodyweight set at kg 0', () async {
    when(
      () => workouts.findById(1),
    ).thenAnswer((_) async => workoutSession(exercises: [sessionExercise()]));

    await useCase.call(
      workoutId: 1,
      sessionExerciseId: 100,
      isWarmup: false,
      savedAt: savedAt,
      kg: 0,
      reps: 12,
    );

    verify(
      () => workouts.insertSet(
        sessionExerciseId: 100,
        position: 1,
        isWarmup: false,
        kg: 0,
        reps: 12,
        savedAt: savedAt,
      ),
    ).called(1);
  });

  test('throws for a negative kg and does not insert', () async {
    await expectLater(
      useCase.call(
        workoutId: 1,
        sessionExerciseId: 100,
        isWarmup: false,
        savedAt: savedAt,
        kg: -2.5,
        reps: 8,
      ),
      throwsA(isA<InvalidSetValue>()),
    );
    verifyNever(
      () => workouts.insertSet(
        sessionExerciseId: any(named: 'sessionExerciseId'),
        position: any(named: 'position'),
        isWarmup: any(named: 'isWarmup'),
        kg: any(named: 'kg'),
        reps: any(named: 'reps'),
        savedAt: any(named: 'savedAt'),
      ),
    );
  });

  test('throws for a non-finite kg and does not insert', () async {
    for (final kg in [double.nan, double.infinity]) {
      await expectLater(
        useCase.call(
          workoutId: 1,
          sessionExerciseId: 100,
          isWarmup: false,
          kg: kg,
          reps: 8,
          savedAt: savedAt,
        ),
        throwsA(isA<InvalidSetValue>()),
      );
    }
    verifyNever(
      () => workouts.insertSet(
        sessionExerciseId: any(named: 'sessionExerciseId'),
        position: any(named: 'position'),
        isWarmup: any(named: 'isWarmup'),
        kg: any(named: 'kg'),
        reps: any(named: 'reps'),
        savedAt: any(named: 'savedAt'),
      ),
    );
  });

  test('throws when reps is 0', () async {
    await expectLater(
      useCase.call(
        workoutId: 1,
        sessionExerciseId: 100,
        isWarmup: false,
        savedAt: savedAt,
        kg: 60,
        reps: 0,
      ),
      throwsA(isA<InvalidSetValue>()),
    );
    verifyNever(
      () => workouts.insertSet(
        sessionExerciseId: any(named: 'sessionExerciseId'),
        position: any(named: 'position'),
        isWarmup: any(named: 'isWarmup'),
        kg: any(named: 'kg'),
        reps: any(named: 'reps'),
        savedAt: any(named: 'savedAt'),
      ),
    );
  });

  test('throws when the session exercise is not on the workout', () async {
    when(() => workouts.findById(1)).thenAnswer((_) async => workoutSession());

    await expectLater(
      useCase.call(
        workoutId: 1,
        sessionExerciseId: 100,
        isWarmup: false,
        savedAt: savedAt,
        kg: 60,
        reps: 8,
      ),
      throwsA(isA<SessionExerciseNotFound>()),
    );
    verifyNever(
      () => workouts.insertSet(
        sessionExerciseId: any(named: 'sessionExerciseId'),
        position: any(named: 'position'),
        isWarmup: any(named: 'isWarmup'),
        kg: any(named: 'kg'),
        reps: any(named: 'reps'),
        savedAt: any(named: 'savedAt'),
      ),
    );
  });

  test('throws when the workout is not in progress', () async {
    when(
      () => workouts.findById(1),
    ).thenAnswer((_) async => workoutSession(status: WorkoutStatus.completed));

    await expectLater(
      useCase.call(
        workoutId: 1,
        sessionExerciseId: 100,
        isWarmup: false,
        savedAt: savedAt,
        kg: 60,
        reps: 8,
      ),
      throwsA(isA<WorkoutNotInProgress>()),
    );
    verifyNever(
      () => workouts.insertSet(
        sessionExerciseId: any(named: 'sessionExerciseId'),
        position: any(named: 'position'),
        isWarmup: any(named: 'isWarmup'),
        kg: any(named: 'kg'),
        reps: any(named: 'reps'),
        savedAt: any(named: 'savedAt'),
      ),
    );
  });

  test('throws when the workout does not exist', () async {
    when(() => workouts.findById(1)).thenAnswer((_) async => null);

    await expectLater(
      useCase.call(
        workoutId: 1,
        sessionExerciseId: 100,
        isWarmup: false,
        savedAt: savedAt,
        kg: 60,
        reps: 8,
      ),
      throwsA(isA<WorkoutNotFound>()),
    );
  });
}
