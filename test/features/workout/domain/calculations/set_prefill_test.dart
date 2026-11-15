import 'package:flutter_test/flutter_test.dart';
import 'package:kebap/features/workout/domain/calculations/set_prefill.dart';
import 'package:kebap/features/workout/domain/usecases/finish_workout.dart';

import '../support/workout_fixtures.dart';

void main() {
  const planned = FinishWorkout.defaultPlannedSetsPerExercise;

  test('uses the saved set immediately before this row', () {
    final suggestion = suggestSetLoad(
      position: 2,
      savedSets: [setLog(id: 1, position: 1, kg: 60, reps: 10)],
      referenceSets: [setLog(id: 9, position: 2, kg: 40, reps: 8)],
      plannedSetCount: planned,
    );

    expect(suggestion.kg, 60);
    expect(suggestion.reps, 10);
  });

  test('uses the same position from the reference session', () {
    final suggestion = suggestSetLoad(
      position: 1,
      savedSets: const [],
      referenceSets: [setLog(id: 9, position: 1, kg: 50, reps: 8)],
      plannedSetCount: planned,
    );

    expect(suggestion.kg, 50);
    expect(suggestion.reps, 8);
  });

  test('uses the general-health minimum when nothing came before', () {
    final suggestion = suggestSetLoad(
      position: 1,
      savedSets: const [],
      referenceSets: const [],
      plannedSetCount: planned,
    );

    expect(suggestion.kg, isNull);
    expect(suggestion.reps, generalHealthMinReps);
  });

  test('leaves an extra row empty when it has no previous set', () {
    final suggestion = suggestSetLoad(
      position: planned + 1,
      savedSets: const [],
      referenceSets: const [],
      plannedSetCount: planned,
    );

    expect(suggestion.kg, isNull);
    expect(suggestion.reps, isNull);
  });
}
