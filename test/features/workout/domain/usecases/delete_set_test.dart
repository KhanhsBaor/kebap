import 'package:flutter_test/flutter_test.dart';
import 'package:kebap/features/workout/domain/entities/workout_status.dart';
import 'package:kebap/features/workout/domain/failures/workout_rule_exception.dart';
import 'package:kebap/features/workout/domain/usecases/delete_set.dart';
import 'package:mocktail/mocktail.dart';

import '../support/mock_repositories.dart';
import '../support/workout_fixtures.dart';

void main() {
  late MockWorkoutRepository workouts;
  late DeleteSet useCase;

  setUpAll(registerWorkoutFallbacks);

  setUp(() {
    workouts = MockWorkoutRepository();
    useCase = DeleteSet(workoutRepository: workouts);
    when(
      () => workouts.deleteSet(
        id: any(named: 'id'),
        positions: any(named: 'positions'),
      ),
    ).thenAnswer((_) async {});
  });

  Future<Map<int, int>> deleteAndCapture(int setId) async {
    await useCase.call(workoutId: 1, setId: setId);
    final captured =
        verify(
              () => workouts.deleteSet(
                id: setId,
                positions: captureAny(named: 'positions'),
              ),
            ).captured.single
            as Map<int, int>;
    return captured;
  }

  test(
    'renumbers the later sets of that exercise and leaves the other',
    () async {
      when(() => workouts.findById(1)).thenAnswer(
        (_) async => workoutSession(
          exercises: [
            sessionExercise(
              id: 100,
              sets: [
                setLog(id: 1, position: 1),
                setLog(id: 2, position: 2),
                setLog(id: 3, position: 3),
              ],
            ),
            sessionExercise(
              id: 200,
              position: 2,
              sets: [setLog(id: 9, sessionExerciseId: 200, position: 1)],
            ),
          ],
        ),
      );

      final positions = await deleteAndCapture(2);

      expect(positions, {1: 1, 3: 2});
    },
  );

  test('renumbers from the stored order when the list is unsorted', () async {
    when(() => workouts.findById(1)).thenAnswer(
      (_) async => workoutSession(
        exercises: [
          sessionExercise(
            sets: [
              setLog(id: 3, position: 3),
              setLog(id: 1, position: 1),
              setLog(id: 2, position: 2),
            ],
          ),
        ],
      ),
    );

    final positions = await deleteAndCapture(1);

    expect(positions, {2: 1, 3: 2});
  });

  test('passes an empty position map when deleting the only set', () async {
    when(() => workouts.findById(1)).thenAnswer(
      (_) async => workoutSession(
        exercises: [
          sessionExercise(sets: [setLog(id: 4, position: 1)]),
        ],
      ),
    );

    final positions = await deleteAndCapture(4);

    expect(positions, isEmpty);
  });

  test('throws when the set is not on the workout', () async {
    when(() => workouts.findById(1)).thenAnswer((_) async => workoutSession());

    await expectLater(
      useCase.call(workoutId: 1, setId: 4),
      throwsA(isA<SetNotFound>()),
    );
    verifyNever(
      () => workouts.deleteSet(
        id: any(named: 'id'),
        positions: any(named: 'positions'),
      ),
    );
  });

  test('throws when the workout is not in progress', () async {
    when(
      () => workouts.findById(1),
    ).thenAnswer((_) async => workoutSession(status: WorkoutStatus.completed));

    await expectLater(
      useCase.call(workoutId: 1, setId: 4),
      throwsA(isA<WorkoutNotInProgress>()),
    );
    verifyNever(
      () => workouts.deleteSet(
        id: any(named: 'id'),
        positions: any(named: 'positions'),
      ),
    );
  });

  test('throws when the workout does not exist', () async {
    when(() => workouts.findById(1)).thenAnswer((_) async => null);

    await expectLater(
      useCase.call(workoutId: 1, setId: 4),
      throwsA(isA<WorkoutNotFound>()),
    );
  });
}
