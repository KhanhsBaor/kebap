import 'package:flutter_test/flutter_test.dart';
import 'package:kebap/features/workout/domain/entities/session_exercise.dart';
import 'package:kebap/features/workout/domain/entities/workout_status.dart';
import 'package:kebap/features/workout/domain/failures/workout_rule_exception.dart';
import 'package:kebap/features/workout/domain/usecases/finish_workout.dart';
import 'package:mocktail/mocktail.dart';

import '../support/mock_repositories.dart';
import '../support/workout_fixtures.dart';

void main() {
  late MockWorkoutRepository workouts;
  late FinishWorkout useCase;

  setUpAll(registerWorkoutFallbacks);

  setUp(() {
    workouts = MockWorkoutRepository();
    useCase = FinishWorkout(workoutRepository: workouts);
  });

  void stubComplete(List<int> dropIds) {
    when(
      () => workouts.complete(
        id: 1,
        endedAt: fixtureEndedAt,
        dropSessionExerciseIds: any(
          named: 'dropSessionExerciseIds',
          that: equals(dropIds),
        ),
      ),
    ).thenAnswer(
      (_) async => workoutSession(
        status: WorkoutStatus.completed,
        endedAt: fixtureEndedAt,
      ),
    );
  }

  List<SessionExercise> twoExercises({
    required int savedOnFirst,
    required int savedOnSecond,
  }) {
    return [
      sessionExercise(
        id: 100,
        sets: [
          for (var index = 0; index < savedOnFirst; index++)
            setLog(id: index + 1, position: index + 1),
        ],
      ),
      sessionExercise(
        id: 200,
        position: 2,
        sets: [
          for (var index = 0; index < savedOnSecond; index++)
            setLog(
              id: 100 + index,
              sessionExerciseId: 200,
              position: index + 1,
            ),
        ],
      ),
    ];
  }

  test(
    'completes immediately when every exercise has its planned sets',
    () async {
      when(() => workouts.findById(1)).thenAnswer(
        (_) async => workoutSession(
          exercises: twoExercises(savedOnFirst: 3, savedOnSecond: 3),
        ),
      );
      stubComplete(const []);

      final result = await useCase.call(
        workoutId: 1,
        endedAt: fixtureEndedAt,
        plannedSetsByExercise: const {},
        confirmSkipRemaining: false,
      );

      expect(result, isA<FinishWorkoutCompleted>());
      final completed = (result as FinishWorkoutCompleted).session;
      expect(completed.status, WorkoutStatus.completed);
      expect(completed.endedAt, fixtureEndedAt);
    },
  );

  test('returns N and M and does not write when planned sets remain', () async {
    when(() => workouts.findById(1)).thenAnswer(
      (_) async => workoutSession(
        exercises: twoExercises(savedOnFirst: 1, savedOnSecond: 0),
      ),
    );

    final result = await useCase.call(
      workoutId: 1,
      endedAt: fixtureEndedAt,
      plannedSetsByExercise: const {},
      confirmSkipRemaining: false,
    );

    expect(result, isA<FinishWorkoutNeedsConfirmation>());
    final needs = result as FinishWorkoutNeedsConfirmation;
    expect(needs.unloggedSetCount, 5);
    expect(needs.exerciseCount, 2);
    verifyNever(
      () => workouts.complete(
        id: any(named: 'id'),
        endedAt: any(named: 'endedAt'),
        dropSessionExerciseIds: any(named: 'dropSessionExerciseIds'),
      ),
    );
  });

  test(
    'on confirm, drops only exercises with no sets and keeps partial ones',
    () async {
      when(() => workouts.findById(1)).thenAnswer(
        (_) async => workoutSession(
          exercises: twoExercises(savedOnFirst: 1, savedOnSecond: 0),
        ),
      );
      stubComplete(const [200]);

      final result = await useCase.call(
        workoutId: 1,
        endedAt: fixtureEndedAt,
        plannedSetsByExercise: const {},
        confirmSkipRemaining: true,
      );

      expect(result, isA<FinishWorkoutCompleted>());
      verify(
        () => workouts.complete(
          id: 1,
          endedAt: fixtureEndedAt,
          dropSessionExerciseIds: any(
            named: 'dropSessionExerciseIds',
            that: equals(const [200]),
          ),
        ),
      ).called(1);
    },
  );

  test('throws when no set is saved, even if the caller confirms', () async {
    when(() => workouts.findById(1)).thenAnswer(
      (_) async => workoutSession(
        exercises: twoExercises(savedOnFirst: 0, savedOnSecond: 0),
      ),
    );

    await expectLater(
      useCase.call(
        workoutId: 1,
        endedAt: fixtureEndedAt,
        plannedSetsByExercise: const {},
        confirmSkipRemaining: true,
      ),
      throwsA(isA<WorkoutHasNoSavedSets>()),
    );
    verifyNever(
      () => workouts.complete(
        id: any(named: 'id'),
        endedAt: any(named: 'endedAt'),
        dropSessionExerciseIds: any(named: 'dropSessionExerciseIds'),
      ),
    );
  });

  test('counts warmup and incomplete sets as saved', () async {
    when(() => workouts.findById(1)).thenAnswer(
      (_) async => workoutSession(
        exercises: [
          sessionExercise(
            sets: [
              setLog(id: 1, position: 1, isWarmup: true, kg: 20, reps: 10),
              setLog(id: 2, position: 2, kg: null, reps: null),
            ],
          ),
        ],
      ),
    );

    final result = await useCase.call(
      workoutId: 1,
      endedAt: fixtureEndedAt,
      plannedSetsByExercise: const {},
      confirmSkipRemaining: false,
    );

    final needs = result as FinishWorkoutNeedsConfirmation;
    expect(needs.unloggedSetCount, 1);
    expect(needs.exerciseCount, 1);
  });

  test('counts an unsaved row the caller adds past the saved sets', () async {
    when(() => workouts.findById(1)).thenAnswer(
      (_) async => workoutSession(
        exercises: [
          sessionExercise(
            sets: [
              for (var index = 0; index < 3; index++)
                setLog(id: index + 1, position: index + 1),
            ],
          ),
        ],
      ),
    );

    final result = await useCase.call(
      workoutId: 1,
      endedAt: fixtureEndedAt,
      plannedSetsByExercise: const {100: 4},
      confirmSkipRemaining: false,
    );

    final needs = result as FinishWorkoutNeedsConfirmation;
    expect(needs.unloggedSetCount, 1);
    expect(needs.exerciseCount, 1);
    verifyNever(
      () => workouts.complete(
        id: any(named: 'id'),
        endedAt: any(named: 'endedAt'),
        dropSessionExerciseIds: any(named: 'dropSessionExerciseIds'),
      ),
    );
  });

  test('finishes immediately when saved sets exceed the plan', () async {
    when(() => workouts.findById(1)).thenAnswer(
      (_) async => workoutSession(
        exercises: [
          sessionExercise(
            sets: [
              for (var index = 0; index < 4; index++)
                setLog(id: index + 1, position: index + 1),
            ],
          ),
        ],
      ),
    );
    stubComplete(const []);

    final result = await useCase.call(
      workoutId: 1,
      endedAt: fixtureEndedAt,
      plannedSetsByExercise: const {100: 3},
      confirmSkipRemaining: false,
    );

    expect(result, isA<FinishWorkoutCompleted>());
  });

  test('drops an empty exercise planned at 0 without asking', () async {
    when(() => workouts.findById(1)).thenAnswer(
      (_) async => workoutSession(
        exercises: twoExercises(savedOnFirst: 3, savedOnSecond: 0),
      ),
    );
    stubComplete(const [200]);

    final result = await useCase.call(
      workoutId: 1,
      endedAt: fixtureEndedAt,
      plannedSetsByExercise: const {200: 0},
      confirmSkipRemaining: false,
    );

    expect(result, isA<FinishWorkoutCompleted>());
    verify(
      () => workouts.complete(
        id: 1,
        endedAt: fixtureEndedAt,
        dropSessionExerciseIds: any(
          named: 'dropSessionExerciseIds',
          that: equals(const [200]),
        ),
      ),
    ).called(1);
  });

  test(
    'ignores planned counts for exercises that are not on the workout',
    () async {
      when(() => workouts.findById(1)).thenAnswer(
        (_) async => workoutSession(
          exercises: [
            sessionExercise(
              sets: [
                for (var index = 0; index < 3; index++)
                  setLog(id: index + 1, position: index + 1),
              ],
            ),
          ],
        ),
      );
      stubComplete(const []);

      final result = await useCase.call(
        workoutId: 1,
        endedAt: fixtureEndedAt,
        plannedSetsByExercise: const {999: -5},
        confirmSkipRemaining: false,
      );

      expect(result, isA<FinishWorkoutCompleted>());
    },
  );

  test('throws when a planned count on the workout is negative', () async {
    when(() => workouts.findById(1)).thenAnswer(
      (_) async => workoutSession(
        exercises: twoExercises(savedOnFirst: 1, savedOnSecond: 0),
      ),
    );

    await expectLater(
      useCase.call(
        workoutId: 1,
        endedAt: fixtureEndedAt,
        plannedSetsByExercise: const {100: -1},
        confirmSkipRemaining: true,
      ),
      throwsA(isA<InvalidPlannedSetCount>()),
    );
    verifyNever(
      () => workouts.complete(
        id: any(named: 'id'),
        endedAt: any(named: 'endedAt'),
        dropSessionExerciseIds: any(named: 'dropSessionExerciseIds'),
      ),
    );
  });

  test('reports a negative plan before the empty-session error', () async {
    when(
      () => workouts.findById(1),
    ).thenAnswer((_) async => workoutSession(exercises: [sessionExercise()]));

    await expectLater(
      useCase.call(
        workoutId: 1,
        endedAt: fixtureEndedAt,
        plannedSetsByExercise: const {100: -1},
        confirmSkipRemaining: true,
      ),
      throwsA(isA<InvalidPlannedSetCount>()),
    );
  });

  test('throws when the workout is not in progress', () async {
    when(
      () => workouts.findById(1),
    ).thenAnswer((_) async => workoutSession(status: WorkoutStatus.completed));

    await expectLater(
      useCase.call(
        workoutId: 1,
        endedAt: fixtureEndedAt,
        plannedSetsByExercise: const {},
        confirmSkipRemaining: true,
      ),
      throwsA(isA<WorkoutNotInProgress>()),
    );
  });

  test('throws when the workout does not exist', () async {
    when(() => workouts.findById(1)).thenAnswer((_) async => null);

    await expectLater(
      useCase.call(
        workoutId: 1,
        endedAt: fixtureEndedAt,
        plannedSetsByExercise: const {},
        confirmSkipRemaining: false,
      ),
      throwsA(isA<WorkoutNotFound>()),
    );
  });
}
