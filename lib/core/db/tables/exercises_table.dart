import 'package:drift/drift.dart';
import 'package:kebap/core/db/tables/muscle_groups_table.dart';
import 'package:kebap/core/db/db_enums.dart';

class Exercises extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get muscleGroupId =>
      integer().references(MuscleGroups, #id, onDelete: KeyAction.restrict)();

  TextColumn get nameEn => text()();

  TextColumn get nameVi => text().nullable()();

  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();

  TextColumn get sourceId => text().nullable()();

  TextColumn get equipment => textEnum<ExerciseEquipment>().nullable()();
}
