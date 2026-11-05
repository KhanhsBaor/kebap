import 'package:drift/drift.dart';
import 'package:kebap/core/db/app_database.dart' as db;
import 'package:kebap/features/workout/domain/entities/session_exercise.dart';
import 'package:kebap/features/workout/domain/entities/set_log.dart';
import 'package:kebap/features/workout/domain/entities/workout_session.dart';
import 'package:kebap/features/workout/domain/entities/workout_status.dart';

WorkoutSession toWorkoutSession({
  required db.Workout workout,
  required List<db.WorkoutMuscleGroup> groups,
  required List<db.WorkoutExercise> exercises,
  required List<db.SetRow> sets,
}) {
  final setsByExercise = <int, List<SetLog>>{};
  for (final row in sets) {
    setsByExercise
        .putIfAbsent(row.workoutExerciseId, () => [])
        .add(toSetLog(row));
  }

  return WorkoutSession(
    id: workout.id,
    status: workout.status,
    startedAt: workout.startedAt,
    endedAt: workout.endedAt,
    splitDayId: workout.splitDayId,
    muscleGroupIds: [for (final group in groups) group.muscleGroupId],
    exercises: [
      for (final exercise in exercises)
        SessionExercise(
          id: exercise.id,
          exerciseId: exercise.exerciseId,
          position: exercise.position,
          sets: setsByExercise[exercise.id] ?? const <SetLog>[],
        ),
    ],
  );
}

SetLog toSetLog(db.SetRow row) {
  return SetLog(
    id: row.id,
    sessionExerciseId: row.workoutExerciseId,
    position: row.position,
    isWarmup: row.isWarmup,
    kg: row.kg,
    reps: row.reps,
  );
}

SessionExercise toSessionExercise(db.WorkoutExercise row) {
  return SessionExercise(
    id: row.id,
    exerciseId: row.exerciseId,
    position: row.position,
  );
}

db.WorkoutsCompanion inProgressWorkoutCompanion({
  required DateTime startedAt,
  int? splitDayId,
}) {
  return db.WorkoutsCompanion.insert(
    status: WorkoutStatus.inProgress,
    startedAt: startedAt,
    splitDayId: Value(splitDayId),
  );
}

db.WorkoutSetsCompanion setInsertCompanion({
  required int sessionExerciseId,
  required int position,
  bool isWarmup = false,
  double? kg,
  int? reps,
}) {
  return db.WorkoutSetsCompanion.insert(
    workoutExerciseId: sessionExerciseId,
    position: position,
    isWarmup: Value(isWarmup),
    kg: Value<double?>(kg),
    reps: Value<int?>(reps),
  );
}

db.WorkoutSetsCompanion setUpdateCompanion({
  required bool isWarmup,
  double? kg,
  int? reps,
}) {
  return db.WorkoutSetsCompanion(
    isWarmup: Value(isWarmup),
    kg: Value<double?>(kg),
    reps: Value<int?>(reps),
  );
}
