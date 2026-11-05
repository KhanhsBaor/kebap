import 'package:drift/drift.dart';
import 'package:flutter/services.dart';
import 'package:kebap/core/db/converters/workout_status_converter.dart';
import 'package:kebap/core/db/db_enums.dart';
import 'package:kebap/core/db/seed/catalog_seeder.dart';
import 'package:kebap/core/db/tables/exercises_table.dart';
import 'package:kebap/core/db/tables/muscle_groups_table.dart';
import 'package:kebap/core/db/tables/regions_table.dart';
import 'package:kebap/core/db/tables/sets_table.dart';
import 'package:kebap/core/db/tables/workout_exercises_table.dart';
import 'package:kebap/core/db/tables/workout_muscle_groups_table.dart';
import 'package:kebap/core/db/tables/workouts_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Regions,
    MuscleGroups,
    Exercises,
    Workouts,
    WorkoutMuscleGroups,
    WorkoutExercises,
    WorkoutSets,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(
    super.executor, {
    this.seedOnOpen = true,
    Future<String> Function()? loadSeedCsv,
  }) : _loadSeedCsv = loadSeedCsv ?? loadBundledExerciseSeedCsv;

  final bool seedOnOpen;
  final Future<String> Function() _loadSeedCsv;

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      if (!seedOnOpen) return;
      await CatalogSeeder(this).run(_loadSeedCsv);
    },
  );
}

Future<String> loadBundledExerciseSeedCsv() {
  return rootBundle.loadString('seed/exercises.csv');
}
