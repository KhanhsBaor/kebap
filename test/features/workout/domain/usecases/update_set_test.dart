import 'package:flutter_test/flutter_test.dart';
import 'package:kebap/features/workout/domain/entities/workout_status.dart';
import 'package:kebap/features/workout/domain/failures/workout_rule_exception.dart';
import 'package:kebap/features/workout/domain/usecases/update_set.dart';
import 'package:mocktail/mocktail.dart';

import '../support/mock_repositories.dart';
import '../support/workout_fixtures.dart';

void main() {
  late MockWorkoutRepository workouts;
  late UpdateSet useCase;

  setUpAll(registerWorkoutFallbacks);

  setUp(() {
    workouts = MockWorkoutRepository();
    useCase = UpdateSet(workoutRepository: workouts);
  });

  test('updates kg, reps, and warmup without a new position', () async {
    final updated = setLog(id: 7, position: 2, kg: 80, reps: 5);
    when(() => workouts.findById(1)).thenAnswer(
      (_) async => workoutSession(
        exercises: [
          sessionExercise(sets: [setLog(id: 7, position: 2)]),
        ],
      ),
    );
    when(
      () => workouts.updateSet(
        id: any(named: 'id'),
        isWarmup: any(named: 'isWarmup'),
        kg: any(named: 'kg'),
        reps: any(named: 'reps'),
      ),
    ).thenAnswer((_) async => updated);

    final result = await useCase.call(
      workoutId: 1,
      setId: 7,
      isWarmup: true,
      kg: 80,
      reps: 5,
    );

    expect(result, same(updated));
    verify(
      () => workouts.updateSet(id: 7, isWarmup: true, kg: 80, reps: 5),
    ).called(1);
  });

  test('allows clearing kg and reps', () async {
    when(() => workouts.findById(1)).thenAnswer(
      (_) async => workoutSession(
        exercises: [
          sessionExercise(sets: [setLog(id: 7, position: 1)]),
        ],
      ),
    );
    when(
      () => workouts.updateSet(
        id: any(named: 'id'),
        isWarmup: any(named: 'isWarmup'),
        kg: any(named: 'kg'),
        reps: any(named: 'reps'),
      ),
    ).thenAnswer((_) async => setLog(id: 7, position: 1, kg: null, reps: null));

    await useCase.call(workoutId: 1, setId: 7, isWarmup: false);

    verify(
      () => workouts.updateSet(id: 7, isWarmup: false, kg: null, reps: null),
    ).called(1);
  });

  test('throws when kg is negative and does not update', () async {
    await expectLater(
      useCase.call(workoutId: 1, setId: 7, isWarmup: false, kg: -1, reps: 8),
      throwsA(isA<InvalidSetValue>()),
    );
    verifyNever(
      () => workouts.updateSet(
        id: any(named: 'id'),
        isWarmup: any(named: 'isWarmup'),
        kg: any(named: 'kg'),
        reps: any(named: 'reps'),
      ),
    );
  });

  test('throws when the set is not on the workout', () async {
    when(() => workouts.findById(1)).thenAnswer(
      (_) async => workoutSession(
        exercises: [
          sessionExercise(sets: [setLog(id: 7, position: 1)]),
        ],
      ),
    );

    await expectLater(
      useCase.call(workoutId: 1, setId: 8, isWarmup: false, kg: 60, reps: 8),
      throwsA(isA<SetNotFound>()),
    );
    verifyNever(
      () => workouts.updateSet(
        id: any(named: 'id'),
        isWarmup: any(named: 'isWarmup'),
        kg: any(named: 'kg'),
        reps: any(named: 'reps'),
      ),
    );
  });

  test('throws when the workout is not in progress', () async {
    when(
      () => workouts.findById(1),
    ).thenAnswer((_) async => workoutSession(status: WorkoutStatus.completed));

    await expectLater(
      useCase.call(workoutId: 1, setId: 7, isWarmup: false, kg: 60, reps: 8),
      throwsA(isA<WorkoutNotInProgress>()),
    );
    verifyNever(
      () => workouts.updateSet(
        id: any(named: 'id'),
        isWarmup: any(named: 'isWarmup'),
        kg: any(named: 'kg'),
        reps: any(named: 'reps'),
      ),
    );
  });

  test('throws when the workout does not exist', () async {
    when(() => workouts.findById(1)).thenAnswer((_) async => null);

    await expectLater(
      useCase.call(workoutId: 1, setId: 7, isWarmup: false, kg: 0, reps: 10),
      throwsA(isA<WorkoutNotFound>()),
    );
  });
}
