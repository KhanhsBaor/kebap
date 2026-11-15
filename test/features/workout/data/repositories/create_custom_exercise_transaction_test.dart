import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kebap/core/db/app_database.dart';
import 'package:kebap/features/catalog/data/repositories/exercise_repository_impl.dart';
import 'package:kebap/features/workout/data/repositories/drift_workout_transaction_runner.dart';
import 'package:kebap/features/workout/data/repositories/workout_repository_impl.dart';
import 'package:kebap/features/workout/domain/entities/session_exercise.dart';
import 'package:kebap/features/workout/domain/entities/set_log.dart';
import 'package:kebap/features/workout/domain/entities/workout_session.dart';
import 'package:kebap/features/workout/domain/repositories/workout_repository.dart';
import 'package:kebap/features/workout/domain/usecases/create_custom_exercise.dart';

void main() {
  late AppDatabase database;
  late WorkoutRepositoryImpl workouts;
  late ExerciseRepositoryImpl exercises;
  late DriftWorkoutTransactionRunner transactions;
  late int chestId;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory(), seedOnOpen: false);
    workouts = WorkoutRepositoryImpl(database);
    exercises = ExerciseRepositoryImpl(database);
    transactions = DriftWorkoutTransactionRunner(database);

    final regionId = await database
        .into(database.regions)
        .insert(
          RegionsCompanion.insert(slug: 'upper_body', nameEn: 'Upper body'),
        );
    chestId = await database
        .into(database.muscleGroups)
        .insert(
          MuscleGroupsCompanion.insert(
            regionId: regionId,
            slug: 'chest',
            nameEn: 'Chest',
          ),
        );
  });

  tearDown(() => database.close());

  test('a failed append rolls back the custom exercise insert', () async {
    final session = await workouts.insertInProgress(
      startedAt: DateTime.utc(2026, 11, 15, 10),
      muscleGroupIds: [chestId],
    );
    final useCase = CreateCustomExercise(
      workoutRepository: _FailingAddWorkoutRepository(workouts),
      exerciseRepository: exercises,
      transactionRunner: transactions,
    );

    await expectLater(
      useCase.call(
        workoutId: session.id,
        name: 'Cable Fly Low',
        muscleGroupId: chestId,
      ),
      throwsA(isA<StateError>()),
    );

    final catalog = await database.select(database.exercises).get();
    expect(catalog, isEmpty);
    expect(await database.select(database.workoutExercises).get(), isEmpty);
  });
}

/// Delegates to [inner] except [addExercise], which always fails.
class _FailingAddWorkoutRepository implements WorkoutRepository {
  _FailingAddWorkoutRepository(this._inner);

  final WorkoutRepository _inner;

  @override
  Future<SessionExercise> addExercise({
    required int workoutId,
    required int exerciseId,
  }) {
    throw StateError('append failed on purpose');
  }

  @override
  Future<WorkoutSession> complete({
    required int id,
    required DateTime endedAt,
    List<int> dropSessionExerciseIds = const [],
  }) => _inner.complete(
    id: id,
    endedAt: endedAt,
    dropSessionExerciseIds: dropSessionExerciseIds,
  );

  @override
  Future<void> deleteSet({required int id, required Map<int, int> positions}) =>
      _inner.deleteSet(id: id, positions: positions);

  @override
  Future<void> deleteWorkout(int id) => _inner.deleteWorkout(id);

  @override
  Future<List<SetLog>> findPreviousSets({
    required int exerciseId,
    required DateTime startedAt,
  }) => _inner.findPreviousSets(exerciseId: exerciseId, startedAt: startedAt);

  @override
  Future<WorkoutSession?> findById(int id) => _inner.findById(id);

  @override
  Future<WorkoutSession?> findInProgress() => _inner.findInProgress();

  @override
  Future<SetLog> insertSet({
    required int sessionExerciseId,
    required int position,
    bool isWarmup = false,
    double? kg,
    int? reps,
    DateTime? savedAt,
  }) => _inner.insertSet(
    sessionExerciseId: sessionExerciseId,
    position: position,
    isWarmup: isWarmup,
    kg: kg,
    reps: reps,
    savedAt: savedAt,
  );

  @override
  Future<WorkoutSession> insertInProgress({
    required DateTime startedAt,
    required List<int> muscleGroupIds,
    int? splitDayId,
  }) => _inner.insertInProgress(
    startedAt: startedAt,
    muscleGroupIds: muscleGroupIds,
    splitDayId: splitDayId,
  );

  @override
  Future<void> removeExercise(int sessionExerciseId) =>
      _inner.removeExercise(sessionExerciseId);

  @override
  Future<SetLog> updateSet({
    required int id,
    required bool isWarmup,
    double? kg,
    int? reps,
  }) => _inner.updateSet(id: id, isWarmup: isWarmup, kg: kg, reps: reps);

  @override
  Stream<WorkoutSession?> watchInProgress() => _inner.watchInProgress();
}
