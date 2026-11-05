import 'package:drift/drift.dart';
import 'package:kebap/core/db/app_database.dart';
import 'package:kebap/core/db/tables/sets_table.dart';
import 'package:kebap/core/db/tables/workout_exercises_table.dart';
import 'package:kebap/core/db/tables/workout_muscle_groups_table.dart';
import 'package:kebap/core/db/tables/workouts_table.dart';
import 'package:kebap/features/workout/domain/entities/workout_status.dart';

part 'workout_dao.g.dart';

@DriftAccessor(
  tables: [Workouts, WorkoutMuscleGroups, WorkoutExercises, WorkoutSets],
)
class WorkoutDao extends DatabaseAccessor<AppDatabase> with _$WorkoutDaoMixin {
  WorkoutDao(super.db);

  /// Emits the open session header whenever the session, its groups, its
  /// exercises, or its sets change.
  Stream<Workout?> watchInProgress() {
    final query = select(workouts).join([
      leftOuterJoin(
        workoutMuscleGroups,
        workoutMuscleGroups.workoutId.equalsExp(workouts.id),
      ),
      leftOuterJoin(
        workoutExercises,
        workoutExercises.workoutId.equalsExp(workouts.id),
      ),
      leftOuterJoin(
        workoutSets,
        workoutSets.workoutExerciseId.equalsExp(workoutExercises.id),
      ),
    ])..where(workouts.status.equalsValue(WorkoutStatus.inProgress));
    return query.watch().map((rows) {
      if (rows.isEmpty) return null;
      return rows.first.readTable(workouts);
    });
  }

  Future<Workout?> findWorkout(int id) {
    return (select(
      workouts,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
  }

  Future<List<WorkoutMuscleGroup>> muscleGroupsOf(int workoutId) {
    return (select(workoutMuscleGroups)
          ..where((row) => row.workoutId.equals(workoutId))
          ..orderBy([(row) => OrderingTerm.asc(row.position)]))
        .get();
  }

  Future<List<WorkoutExercise>> exercisesOf(int workoutId) {
    return (select(workoutExercises)
          ..where((row) => row.workoutId.equals(workoutId))
          ..orderBy([(row) => OrderingTerm.asc(row.position)]))
        .get();
  }

  Future<List<SetRow>> setsOf(List<int> sessionExerciseIds) {
    if (sessionExerciseIds.isEmpty) return Future.value(const []);
    return (select(workoutSets)
          ..where((row) => row.workoutExerciseId.isIn(sessionExerciseIds))
          ..orderBy([(row) => OrderingTerm.asc(row.position)]))
        .get();
  }

  Future<int> insertWorkout(WorkoutsCompanion companion) {
    return into(workouts).insert(companion);
  }

  Future<void> insertWorkoutMuscleGroup(WorkoutMuscleGroupsCompanion row) {
    return into(workoutMuscleGroups).insert(row);
  }

  Future<int> deleteWorkout(int id) {
    return (delete(workouts)..where((row) => row.id.equals(id))).go();
  }

  Future<int> complete({required int id, required DateTime endedAt}) {
    return (update(workouts)..where((row) => row.id.equals(id))).write(
      WorkoutsCompanion(
        status: const Value(WorkoutStatus.completed),
        endedAt: Value(endedAt),
      ),
    );
  }

  Future<WorkoutExercise?> findWorkoutExercise({
    required int workoutId,
    required int exerciseId,
  }) {
    return (select(workoutExercises)
          ..where(
            (row) =>
                row.workoutId.equals(workoutId) &
                row.exerciseId.equals(exerciseId),
          )
          ..limit(1))
        .getSingleOrNull();
  }

  Future<int?> maxExercisePosition(int workoutId) async {
    final row =
        await (select(workoutExercises)
              ..where((row) => row.workoutId.equals(workoutId))
              ..orderBy([(row) => OrderingTerm.desc(row.position)])
              ..limit(1))
            .getSingleOrNull();
    return row?.position;
  }

  Future<WorkoutExercise> insertWorkoutExercise(
    WorkoutExercisesCompanion companion,
  ) {
    return into(workoutExercises).insertReturning(companion);
  }

  Future<SetRow> insertSet(WorkoutSetsCompanion companion) {
    return into(workoutSets).insertReturning(companion);
  }

  Future<SetRow?> findSet(int id) {
    return (select(
      workoutSets,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
  }

  Future<int> updateSet(int id, WorkoutSetsCompanion companion) {
    return (update(
      workoutSets,
    )..where((row) => row.id.equals(id))).write(companion);
  }

  Future<int> deleteSet(int id) {
    return (delete(workoutSets)..where((row) => row.id.equals(id))).go();
  }

  Future<int> deleteWorkoutExercise(int id) {
    return (delete(workoutExercises)..where((row) => row.id.equals(id))).go();
  }

  Future<bool> hasInProgress() async {
    final row =
        await (select(workouts)
              ..where((row) => row.status.equalsValue(WorkoutStatus.inProgress))
              ..limit(1))
            .getSingleOrNull();
    return row != null;
  }

  /// Latest completed session for [exerciseId] that ended before [startedAt].
  Future<List<SetRow>> previousSets({
    required int exerciseId,
    required DateTime startedAt,
  }) async {
    final reference =
        await (select(workoutExercises).join([
                innerJoin(
                  workouts,
                  workouts.id.equalsExp(workoutExercises.workoutId),
                ),
              ])
              ..where(workoutExercises.exerciseId.equals(exerciseId))
              ..where(workouts.status.equalsValue(WorkoutStatus.completed))
              ..where(workouts.endedAt.isSmallerThanValue(startedAt))
              ..orderBy([
                OrderingTerm.desc(workouts.endedAt),
                OrderingTerm.desc(workouts.id),
              ])
              ..limit(1))
            .getSingleOrNull();
    if (reference == null) return const [];

    final sessionExercise = reference.readTable(workoutExercises);
    return (select(workoutSets)
          ..where((row) => row.workoutExerciseId.equals(sessionExercise.id))
          ..orderBy([(row) => OrderingTerm.asc(row.position)]))
        .get();
  }
}
