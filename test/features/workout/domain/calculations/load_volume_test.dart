import 'package:flutter_test/flutter_test.dart';
import 'package:kebap/features/workout/domain/calculations/load_volume.dart';

import '../support/workout_fixtures.dart';

void main() {
  test('multiplies kg by reps', () {
    expect(setVolume(60, 10), 600);
    expect(setVolume(0, 12), 0);
  });

  test('sums the Bench Press example to 1680', () {
    final sets = [
      setLog(id: 1, position: 1, kg: 60, reps: 10),
      setLog(id: 2, position: 2, kg: 60, reps: 10),
      setLog(id: 3, position: 3, kg: 60, reps: 8),
    ];

    expect(exerciseVolume(sets), 1680);
  });

  test('skips warmup sets and sets missing kg or reps', () {
    final sets = [
      setLog(id: 1, position: 1, isWarmup: true, kg: 100, reps: 10),
      setLog(id: 2, position: 2, kg: null, reps: 10),
      setLog(id: 3, position: 3, kg: 60, reps: null),
      setLog(id: 4, position: 4, kg: 60, reps: 10),
      setLog(id: 5, position: 5, kg: 0, reps: 12),
    ];

    expect(exerciseVolume(sets), 600);
  });

  test('returns 0 when every set is excluded or the list is empty', () {
    expect(exerciseVolume(const []), 0);
    expect(
      exerciseVolume([
        setLog(id: 1, position: 1, isWarmup: true),
        setLog(id: 2, position: 2, kg: null, reps: null),
      ]),
      0,
    );
  });
}
