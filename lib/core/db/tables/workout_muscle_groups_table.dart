import 'package:drift/drift.dart';
import 'package:kebap/core/db/tables/muscle_groups_table.dart';
import 'package:kebap/core/db/tables/workouts_table.dart';

class WorkoutMuscleGroups extends Table {
  IntColumn get workoutId =>
      integer().references(Workouts, #id, onDelete: KeyAction.cascade)();

  IntColumn get muscleGroupId =>
      integer().references(MuscleGroups, #id, onDelete: KeyAction.restrict)();

  IntColumn get position => integer()();

  @override
  Set<Column<Object>> get primaryKey => {workoutId, muscleGroupId};
}
