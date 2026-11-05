import 'package:drift/drift.dart';
import 'package:kebap/core/db/db_enums.dart';

class WorkoutStatusConverter extends TypeConverter<WorkoutStatus, String> {
  const WorkoutStatusConverter();

  @override
  WorkoutStatus fromSql(String fromDb) => WorkoutStatus.fromStorage(fromDb);

  @override
  String toSql(WorkoutStatus value) => value.storageValue;
}
