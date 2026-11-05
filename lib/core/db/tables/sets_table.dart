import 'package:drift/drift.dart';
import 'package:kebap/core/db/tables/workout_exercises_table.dart';

@DataClassName('SetRow')
class WorkoutSets extends Table {
  @override
  String get tableName => 'sets';

  IntColumn get id => integer().autoIncrement()();

  IntColumn get workoutExerciseId => integer().references(
    WorkoutExercises,
    #id,
    onDelete: KeyAction.cascade,
  )();

  IntColumn get position => integer()();

  BoolColumn get isWarmup => boolean().withDefault(const Constant(false))();

  RealColumn get kg => real().nullable()();

  IntColumn get reps => integer().nullable()();
}
