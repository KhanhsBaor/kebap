import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kebap/core/db/app_database.dart';
import 'package:kebap/core/db/db_enums.dart';
import 'package:kebap/features/workout/data/repositories/workout_repository_impl.dart';
import 'package:kebap/features/workout/domain/entities/workout_session.dart';
import 'package:kebap/features/workout/domain/repositories/workout_repository.dart';

void main() {
  late AppDatabase database;
  late WorkoutRepositoryImpl repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory(), seedOnOpen: false);
    repository = WorkoutRepositoryImpl(database);
  });

  tearDown(() => database.close());

  test(
    'watchInProgress emits null, then the session, then a saved set',
    () async {
      final catalog = await _seedCatalog(database);
      final events = <WorkoutSession?>[];
      final subscription = repository.watchInProgress().listen(events.add);
      addTearDown(subscription.cancel);

      await waitUntil(() => events.isNotEmpty);
      expect(events, [isNull]);

      final session = await repository.insertInProgress(
        startedAt: DateTime.utc(2026, 11, 5, 15),
        muscleGroupIds: [catalog.tricepsId, catalog.chestId],
      );
      await waitUntil(() => events.length >= 2);
      expect(events.last?.id, session.id);
      expect(events.last?.exercises, isEmpty);

      final added = await repository.addExercise(
        workoutId: session.id,
        exerciseId: catalog.benchId,
      );
      final logged = await repository.insertSet(
        sessionExerciseId: added.id,
        position: 1,
        kg: 60,
        reps: 8,
      );
      await waitUntil(() {
        final session = events.last;
        if (session == null || session.exercises.length != 1) return false;
        return session.exercises.single.sets.isNotEmpty;
      });
      expect(events.last!.exercises.single.sets.single.id, logged.id);
    },
  );

  test('insertInProgress keeps muscle group order and splitDayId', () async {
    final catalog = await _seedCatalog(database);
    final startedAt = DateTime.utc(2026, 11, 5, 9);

    final session = await repository.insertInProgress(
      startedAt: startedAt,
      muscleGroupIds: [catalog.tricepsId, catalog.chestId],
      splitDayId: 4,
    );

    expect(session.muscleGroupIds, [catalog.tricepsId, catalog.chestId]);
    expect(session.status, WorkoutStatus.inProgress);
    expect(session.splitDayId, 4);
    expect(session.startedAt.isAtSameMomentAs(startedAt), isTrue);
    expect(session.endedAt, isNull);
    expect(session.exercises, isEmpty);
  });

  test(
    'insertInProgress rejects an empty group list and a second open session',
    () async {
      final catalog = await _seedCatalog(database);
      await expectLater(
        repository.insertInProgress(
          startedAt: DateTime.utc(2026, 11, 5, 9),
          muscleGroupIds: const [],
        ),
        throwsArgumentError,
      );
      expect(await database.select(database.workouts).get(), isEmpty);

      await repository.insertInProgress(
        startedAt: DateTime.utc(2026, 11, 5, 9),
        muscleGroupIds: [catalog.chestId],
      );
      await expectLater(
        repository.insertInProgress(
          startedAt: DateTime.utc(2026, 11, 5, 10),
          muscleGroupIds: [catalog.chestId, catalog.chestId],
        ),
        throwsArgumentError,
      );
      await expectLater(
        repository.insertInProgress(
          startedAt: DateTime.utc(2026, 11, 5, 10),
          muscleGroupIds: [catalog.tricepsId],
        ),
        throwsA(isA<WorkoutAlreadyInProgress>()),
      );
      expect(await database.select(database.workouts).get(), hasLength(1));
    },
  );

  test(
    'deleteWorkout removes the session graph and keeps the catalog exercise',
    () async {
      final catalog = await _seedCatalog(database);
      final session = await repository.insertInProgress(
        startedAt: DateTime.utc(2026, 11, 5, 9),
        muscleGroupIds: [catalog.chestId],
      );
      final added = await repository.addExercise(
        workoutId: session.id,
        exerciseId: catalog.benchId,
      );
      await repository.insertSet(
        sessionExerciseId: added.id,
        position: 1,
        kg: 60,
        reps: 5,
      );

      await repository.deleteWorkout(session.id);

      expect(await database.select(database.workouts).get(), isEmpty);
      expect(
        await database.select(database.workoutMuscleGroups).get(),
        isEmpty,
      );
      expect(await database.select(database.workoutExercises).get(), isEmpty);
      expect(await database.select(database.workoutSets).get(), isEmpty);
      expect(await database.select(database.exercises).get(), hasLength(2));
      await expectLater(repository.deleteWorkout(session.id), throwsStateError);
    },
  );

  test('complete stores completed status and endedAt', () async {
    final catalog = await _seedCatalog(database);
    final session = await repository.insertInProgress(
      startedAt: DateTime.utc(2026, 11, 5, 9),
      muscleGroupIds: [catalog.chestId],
    );
    final endedAt = DateTime.utc(2026, 11, 5, 10);

    await repository.complete(id: session.id, endedAt: endedAt);

    final stored = await (database.select(
      database.workouts,
    )..where((row) => row.id.equals(session.id))).getSingle();
    expect(stored.status, WorkoutStatus.completed);
    expect(stored.endedAt!.isAtSameMomentAs(endedAt), isTrue);
    await expectLater(
      repository.complete(id: 999, endedAt: endedAt),
      throwsStateError,
    );
  });

  test(
    'addExercise appends by position and rejects the same exercise',
    () async {
      final catalog = await _seedCatalog(database);
      final session = await repository.insertInProgress(
        startedAt: DateTime.utc(2026, 11, 5, 9),
        muscleGroupIds: [catalog.chestId, catalog.tricepsId],
      );

      final first = await repository.addExercise(
        workoutId: session.id,
        exerciseId: catalog.benchId,
      );
      final second = await repository.addExercise(
        workoutId: session.id,
        exerciseId: catalog.pushdownId,
      );

      expect(first.position, 0);
      expect(first.sets, isEmpty);
      expect(second.position, 1);
      expect(second.exerciseId, catalog.pushdownId);
      await expectLater(
        repository.addExercise(
          workoutId: session.id,
          exerciseId: catalog.benchId,
        ),
        throwsStateError,
      );
      expect(
        await database.select(database.workoutExercises).get(),
        hasLength(2),
      );
    },
  );

  test('removeExercise deletes the exercise and its saved sets', () async {
    final catalog = await _seedCatalog(database);
    final session = await repository.insertInProgress(
      startedAt: DateTime.utc(2026, 11, 5, 9),
      muscleGroupIds: [catalog.chestId, catalog.tricepsId],
    );
    final kept = await repository.addExercise(
      workoutId: session.id,
      exerciseId: catalog.benchId,
    );
    final dropped = await repository.addExercise(
      workoutId: session.id,
      exerciseId: catalog.pushdownId,
    );
    await repository.insertSet(
      sessionExerciseId: dropped.id,
      position: 1,
      kg: 20,
      reps: 10,
    );

    await repository.removeExercise(dropped.id);

    final storedExercises = await database
        .select(database.workoutExercises)
        .get();
    expect(storedExercises.map((row) => row.id), [kept.id]);
    expect(await database.select(database.workoutSets).get(), isEmpty);
    expect(await database.select(database.workouts).get(), hasLength(1));
    await expectLater(repository.removeExercise(dropped.id), throwsStateError);
  });

  test('insertSet updateSet and deleteSet keep nullable kg and reps', () async {
    final catalog = await _seedCatalog(database);
    final session = await repository.insertInProgress(
      startedAt: DateTime.utc(2026, 11, 5, 9),
      muscleGroupIds: [catalog.chestId],
    );
    final added = await repository.addExercise(
      workoutId: session.id,
      exerciseId: catalog.benchId,
    );

    final logged = await repository.insertSet(
      sessionExerciseId: added.id,
      position: 3,
    );
    expect(logged.position, 3);
    expect(logged.isWarmup, isFalse);
    expect(logged.kg, isNull);
    expect(logged.reps, isNull);

    final updated = await repository.updateSet(
      id: logged.id,
      isWarmup: true,
      kg: 40,
      reps: 12,
    );
    expect(updated.isWarmup, isTrue);
    expect(updated.kg, 40);
    expect(updated.reps, 12);

    final cleared = await repository.updateSet(id: logged.id, isWarmup: false);
    expect(cleared.kg, isNull);
    expect(cleared.reps, isNull);

    await expectLater(
      repository.updateSet(id: 999, isWarmup: false),
      throwsStateError,
    );

    await repository.deleteSet(logged.id);
    expect(await database.select(database.workoutSets).get(), isEmpty);
    await expectLater(repository.deleteSet(logged.id), throwsStateError);
  });

  test(
    'findPreviousSets uses the latest completed session before startedAt',
    () async {
      final catalog = await _seedCatalog(database);
      final currentStart = DateTime.utc(2026, 11, 5, 15);

      await _logCompleted(
        repository,
        exerciseId: catalog.benchId,
        muscleGroupId: catalog.chestId,
        startedAt: DateTime.utc(2026, 11, 5, 8),
        endedAt: DateTime.utc(2026, 11, 5, 9),
        sets: [(position: 1, kg: 50.0, reps: 5, isWarmup: false)],
      );
      await _logCompleted(
        repository,
        exerciseId: catalog.benchId,
        muscleGroupId: catalog.chestId,
        startedAt: DateTime.utc(2026, 11, 5, 12),
        endedAt: DateTime.utc(2026, 11, 5, 13),
        sets: [
          (position: 2, kg: null, reps: null, isWarmup: true),
          (position: 1, kg: 60.0, reps: 8, isWarmup: false),
        ],
      );
      await _logCompleted(
        repository,
        exerciseId: catalog.benchId,
        muscleGroupId: catalog.chestId,
        startedAt: DateTime.utc(2026, 11, 5, 16),
        endedAt: DateTime.utc(2026, 11, 5, 17),
        sets: [(position: 1, kg: 80.0, reps: 3, isWarmup: false)],
      );
      final open = await repository.insertInProgress(
        startedAt: DateTime.utc(2026, 11, 5, 18),
        muscleGroupIds: [catalog.chestId],
      );
      final openExercise = await repository.addExercise(
        workoutId: open.id,
        exerciseId: catalog.benchId,
      );
      await repository.insertSet(
        sessionExerciseId: openExercise.id,
        position: 1,
        kg: 999,
        reps: 1,
      );

      final previous = await repository.findPreviousSets(
        exerciseId: catalog.benchId,
        startedAt: currentStart,
      );

      expect(previous.map((set) => set.position), [1, 2]);
      expect(previous.first.kg, 60);
      expect(previous.first.reps, 8);
      expect(previous.last.isWarmup, isTrue);
      expect(
        await repository.findPreviousSets(
          exerciseId: catalog.pushdownId,
          startedAt: currentStart,
        ),
        isEmpty,
      );
    },
  );
}

class _Catalog {
  const _Catalog({
    required this.chestId,
    required this.tricepsId,
    required this.benchId,
    required this.pushdownId,
  });

  final int chestId;
  final int tricepsId;
  final int benchId;
  final int pushdownId;
}

Future<_Catalog> _seedCatalog(AppDatabase database) async {
  final regionId = await database
      .into(database.regions)
      .insert(
        RegionsCompanion.insert(slug: 'upper_body', nameEn: 'Upper body'),
      );
  final chestId = await database
      .into(database.muscleGroups)
      .insert(
        MuscleGroupsCompanion.insert(
          regionId: regionId,
          slug: 'chest',
          nameEn: 'Chest',
        ),
      );
  final tricepsId = await database
      .into(database.muscleGroups)
      .insert(
        MuscleGroupsCompanion.insert(
          regionId: regionId,
          slug: 'triceps',
          nameEn: 'Triceps',
        ),
      );
  final benchId = await database
      .into(database.exercises)
      .insert(
        ExercisesCompanion.insert(
          muscleGroupId: chestId,
          nameEn: 'Bench press',
        ),
      );
  final pushdownId = await database
      .into(database.exercises)
      .insert(
        ExercisesCompanion.insert(muscleGroupId: tricepsId, nameEn: 'Pushdown'),
      );
  return _Catalog(
    chestId: chestId,
    tricepsId: tricepsId,
    benchId: benchId,
    pushdownId: pushdownId,
  );
}

Future<void> _logCompleted(
  WorkoutRepositoryImpl repository, {
  required int exerciseId,
  required int muscleGroupId,
  required DateTime startedAt,
  required DateTime endedAt,
  required List<({int position, double? kg, int? reps, bool isWarmup})> sets,
}) async {
  final session = await repository.insertInProgress(
    startedAt: startedAt,
    muscleGroupIds: [muscleGroupId],
  );
  final added = await repository.addExercise(
    workoutId: session.id,
    exerciseId: exerciseId,
  );
  for (final set in sets) {
    await repository.insertSet(
      sessionExerciseId: added.id,
      position: set.position,
      isWarmup: set.isWarmup,
      kg: set.kg,
      reps: set.reps,
    );
  }
  await repository.complete(id: session.id, endedAt: endedAt);
}

Future<void> waitUntil(bool Function() ready) async {
  for (var attempt = 0; attempt < 50; attempt++) {
    if (ready()) return;
    await Future<void>.delayed(const Duration(milliseconds: 20));
  }
  fail('timed out waiting for a stream event');
}
