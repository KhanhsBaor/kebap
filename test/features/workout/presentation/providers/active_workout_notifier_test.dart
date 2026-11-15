import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kebap/core/db/app_database.dart';
import 'package:kebap/core/db/app_database_provider.dart';
import 'package:kebap/features/workout/domain/entities/workout_session.dart';
import 'package:kebap/features/workout/domain/entities/workout_status.dart';
import 'package:kebap/features/workout/domain/usecases/finish_workout.dart';
import 'package:kebap/features/workout/presentation/notices/active_workout_notice.dart';
import 'package:kebap/features/workout/presentation/providers/active_workout.dart';
import 'package:kebap/features/workout/presentation/providers/active_workout_exercises.dart';
import 'package:kebap/features/workout/presentation/providers/active_workout_notifier.dart';
import 'package:kebap/features/workout/presentation/providers/previous_sets.dart';
import 'package:kebap/features/workout/presentation/providers/rest_timer_notifier.dart';

void main() {
  late AppDatabase database;
  late _Catalog catalog;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory(), seedOnOpen: false);
    catalog = await _seedCatalog(database);
  });

  tearDown(() => database.close());

  test(
    'rebuilt container sees the two sets saved on the open session',
    () async {
      final first = _container(database);
      var firstOpen = true;
      addTearDown(() {
        if (firstOpen) first.dispose();
      });
      _listen(first);

      final notifier = first.read(activeWorkoutCommandsProvider.notifier);
      await notifier.startWorkout(
        regionId: catalog.regionId,
        muscleGroupIds: [catalog.chestId, catalog.tricepsId],
      );
      await _waitFor(first, (_) => true);
      await notifier.addExercise(exerciseId: catalog.benchId);
      final withExercise = await _waitFor(
        first,
        (session) => session.exercises.isNotEmpty,
      );
      final sessionExerciseId = withExercise.exercises.single.id;
      await notifier.logSet(
        sessionExerciseId: sessionExerciseId,
        kg: 60,
        reps: 10,
      );
      await notifier.logSet(
        sessionExerciseId: sessionExerciseId,
        kg: 60,
        reps: 8,
      );
      final saved = await _waitFor(
        first,
        (session) => session.exercises.single.sets.length == 2,
      );

      expect(saved.muscleGroupIds, [catalog.chestId, catalog.tricepsId]);
      expect(saved.exercises.single.sets.map((set) => set.position), [1, 2]);
      expect(saved.exercises.single.sets.map((set) => set.reps), [10, 8]);
      expect(
        first.read(restTimerProvider.notifier).remainingSeconds(),
        RestTimerNotifier.defaultSeconds,
      );

      first.listen(activeWorkoutExercisesProvider, (_, _) {});
      final exercises = await first.read(activeWorkoutExercisesProvider.future);
      expect(
        exercises.map((exercise) => exercise.id),
        contains(catalog.benchId),
      );

      first.dispose();
      firstOpen = false;

      final second = _container(database);
      addTearDown(second.dispose);
      _listen(second);
      final restored = await _waitFor(second, (session) {
        final exercises = session.exercises;
        return exercises.length == 1 && exercises.single.sets.length == 2;
      });
      expect(restored.id, saved.id);
      expect(restored.exercises.single.sets.map((set) => set.kg), [60, 60]);
      expect(restored.exercises.single.sets.map((set) => set.reps), [10, 8]);
    },
  );

  test(
    'requestFinish with no saved set reports noSavedSets and keeps the session',
    () async {
      final container = _container(database);
      addTearDown(container.dispose);
      _listen(container);
      final notifier = container.read(activeWorkoutCommandsProvider.notifier);

      await notifier.startWorkout(
        regionId: catalog.regionId,
        muscleGroupIds: [catalog.chestId],
      );
      await _waitFor(container, (_) => true);
      await notifier.addExercise(exerciseId: catalog.benchId);
      await _waitFor(container, (session) => session.exercises.isNotEmpty);

      await notifier.requestFinish();

      expect(
        container.read(activeWorkoutCommandsProvider),
        isA<ActiveWorkoutNoSavedSets>(),
      );
      final session = await _waitFor(container, (_) => true);
      expect(session.status, WorkoutStatus.inProgress);
      expect(session.exercises.single.sets, isEmpty);
    },
  );

  test(
    'requestFinish reports remaining planned sets and does not complete',
    () async {
      final container = _container(database);
      addTearDown(container.dispose);
      _listen(container);
      final notifier = container.read(activeWorkoutCommandsProvider.notifier);

      await notifier.startWorkout(
        regionId: catalog.regionId,
        muscleGroupIds: [catalog.chestId],
      );
      await _waitFor(container, (_) => true);
      await notifier.addExercise(exerciseId: catalog.benchId);
      final withExercise = await _waitFor(
        container,
        (session) => session.exercises.isNotEmpty,
      );
      await notifier.logSet(
        sessionExerciseId: withExercise.exercises.single.id,
        kg: 60,
        reps: 8,
      );
      await _waitFor(
        container,
        (session) => session.exercises.single.sets.length == 1,
      );

      await notifier.requestFinish();

      final notice = container.read(activeWorkoutCommandsProvider);
      expect(notice, isA<ActiveWorkoutNeedsConfirmation>());
      final needs = notice! as ActiveWorkoutNeedsConfirmation;
      expect(
        needs.unloggedSetCount,
        FinishWorkout.defaultPlannedSetsPerExercise - 1,
      );
      expect(needs.exerciseCount, 1);
      final session = await _waitFor(
        container,
        (session) => session.status == WorkoutStatus.inProgress,
      );
      expect(session.endedAt, isNull);
    },
  );

  test(
    'requestFinish counts an unsaved draft when the caller raises the plan',
    () async {
      final container = _container(database);
      addTearDown(container.dispose);
      _listen(container);
      final notifier = container.read(activeWorkoutCommandsProvider.notifier);

      await notifier.startWorkout(
        regionId: catalog.regionId,
        muscleGroupIds: [catalog.chestId],
      );
      await _waitFor(container, (_) => true);
      await notifier.addExercise(exerciseId: catalog.benchId);
      final withExercise = await _waitFor(
        container,
        (session) => session.exercises.isNotEmpty,
      );
      final sessionExerciseId = withExercise.exercises.single.id;
      final planned = FinishWorkout.defaultPlannedSetsPerExercise;
      for (var index = 0; index < planned; index++) {
        await notifier.logSet(
          sessionExerciseId: sessionExerciseId,
          kg: 60,
          reps: 8,
        );
      }
      await _waitFor(
        container,
        (session) => session.exercises.single.sets.length == planned,
      );

      await notifier.requestFinish(
        plannedSetsByExercise: {sessionExerciseId: planned + 1},
      );

      final notice = container.read(activeWorkoutCommandsProvider);
      expect(notice, isA<ActiveWorkoutNeedsConfirmation>());
      final needs = notice! as ActiveWorkoutNeedsConfirmation;
      expect(needs.unloggedSetCount, 1);
      expect(needs.exerciseCount, 1);
      final session = await _waitFor(
        container,
        (session) => session.status == WorkoutStatus.inProgress,
      );
      expect(session.exercises.single.sets, hasLength(planned));
    },
  );

  test('cancel deletes the session and its sets', () async {
    final container = _container(database);
    addTearDown(container.dispose);
    _listen(container);
    final notifier = container.read(activeWorkoutCommandsProvider.notifier);

    await notifier.startWorkout(
      regionId: catalog.regionId,
      muscleGroupIds: [catalog.chestId],
    );
    await _waitFor(container, (_) => true);
    await notifier.addExercise(exerciseId: catalog.benchId);
    final withExercise = await _waitFor(
      container,
      (session) => session.exercises.isNotEmpty,
    );
    await notifier.logSet(
      sessionExerciseId: withExercise.exercises.single.id,
      kg: 40,
      reps: 5,
    );
    await _waitFor(
      container,
      (session) => session.exercises.single.sets.isNotEmpty,
    );

    await notifier.cancelWorkout();
    await _waitUntilAbsent(container);
    expect(await database.select(database.workouts).get(), isEmpty);
    expect(await database.select(database.workoutSets).get(), isEmpty);
    expect(await database.select(database.workoutExercises).get(), isEmpty);
    expect(
      container.read(restTimerProvider.notifier).remainingSeconds(),
      isNull,
    );
  });

  test(
    'finishStaleWorkout completes at the last saved set without asking',
    () async {
      final startedAt = DateTime.utc(2026, 11, 14, 8);
      var now = startedAt;
      final container = _container(database, clock: () => now);
      addTearDown(container.dispose);
      _listen(container);
      final notifier = container.read(activeWorkoutCommandsProvider.notifier);

      await notifier.startWorkout(
        regionId: catalog.regionId,
        muscleGroupIds: [catalog.chestId],
      );
      await _waitFor(container, (_) => true);
      await notifier.addExercise(exerciseId: catalog.benchId);
      final withExercise = await _waitFor(
        container,
        (session) => session.exercises.isNotEmpty,
      );
      final lastSetAt = startedAt.add(const Duration(minutes: 25));
      for (final savedAt in [
        startedAt.add(const Duration(minutes: 10)),
        lastSetAt,
      ]) {
        now = savedAt;
        await notifier.logSet(
          sessionExerciseId: withExercise.exercises.single.id,
          kg: 60,
          reps: 8,
        );
      }
      final logged = await _waitFor(
        container,
        (session) => session.exercises.single.sets.length == 2,
      );
      expect(
        logged.exercises.single.sets.last.savedAt!.isAtSameMomentAs(lastSetAt),
        isTrue,
      );

      now = startedAt.add(const Duration(hours: 8));
      await notifier.finishStaleWorkout();

      await _waitUntilAbsent(container);
      expect(container.read(activeWorkoutCommandsProvider), isNull);
      final stored = await database.select(database.workouts).getSingle();
      expect(stored.status, WorkoutStatus.completed);
      expect(stored.endedAt!.isAtSameMomentAs(lastSetAt), isTrue);
      expect(stored.startedAt.isAtSameMomentAs(startedAt), isTrue);
    },
  );

  test(
    'createCustomExercise reports the existing exercise for a duplicate name',
    () async {
      final container = _container(database);
      addTearDown(container.dispose);
      _listen(container);
      final notifier = container.read(activeWorkoutCommandsProvider.notifier);

      await notifier.startWorkout(
        regionId: catalog.regionId,
        muscleGroupIds: [catalog.chestId],
      );
      await _waitFor(container, (_) => true);

      await notifier.createCustomExercise(
        name: '  bench press  ',
        muscleGroupId: catalog.chestId,
      );

      final notice = container.read(activeWorkoutCommandsProvider);
      expect(notice, isA<ActiveWorkoutDuplicateName>());
      expect(
        (notice! as ActiveWorkoutDuplicateName).exercise.id,
        catalog.benchId,
      );
      final session = await _waitFor(container, (_) => true);
      expect(session.exercises, isEmpty);
    },
  );

  test('previousSets returns the completed session of that exercise', () async {
    final container = _container(database);
    addTearDown(container.dispose);
    _listen(container);
    final notifier = container.read(activeWorkoutCommandsProvider.notifier);

    await notifier.startWorkout(
      regionId: catalog.regionId,
      muscleGroupIds: [catalog.chestId],
    );
    await _waitFor(container, (_) => true);
    await notifier.addExercise(exerciseId: catalog.benchId);
    final firstExercise = await _waitFor(
      container,
      (session) => session.exercises.isNotEmpty,
    );
    final planned = FinishWorkout.defaultPlannedSetsPerExercise;
    for (var index = 0; index < planned; index++) {
      await notifier.logSet(
        sessionExerciseId: firstExercise.exercises.single.id,
        kg: 50,
        reps: 5,
      );
    }
    await _waitFor(
      container,
      (session) => session.exercises.single.sets.length == planned,
    );
    await notifier.requestFinish();
    await _waitUntilAbsent(container);
    await (database.update(database.workouts)
          ..where((row) => row.status.equalsValue(WorkoutStatus.completed)))
        .write(WorkoutsCompanion(endedAt: Value(DateTime.utc(2020))));

    await notifier.startWorkout(
      regionId: catalog.regionId,
      muscleGroupIds: [catalog.chestId],
    );
    await _waitFor(container, (_) => true);

    container.listen(previousSetsProvider(catalog.benchId), (_, _) {});
    final previous = await container.read(
      previousSetsProvider(catalog.benchId).future,
    );
    expect(previous, hasLength(planned));
    expect(previous.first.kg, 50);
  });
}

final _restClock = DateTime.utc(2026, 11, 14, 8);

ProviderContainer _container(
  AppDatabase database, {
  DateTime Function()? clock,
}) {
  return ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWith((ref) => database),
      workoutClockProvider.overrideWith((ref) => clock ?? () => _restClock),
    ],
  );
}

void _listen(ProviderContainer container) {
  container.listen(activeWorkoutProvider, (_, _) {});
  container.listen(activeWorkoutCommandsProvider, (_, _) {});
  container.listen(restTimerProvider, (_, _) {});
}

Future<WorkoutSession> _waitFor(
  ProviderContainer container,
  bool Function(WorkoutSession session) ready,
) async {
  for (var attempt = 0; attempt < 50; attempt++) {
    final async = container.read(activeWorkoutProvider);
    if (async case AsyncData(:final value?) when ready(value)) {
      return value;
    }
    await Future<void>.delayed(const Duration(milliseconds: 20));
  }
  fail('timed out waiting for the active session');
}

Future<void> _waitUntilAbsent(ProviderContainer container) async {
  for (var attempt = 0; attempt < 50; attempt++) {
    final async = container.read(activeWorkoutProvider);
    if (async case AsyncData(value: null)) return;
    await Future<void>.delayed(const Duration(milliseconds: 20));
  }
  fail('timed out waiting for the session to close');
}

class _Catalog {
  const _Catalog({
    required this.regionId,
    required this.chestId,
    required this.tricepsId,
    required this.benchId,
  });

  final int regionId;
  final int chestId;
  final int tricepsId;
  final int benchId;
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
  return _Catalog(
    regionId: regionId,
    chestId: chestId,
    tricepsId: tricepsId,
    benchId: benchId,
  );
}
