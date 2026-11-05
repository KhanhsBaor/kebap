import 'package:drift/drift.dart';
import 'package:kebap/core/db/tables/regions_table.dart';

class MuscleGroups extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get regionId =>
      integer().references(Regions, #id, onDelete: KeyAction.restrict)();

  TextColumn get slug => text().unique()();

  TextColumn get nameEn => text()();

  TextColumn get nameVi => text().nullable()();
}
