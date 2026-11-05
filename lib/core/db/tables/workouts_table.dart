import 'package:drift/drift.dart';
import 'package:kebap/core/db/converters/workout_status_converter.dart';

@TableIndex.sql(
  "CREATE UNIQUE INDEX workouts_one_in_progress ON workouts (status) "
  "WHERE status = 'in_progress'",
)
class Workouts extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get status => text().map(const WorkoutStatusConverter())();

  DateTimeColumn get startedAt => dateTime()();

  DateTimeColumn get endedAt => dateTime().nullable()();

  /// Schedule day. No foreign key until the schedule table exists (M5).
  IntColumn get splitDayId => integer().nullable()();
}
