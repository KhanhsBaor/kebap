// dart format width=80
// ignore_for_file: unused_local_variable, unused_import
import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:kebap/core/db/app_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'generated/schema.dart';

import 'generated/schema_v1.dart' as v1;
import 'generated/schema_v2.dart' as v2;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() {
    verifier = SchemaVerifier(GeneratedHelper());
  });

  group('simple database migrations', () {
    const versions = GeneratedHelper.versions;
    for (final (i, fromVersion) in versions.indexed) {
      group('from $fromVersion', () {
        for (final toVersion in versions.skip(i + 1)) {
          test('to $toVersion', () async {
            final schema = await verifier.schemaAt(fromVersion);
            final db = AppDatabase(schema.newConnection(), seedOnOpen: false);
            await verifier.migrateAndValidate(db, toVersion);
            await db.close();
          });
        }
      });
    }
  });

  test('v1 to v2 keeps saved sets and leaves savedAt empty', () async {
    const startedAt = 1763100000;
    await verifier.testWithDataIntegrity(
      oldVersion: 1,
      newVersion: 2,
      createOld: v1.DatabaseAtV1.new,
      createNew: v2.DatabaseAtV2.new,
      openTestedDatabase: (executor) =>
          AppDatabase(executor, seedOnOpen: false),
      createItems: (batch, oldDb) {
        batch.insertAll(oldDb.regions, const [
          v1.RegionsData(id: 1, slug: 'upper_body', nameEn: 'Upper body'),
        ]);
        batch.insertAll(oldDb.muscleGroups, const [
          v1.MuscleGroupsData(
            id: 10,
            regionId: 1,
            slug: 'chest',
            nameEn: 'Chest',
          ),
        ]);
        batch.insertAll(oldDb.exercises, const [
          v1.ExercisesData(
            id: 50,
            muscleGroupId: 10,
            nameEn: 'Bench press',
            isCustom: 0,
          ),
        ]);
        batch.insertAll(oldDb.workouts, const [
          v1.WorkoutsData(id: 1, status: 'in_progress', startedAt: startedAt),
        ]);
        batch.insertAll(oldDb.workoutMuscleGroups, const [
          v1.WorkoutMuscleGroupsData(
            workoutId: 1,
            muscleGroupId: 10,
            position: 0,
          ),
        ]);
        batch.insertAll(oldDb.workoutExercises, const [
          v1.WorkoutExercisesData(
            id: 100,
            workoutId: 1,
            exerciseId: 50,
            position: 0,
          ),
        ]);
        batch.insertAll(oldDb.sets, const [
          v1.SetsData(
            id: 1,
            workoutExerciseId: 100,
            position: 1,
            isWarmup: 0,
            kg: 60,
            reps: 10,
          ),
          v1.SetsData(
            id: 2,
            workoutExerciseId: 100,
            position: 2,
            isWarmup: 1,
            reps: 12,
          ),
        ]);
      },
      validateItems: (newDb) async {
        expect(await newDb.select(newDb.sets).get(), const [
          v2.SetsData(
            id: 1,
            workoutExerciseId: 100,
            position: 1,
            isWarmup: 0,
            kg: 60,
            reps: 10,
          ),
          v2.SetsData(
            id: 2,
            workoutExerciseId: 100,
            position: 2,
            isWarmup: 1,
            reps: 12,
          ),
        ]);
        expect(await newDb.select(newDb.workouts).get(), const [
          v2.WorkoutsData(id: 1, status: 'in_progress', startedAt: startedAt),
        ]);
      },
    );
  });
}
