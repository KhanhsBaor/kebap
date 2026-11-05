import 'package:kebap/core/db/app_database.dart';
import 'package:kebap/features/workout/data/mappers/workout_mapper.dart';
import 'package:kebap/features/workout/domain/entities/session_exercise.dart';
import 'package:kebap/features/workout/domain/entities/set_log.dart';
import 'package:kebap/features/workout/domain/entities/workout_session.dart';
import 'package:kebap/features/workout/domain/entities/workout_status.dart';
import 'package:kebap/features/workout/domain/repositories/workout_repository.dart';

class WorkoutRepositoryImpl implements WorkoutRepository {
  WorkoutRepositoryImpl(this._database);

  final AppDatabase _database;

  @override
  Stream<WorkoutSession?> watchInProgress() {
    return _database.workoutDao.watchInProgress().asyncMap((workout) async {
      if (workout == null) return null;
      final session = await _sessionById(workout.id);
      if (session == null || session.status != WorkoutStatus.inProgress) {
        return null;
      }
      return session;
    });
  }

  @override
  Future<WorkoutSession> insertInProgress({
    required DateTime startedAt,
    required List<int> muscleGroupIds,
    int? splitDayId,
  }) async {
    if (muscleGroupIds.isEmpty) {
      throw ArgumentError.value(
        muscleGroupIds,
        'muscleGroupIds',
        'must not be empty',
      );
    }
    if (muscleGroupIds.toSet().length != muscleGroupIds.length) {
      throw ArgumentError.value(
        muscleGroupIds,
        'muscleGroupIds',
        'must not contain duplicates',
      );
    }

    final id = await _database.transaction(() async {
      if (await _database.workoutDao.hasInProgress()) {
        throw const WorkoutAlreadyInProgress();
      }
      final workoutId = await _database.workoutDao.insertWorkout(
        inProgressWorkoutCompanion(
          startedAt: startedAt,
          splitDayId: splitDayId,
        ),
      );
      for (var index = 0; index < muscleGroupIds.length; index++) {
        await _database.workoutDao.insertWorkoutMuscleGroup(
          WorkoutMuscleGroupsCompanion.insert(
            workoutId: workoutId,
            muscleGroupId: muscleGroupIds[index],
            position: index,
          ),
        );
      }
      return workoutId;
    });
    return (await _sessionById(id))!;
  }

  @override
  Future<void> deleteWorkout(int id) async {
    final deleted = await _database.workoutDao.deleteWorkout(id);
    if (deleted == 0) {
      throw StateError('Workout $id was not found');
    }
  }

  @override
  Future<void> complete({required int id, required DateTime endedAt}) async {
    final updated = await _database.workoutDao.complete(
      id: id,
      endedAt: endedAt,
    );
    if (updated == 0) {
      throw StateError('Workout $id was not found');
    }
  }

  @override
  Future<SessionExercise> addExercise({
    required int workoutId,
    required int exerciseId,
  }) async {
    final row = await _database.transaction(() async {
      final existing = await _database.workoutDao.findWorkoutExercise(
        workoutId: workoutId,
        exerciseId: exerciseId,
      );
      if (existing != null) {
        throw StateError(
          'Exercise $exerciseId is already in workout $workoutId',
        );
      }
      final maxPosition = await _database.workoutDao.maxExercisePosition(
        workoutId,
      );
      return _database.workoutDao.insertWorkoutExercise(
        WorkoutExercisesCompanion.insert(
          workoutId: workoutId,
          exerciseId: exerciseId,
          position: maxPosition == null ? 0 : maxPosition + 1,
        ),
      );
    });
    return toSessionExercise(row);
  }

  @override
  Future<void> removeExercise(int sessionExerciseId) async {
    final deleted = await _database.workoutDao.deleteWorkoutExercise(
      sessionExerciseId,
    );
    if (deleted == 0) {
      throw StateError('Session exercise $sessionExerciseId was not found');
    }
  }

  @override
  Future<SetLog> insertSet({
    required int sessionExerciseId,
    required int position,
    bool isWarmup = false,
    double? kg,
    int? reps,
  }) async {
    final row = await _database.workoutDao.insertSet(
      setInsertCompanion(
        sessionExerciseId: sessionExerciseId,
        position: position,
        isWarmup: isWarmup,
        kg: kg,
        reps: reps,
      ),
    );
    return toSetLog(row);
  }

  @override
  Future<SetLog> updateSet({
    required int id,
    required bool isWarmup,
    double? kg,
    int? reps,
  }) async {
    final updated = await _database.workoutDao.updateSet(
      id,
      setUpdateCompanion(isWarmup: isWarmup, kg: kg, reps: reps),
    );
    if (updated == 0) {
      throw StateError('Set $id was not found');
    }
    final row = await _database.workoutDao.findSet(id);
    return toSetLog(row!);
  }

  @override
  Future<void> deleteSet(int id) async {
    final deleted = await _database.workoutDao.deleteSet(id);
    if (deleted == 0) {
      throw StateError('Set $id was not found');
    }
  }

  @override
  Future<List<SetLog>> findPreviousSets({
    required int exerciseId,
    required DateTime startedAt,
  }) async {
    final rows = await _database.workoutDao.previousSets(
      exerciseId: exerciseId,
      startedAt: startedAt,
    );
    return [for (final row in rows) toSetLog(row)];
  }

  Future<WorkoutSession?> _sessionById(int id) async {
    final workout = await _database.workoutDao.findWorkout(id);
    if (workout == null) return null;
    final groups = await _database.workoutDao.muscleGroupsOf(id);
    final exercises = await _database.workoutDao.exercisesOf(id);
    final sets = await _database.workoutDao.setsOf([
      for (final exercise in exercises) exercise.id,
    ]);
    return toWorkoutSession(
      workout: workout,
      groups: groups,
      exercises: exercises,
      sets: sets,
    );
  }
}
