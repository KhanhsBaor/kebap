import 'package:drift/drift.dart';
import 'package:kebap/core/db/converters/workout_status_converter.dart';
import 'package:kebap/core/db/db_enums.dart';
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
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
