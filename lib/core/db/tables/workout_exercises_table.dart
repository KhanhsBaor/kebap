import 'package:drift/drift.dart';
import 'package:kebap/core/db/tables/exercises_table.dart';
import 'package:kebap/core/db/tables/workouts_table.dart';

class WorkoutExercises extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get workoutId =>
      integer().references(Workouts, #id, onDelete: KeyAction.cascade)();

  IntColumn get exerciseId =>
      integer().references(Exercises, #id, onDelete: KeyAction.restrict)();

  IntColumn get position => integer()();
}
