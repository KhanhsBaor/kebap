import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kebap/core/db/app_database.dart';
import 'package:kebap/core/db/db_enums.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('opens schema v1 and stores a workout chain', () async {
    expect(database.schemaVersion, 1);

    final regionId = await database
        .into(database.regions)
        .insert(
          RegionsCompanion.insert(slug: 'upper_body', nameEn: 'Upper body'),
        );
    final muscleGroupId = await database
        .into(database.muscleGroups)
        .insert(
          MuscleGroupsCompanion.insert(
            regionId: regionId,
            slug: 'chest',
            nameEn: 'Chest',
          ),
        );
    final exerciseId = await database
        .into(database.exercises)
        .insert(
          ExercisesCompanion.insert(
            muscleGroupId: muscleGroupId,
            nameEn: 'Bench press',
          ),
        );
    final workoutId = await database
        .into(database.workouts)
        .insert(
          WorkoutsCompanion.insert(
            status: WorkoutStatus.inProgress,
            startedAt: DateTime.utc(2026, 11, 5),
          ),
        );
    await database
        .into(database.workoutMuscleGroups)
        .insert(
          WorkoutMuscleGroupsCompanion.insert(
            workoutId: workoutId,
            muscleGroupId: muscleGroupId,
            position: 0,
          ),
        );
    final workoutExerciseId = await database
        .into(database.workoutExercises)
        .insert(
          WorkoutExercisesCompanion.insert(
            workoutId: workoutId,
            exerciseId: exerciseId,
            position: 0,
          ),
        );
    final setId = await database
        .into(database.workoutSets)
        .insert(
          WorkoutSetsCompanion.insert(
            workoutExerciseId: workoutExerciseId,
            position: 1,
            kg: const Value(62.5),
            reps: const Value(8),
          ),
        );

    final stored = await (database.select(
      database.workoutSets,
    )..where((row) => row.id.equals(setId))).getSingle();
    expect(stored.kg, 62.5);
    expect(stored.reps, 8);
    expect(stored.isWarmup, isFalse);
    expect(stored.workoutExerciseId, workoutExerciseId);

    await database.delete(database.workouts).go();
    expect(await database.select(database.workoutSets).get(), isEmpty);
    expect(await database.select(database.workoutExercises).get(), isEmpty);
    expect(await database.select(database.workoutMuscleGroups).get(), isEmpty);
    expect(await database.select(database.exercises).get(), isNotEmpty);
  });

  test('rejects a muscle group whose region does not exist', () async {
    await expectLater(
      database
          .into(database.muscleGroups)
          .insert(
            MuscleGroupsCompanion.insert(
              regionId: 999,
              slug: 'chest',
              nameEn: 'Chest',
            ),
          ),
      throwsA(isA<Exception>()),
    );
  });

  test('allows only one in-progress workout', () async {
    await database
        .into(database.workouts)
        .insert(
          WorkoutsCompanion.insert(
            status: WorkoutStatus.inProgress,
            startedAt: DateTime.utc(2026, 11, 5),
          ),
        );

    await expectLater(
      database
          .into(database.workouts)
          .insert(
            WorkoutsCompanion.insert(
              status: WorkoutStatus.inProgress,
              startedAt: DateTime.utc(2026, 11, 5, 2),
            ),
          ),
      throwsA(isA<Exception>()),
    );
  });
}
