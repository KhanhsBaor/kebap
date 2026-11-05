import 'package:drift/drift.dart';
import 'package:kebap/features/workout/domain/entities/workout_status.dart';

/// Maps [WorkoutStatus] to the `workouts.status` text values (`in_progress`,
/// `completed`). The domain enum stays free of the storage spelling.
class WorkoutStatusConverter extends TypeConverter<WorkoutStatus, String> {
  const WorkoutStatusConverter();

  @override
  WorkoutStatus fromSql(String fromDb) => switch (fromDb) {
    'in_progress' => WorkoutStatus.inProgress,
    'completed' => WorkoutStatus.completed,
    _ => throw ArgumentError.value(fromDb, 'fromDb', 'Unknown workout status'),
  };

  @override
  String toSql(WorkoutStatus value) => switch (value) {
    WorkoutStatus.inProgress => 'in_progress',
    WorkoutStatus.completed => 'completed',
  };
}
