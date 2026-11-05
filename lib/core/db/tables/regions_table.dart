import 'package:drift/drift.dart';

class Regions extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get slug => text().unique()();

  TextColumn get nameEn => text()();

  TextColumn get nameVi => text().nullable()();
}
