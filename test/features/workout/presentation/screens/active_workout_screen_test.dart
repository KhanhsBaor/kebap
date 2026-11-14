import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kebap/core/db/app_database.dart';
import 'package:kebap/core/db/app_database_provider.dart';
import 'package:kebap/core/theme/kebap_theme.dart';
import 'package:kebap/features/workout/data/repositories/workout_repository_impl.dart';
import 'package:kebap/features/workout/presentation/providers/active_workout.dart';
import 'package:kebap/features/workout/presentation/providers/active_workout_notifier.dart';
import 'package:kebap/features/workout/presentation/providers/rest_timer_notifier.dart';
import 'package:kebap/features/workout/presentation/screens/active_workout_screen.dart';
import 'package:kebap/l10n/app_localizations.dart';

void main() {
  late AppDatabase database;
  late _Catalog catalog;
  final clock = DateTime.utc(2026, 11, 14, 10);

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory(), seedOnOpen: false);
    catalog = await _seed(database);
  });

  tearDown(() => database.close());

  testWidgets('keeping the prefill then saving is one tap', (tester) async {
    final harness = await _open(tester, database, catalog, clock);
    final taps = await harness.tap(
      find.byKey(Key('save-set-${catalog.benchId}-1')),
    );
    expect(taps, 1);
    await harness.until(find.byKey(Key('set-check-${catalog.benchId}-1')));
    final session = harness.container.read(activeWorkoutProvider).value!;
    expect(session.exercises.single.sets.single.reps, 8);
    expect(session.exercises.single.sets.single.kg, isNull);
    await harness.unmount();
  });

  testWidgets('the next set copies the previous one in one tap', (
    tester,
  ) async {
    final harness = await _open(tester, database, catalog, clock);
    await harness.tap(find.byKey(Key('save-set-${catalog.benchId}-1')));
    await harness.until(find.byKey(Key('set-check-${catalog.benchId}-1')));
    harness.taps = 0;
    final taps = await harness.tap(
      find.byKey(Key('save-set-${catalog.benchId}-2')),
    );
    expect(taps, 1);
    await harness.until(find.byKey(Key('set-check-${catalog.benchId}-2')));
    final sets = harness.container
        .read(activeWorkoutProvider)
        .value!
        .exercises
        .single
        .sets;
    expect(sets.map((set) => set.reps), [8, 8]);
    await harness.unmount();
  });

  testWidgets('one kg step then save is two taps', (tester) async {
    final harness = await _open(tester, database, catalog, clock);
    await harness.tap(find.byKey(Key('kg-plus-${catalog.benchId}-1')));
    final taps = await harness.tap(
      find.byKey(Key('save-set-${catalog.benchId}-1')),
    );
    expect(taps, 2);
    await harness.until(find.byKey(Key('set-check-${catalog.benchId}-1')));
    expect(
      harness.container
          .read(activeWorkoutProvider)
          .value!
          .exercises
          .single
          .sets
          .single
          .kg,
      2.5,
    );
    await harness.unmount();
  });

  testWidgets('typing 62.5 on the pad is six taps', (tester) async {
    final harness = await _open(tester, database, catalog, clock);
    await harness.tap(find.byKey(Key('kg-value-${catalog.benchId}-1')));
    await harness.tap(find.byKey(const Key('pad-6')));
    await harness.tap(find.byKey(const Key('pad-2')));
    await harness.tap(find.byKey(const Key('pad-decimal')));
    await harness.tap(find.byKey(const Key('pad-5')));
    final taps = await harness.tap(
      find.byKey(Key('save-set-${catalog.benchId}-1')),
    );
    expect(taps, 6);
    await harness.until(find.byKey(Key('set-check-${catalog.benchId}-1')));
    expect(
      harness.container
          .read(activeWorkoutProvider)
          .value!
          .exercises
          .single
          .sets
          .single
          .kg,
      62.5,
    );
    await harness.unmount();
  });

  testWidgets('the check removes the set and the index marks warmup', (
    tester,
  ) async {
    final harness = await _open(tester, database, catalog, clock);
    await harness.tap(find.byKey(Key('set-index-${catalog.benchId}-1')));
    expect(find.text('W'), findsOneWidget);
    await harness.tap(find.byKey(Key('save-set-${catalog.benchId}-1')));
    await harness.until(find.byKey(Key('set-check-${catalog.benchId}-1')));
    expect(find.text('90'), findsOneWidget);

    await harness.tap(find.byKey(Key('set-check-${catalog.benchId}-1')));
    await harness.untilAbsent(
      find.byKey(Key('set-check-${catalog.benchId}-1')),
    );
    expect(
      harness.container
          .read(activeWorkoutProvider)
          .value!
          .exercises
          .single
          .sets,
      isEmpty,
    );
    expect(find.text('90'), findsOneWidget);
    await harness.unmount();
  });

  testWidgets('rest starts at 90 and plus 15 shows 105', (tester) async {
    final harness = await _open(tester, database, catalog, clock);
    await harness.tap(find.byKey(Key('save-set-${catalog.benchId}-1')));
    await harness.until(find.text('90'));
    await harness.tap(find.byKey(const Key('rest-plus')));
    expect(find.text('105'), findsOneWidget);
    await harness.unmount();
  });

  testWidgets('previous ignores an open session and shows a dash', (
    tester,
  ) async {
    final harness = await _open(tester, database, catalog, clock);
    expect(find.text('No previous session'), findsOneWidget);
    expect(find.text('—'), findsWidgets);
    await harness.unmount();
  });

  testWidgets('previous shows the same position from the completed session', (
    tester,
  ) async {
    final workouts = WorkoutRepositoryImpl(database);
    final earlier = await workouts.insertInProgress(
      startedAt: DateTime.utc(2020),
      muscleGroupIds: [catalog.chestId],
    );
    final exercise = await workouts.addExercise(
      workoutId: earlier.id,
      exerciseId: catalog.benchId,
    );
    await workouts.insertSet(
      sessionExerciseId: exercise.id,
      position: 1,
      kg: 40,
      reps: 8,
    );
    await workouts.complete(id: earlier.id, endedAt: DateTime.utc(2020, 1, 2));

    final harness = await _open(tester, database, catalog, clock);
    expect(find.text('40×8'), findsWidgets);
    expect(find.byKey(Key('previous-${catalog.benchId}-1')), findsOneWidget);
    expect(
      tester
          .widget<Text>(find.byKey(Key('previous-${catalog.benchId}-1')))
          .data,
      '40×8',
    );
    expect(
      tester
          .widget<Text>(find.byKey(Key('previous-${catalog.benchId}-2')))
          .data,
      '—',
    );
    await harness.unmount();
  });

  testWidgets('the sheet hides exercises outside the session groups', (
    tester,
  ) async {
    final harness = await _open(tester, database, catalog, clock);
    await harness.tap(
      find.byKey(const Key('add-exercise'), skipOffstage: false),
    );
    await _until(tester, find.byKey(Key('exercise-option-${catalog.benchId}')));
    expect(
      find.byKey(Key('exercise-option-${catalog.benchId}')),
      findsOneWidget,
    );
    expect(find.byKey(Key('exercise-option-${catalog.squatId}')), findsNothing);
    expect(
      find.byKey(Key('exercise-option-${catalog.pushdownId}')),
      findsNothing,
    );
    expect(find.text('Create exercise'), findsOneWidget);
    await tester.tapAt(const Offset(10, 10));
    await tester.pump();
    await harness.unmount();
  });

  testWidgets('save is at least 56 tall and a stepper is at least 48', (
    tester,
  ) async {
    final harness = await _open(tester, database, catalog, clock);
    final save = tester.getSize(
      find.byKey(Key('save-set-${catalog.benchId}-1')),
    );
    final plus = tester.getSize(
      find.byKey(Key('kg-plus-${catalog.benchId}-1')),
    );
    expect(save.height, greaterThanOrEqualTo(56));
    expect(plus.width, greaterThanOrEqualTo(48));
    expect(plus.height, greaterThanOrEqualTo(48));
    await harness.unmount();
  });
}

class _Harness {
  _Harness(this.tester, this.container);

  final WidgetTester tester;
  final ProviderContainer container;
  var taps = 0;

  Future<int> tap(Finder finder) async {
    taps += 1;
    await _reveal(finder);
    await tester.tap(finder);
    await tester.pump();
    return taps;
  }

  Future<void> _reveal(Finder finder) async {
    final element = finder.evaluate().single;
    await Scrollable.ensureVisible(element, alignment: 0.5);
    await tester.pump();
  }

  Future<void> until(Finder finder) async {
    for (var attempt = 0; attempt < 40; attempt++) {
      if (finder.evaluate().isNotEmpty) return;
      await tester.pump(const Duration(milliseconds: 20));
    }
    fail('timed out waiting for $finder');
  }

  Future<void> untilAbsent(Finder finder) async {
    for (var attempt = 0; attempt < 40; attempt++) {
      if (finder.evaluate().isEmpty) return;
      await tester.pump(const Duration(milliseconds: 20));
    }
    fail('timed out waiting for $finder to leave');
  }

  Future<void> unmount() async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 20));
  }
}

Future<_Harness> _open(
  WidgetTester tester,
  AppDatabase database,
  _Catalog catalog,
  DateTime clock,
) async {
  await tester.pumpWidget(_app(database, clock));
  await tester.pump();
  final container = ProviderScope.containerOf(
    tester.element(find.byType(ActiveWorkoutScreen)),
  );
  container.listen(activeWorkoutProvider, (_, _) {});
  await container
      .read(activeWorkoutCommandsProvider.notifier)
      .startWorkout(
        regionId: catalog.regionId,
        muscleGroupIds: [catalog.chestId],
      );
  await tester.pump();
  await container
      .read(activeWorkoutCommandsProvider.notifier)
      .addExercise(exerciseId: catalog.benchId);
  await tester.pump();
  await _until(tester, find.text('Bench press'));
  return _Harness(tester, container);
}

Future<void> _until(WidgetTester tester, Finder finder) async {
  for (var attempt = 0; attempt < 40; attempt++) {
    if (finder.evaluate().isNotEmpty) return;
    await tester.pump(const Duration(milliseconds: 20));
  }
  fail('timed out waiting for $finder');
}

Widget _app(AppDatabase database, DateTime clock) {
  return ProviderScope(
    overrides: [
      appDatabaseProvider.overrideWith((ref) => database),
      workoutClockProvider.overrideWith(
        (ref) =>
            () => clock,
      ),
    ],
    child: MaterialApp(
      theme: KebapTheme.light(),
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const ActiveWorkoutScreen(),
    ),
  );
}

class _Catalog {
  const _Catalog({
    required this.regionId,
    required this.chestId,
    required this.benchId,
    required this.pushdownId,
    required this.squatId,
  });

  final int regionId;
  final int chestId;
  final int benchId;
  final int pushdownId;
  final int squatId;
}

Future<_Catalog> _seed(AppDatabase database) async {
  final regionId = await database
      .into(database.regions)
      .insert(
        RegionsCompanion.insert(slug: 'upper_body', nameEn: 'Upper body'),
      );
  final lowerId = await database
      .into(database.regions)
      .insert(
        RegionsCompanion.insert(slug: 'lower_body', nameEn: 'Lower body'),
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
  final quadsId = await database
      .into(database.muscleGroups)
      .insert(
        MuscleGroupsCompanion.insert(
          regionId: lowerId,
          slug: 'quadriceps',
          nameEn: 'Quadriceps',
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
  final squatId = await database
      .into(database.exercises)
      .insert(
        ExercisesCompanion.insert(muscleGroupId: quadsId, nameEn: 'Squat'),
      );
  return _Catalog(
    regionId: regionId,
    chestId: chestId,
    benchId: benchId,
    pushdownId: pushdownId,
    squatId: squatId,
  );
}
