import 'package:flutter_test/flutter_test.dart';
import 'package:kebap/features/workout/domain/calculations/workout_staleness.dart';

import '../support/workout_fixtures.dart';

void main() {
  final last = DateTime.utc(2026, 11, 15, 8);

  group('isStaleWorkout', () {
    test('5:59 after the last activity is not stale', () {
      expect(
        isStaleWorkout(
          lastActivityAt: last,
          now: last.add(const Duration(hours: 5, minutes: 59)),
        ),
        isFalse,
      );
    });

    test('exactly 6:00 is not stale yet', () {
      expect(
        isStaleWorkout(
          lastActivityAt: last,
          now: last.add(staleWorkoutThreshold),
        ),
        isFalse,
      );
    });

    test('6:01 is stale', () {
      expect(
        isStaleWorkout(
          lastActivityAt: last,
          now: last.add(const Duration(hours: 6, minutes: 1)),
        ),
        isTrue,
      );
    });
  });

  group('lastWorkoutActivity', () {
    test('is startedAt when the session has no sets', () {
      final session = workoutSession(startedAt: last);

      expect(lastWorkoutActivity(session), last);
    });

    test('is the latest savedAt across exercises', () {
      final latest = last.add(const Duration(minutes: 40));
      final session = workoutSession(
        startedAt: last,
        exercises: [
          sessionExercise(
            sets: [
              setLog(id: 1, position: 1, savedAt: latest),
              setLog(
                id: 2,
                position: 2,
                savedAt: last.add(const Duration(minutes: 10)),
              ),
            ],
          ),
          sessionExercise(
            id: 101,
            exerciseId: 51,
            sets: [
              setLog(
                id: 3,
                sessionExerciseId: 101,
                position: 1,
                savedAt: last.add(const Duration(minutes: 20)),
              ),
            ],
          ),
        ],
      );

      expect(lastWorkoutActivity(session), latest);
    });

    test('falls back to startedAt when sets have no saved time', () {
      final session = workoutSession(
        startedAt: last,
        exercises: [
          sessionExercise(sets: [setLog(id: 1, position: 1)]),
        ],
      );

      expect(lastWorkoutActivity(session), last);
    });
  });
}
