import 'package:flutter_test/flutter_test.dart';
import 'package:kebap/features/workout/presentation/widgets/add_exercise_sheet_logic.dart';

void main() {
  group('visibleMuscleGroupId', () {
    test('uses the last section that scrolled past the top', () {
      expect(
        visibleMuscleGroupId(
          groupIds: const [10, 11],
          sectionTops: const {10: 100, 11: 40},
          viewportTop: 50,
        ),
        11,
      );
    });

    test('falls back to the first measured section', () {
      expect(
        visibleMuscleGroupId(
          groupIds: const [10, 11],
          sectionTops: const {10: 80, 11: 200},
          viewportTop: 50,
        ),
        10,
      );
    });

    test('falls back to the first group when nothing is measured', () {
      expect(
        visibleMuscleGroupId(
          groupIds: const [10, 11],
          sectionTops: const {},
          viewportTop: 0,
        ),
        10,
      );
    });
  });

  group('customExercisePrefill', () {
    test('returns the query when there are no matches', () {
      expect(customExercisePrefill(query: '  zzz  ', hasMatches: false), 'zzz');
    });

    test('is empty when something matched or the query is blank', () {
      expect(customExercisePrefill(query: 'push', hasMatches: true), '');
      expect(customExercisePrefill(query: '   ', hasMatches: false), '');
    });
  });
}
