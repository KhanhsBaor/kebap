import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kebap/core/db/app_database.dart';
import 'package:kebap/core/db/app_database_provider.dart';
import 'package:kebap/core/theme/kebap_theme.dart';
import 'package:kebap/features/workout/presentation/providers/active_workout.dart';
import 'package:kebap/features/workout/presentation/providers/active_workout_notifier.dart';
import 'package:kebap/features/workout/presentation/providers/rest_timer_notifier.dart';
import 'package:kebap/features/workout/presentation/screens/active_workout_screen.dart';
import 'package:kebap/features/workout/presentation/widgets/custom_exercise_sheet.dart';
import 'package:kebap/l10n/app_localizations.dart';

void main() {
  late AppDatabase database;
  late _Catalog catalog;
  final clock = DateTime.utc(2026, 11, 15, 10);

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory(), seedOnOpen: false);
    catalog = await _seed(database);
  });

  tearDown(() async {
    await database.close();
  });

  void usePhoneSurface(WidgetTester tester) {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Future<_Harness> pumpActive(WidgetTester tester, {List<int>? groups}) async {
    usePhoneSurface(tester);
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
          muscleGroupIds: groups ?? [catalog.chestId, catalog.tricepsId],
        );
    await _until(
      tester,
      () => container.read(activeWorkoutProvider).asData?.value != null,
    );
    return _Harness(tester, container, catalog);
  }

  Future<_Harness> openForm(
    WidgetTester tester, {
    List<int>? groups,
    int? initialGroupId,
    String initialName = '',
  }) async {
    final muscleGroups = groups ?? [catalog.chestId, catalog.tricepsId];
    final harness = await pumpActive(tester, groups: muscleGroups);
    final nav = tester.state<NavigatorState>(find.byType(Navigator));
    // Keep the root ProviderScope alive; push S06 as a route on top.
    unawaited(
      nav.push<int>(
        MaterialPageRoute(
          builder: (context) => Scaffold(
            body: CustomExerciseSheet(
              initialName: initialName,
              initialGroupId: initialGroupId ?? muscleGroups.first,
            ),
          ),
        ),
      ),
    );
    await _until(
      tester,
      () =>
          find.byKey(const Key('custom-exercise-sheet')).evaluate().isNotEmpty,
    );
    return harness;
  }

  Future<void> unmount(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 20));
  }

  testWidgets('add button is disabled for blank names', (tester) async {
    await openForm(tester);
    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('add-custom-to-workout')))
          .onPressed,
      isNull,
    );

    await tester.enterText(
      find.byKey(const Key('custom-exercise-name')),
      '   ',
    );
    await tester.pump();
    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('add-custom-to-workout')))
          .onPressed,
      isNull,
    );

    await tester.enterText(
      find.byKey(const Key('custom-exercise-name')),
      'Cable Fly Low',
    );
    await tester.pump();
    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('add-custom-to-workout')))
          .onPressed,
      isNotNull,
    );
    await unmount(tester);
  });

  testWidgets('multi-group session shows chips', (tester) async {
    await openForm(tester);
    expect(
      find.byKey(const Key('custom-exercise-group-chips')),
      findsOneWidget,
    );
    expect(
      find.byKey(Key('custom-group-chip-${catalog.chestId}')),
      findsOneWidget,
    );
    expect(
      find.byKey(Key('custom-group-chip-${catalog.tricepsId}')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('custom-exercise-single-group')), findsNothing);
    await unmount(tester);
  });

  testWidgets('single-group session hides chips', (tester) async {
    await openForm(tester, groups: [catalog.chestId]);
    expect(find.byKey(const Key('custom-exercise-group-chips')), findsNothing);
    expect(
      find.byKey(const Key('custom-exercise-single-group')),
      findsOneWidget,
    );
    expect(find.text('Chest'), findsWidgets);
    await unmount(tester);
  });

  testWidgets('S06 opens with Triceps selected when that group is initial', (
    tester,
  ) async {
    // Add-sheet "search push" leaves only the Triceps section visible; the
    // sheet then passes that id. Covered here + unit test of the helper.
    await openForm(tester, initialGroupId: catalog.tricepsId);
    final chip = tester.widget<ChoiceChip>(
      find.descendant(
        of: find.byKey(Key('custom-group-chip-${catalog.tricepsId}')),
        matching: find.byType(ChoiceChip),
      ),
    );
    expect(chip.selected, isTrue);
    await unmount(tester);
  });

  testWidgets('S06 prefills the name from an empty search', (tester) async {
    await openForm(tester, initialName: 'zzz');
    expect(
      tester
          .widget<TextField>(find.byKey(const Key('custom-exercise-name')))
          .controller!
          .text,
      'zzz',
    );
    await unmount(tester);
  });

  testWidgets('creates Cable Fly Low on Chest and shows it in the session', (
    tester,
  ) async {
    final harness = await openForm(tester, initialGroupId: catalog.chestId);
    await tester.enterText(
      find.byKey(const Key('custom-exercise-name')),
      'Cable Fly Low',
    );
    await tester.pump();
    await tester.tap(find.byKey(const Key('add-custom-to-workout')));
    await _until(
      tester,
      () =>
          harness.container
              .read(activeWorkoutProvider)
              .value
              ?.exercises
              .length ==
          1,
    );
    await _until(
      tester,
      () => find.byKey(const Key('custom-exercise-sheet')).evaluate().isEmpty,
    );

    final session = harness.container.read(activeWorkoutProvider).value!;
    expect(session.exercises, hasLength(1));
    final custom = await (database.select(
      database.exercises,
    )..where((row) => row.isCustom.equals(true))).getSingle();
    expect(custom.nameEn, 'Cable Fly Low');
    expect(custom.muscleGroupId, catalog.chestId);
    expect(custom.equipment, isNull);
    expect(session.exercises.single.exerciseId, custom.id);
    expect(find.text('Cable Fly Low'), findsOneWidget);
    await unmount(tester);
  });

  testWidgets('duplicate name shows error and use-existing adds the seed', (
    tester,
  ) async {
    final harness = await openForm(tester, initialGroupId: catalog.chestId);
    await tester.enterText(
      find.byKey(const Key('custom-exercise-name')),
      'bench press',
    );
    await tester.pump();
    await tester.tap(find.byKey(const Key('add-custom-to-workout')));
    await _until(
      tester,
      () =>
          find.byKey(const Key('use-existing-exercise')).evaluate().isNotEmpty,
    );
    expect(find.text('This exercise is already in the group.'), findsOneWidget);

    await tester.tap(find.byKey(const Key('use-existing-exercise')));
    await _until(
      tester,
      () =>
          harness.container
              .read(activeWorkoutProvider)
              .value
              ?.exercises
              .length ==
          1,
    );
    final session = harness.container.read(activeWorkoutProvider).value!;
    expect(session.exercises.single.exerciseId, catalog.benchId);
    expect(
      await (database.select(
        database.exercises,
      )..where((row) => row.isCustom.equals(true))).get(),
      isEmpty,
    );
    await unmount(tester);
  });

  testWidgets('same name on another group of the session is allowed', (
    tester,
  ) async {
    final harness = await openForm(tester, initialGroupId: catalog.tricepsId);
    await tester.enterText(
      find.byKey(const Key('custom-exercise-name')),
      'Bench press',
    );
    await tester.pump();
    await tester.tap(find.byKey(const Key('add-custom-to-workout')));
    await _until(
      tester,
      () =>
          harness.container
              .read(activeWorkoutProvider)
              .value
              ?.exercises
              .isNotEmpty ==
          true,
    );
    final custom = await (database.select(
      database.exercises,
    )..where((row) => row.isCustom.equals(true))).getSingle();
    expect(custom.muscleGroupId, catalog.tricepsId);
    expect(custom.nameEn, 'Bench press');
    await unmount(tester);
  });

  testWidgets('name field, chips and submit are at least 48 tall', (
    tester,
  ) async {
    await openForm(tester);
    expect(
      tester.getSize(find.byKey(const Key('custom-exercise-name'))).height,
      greaterThanOrEqualTo(48),
    );
    expect(
      tester
          .getSize(find.byKey(Key('custom-group-chip-${catalog.chestId}')))
          .height,
      greaterThanOrEqualTo(48),
    );
    expect(
      tester.getSize(find.byKey(const Key('add-custom-to-workout'))).height,
      greaterThanOrEqualTo(48),
    );
    await unmount(tester);
  });
}

class _Harness {
  _Harness(this.tester, this.container, this.catalog);

  final WidgetTester tester;
  final ProviderContainer container;
  final _Catalog catalog;
}

Future<void> _until(WidgetTester tester, bool Function() ready) async {
  for (var attempt = 0; attempt < 80; attempt++) {
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pump(const Duration(milliseconds: 20));
    if (ready()) return;
  }
  fail('timed out');
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
    required this.tricepsId,
    required this.benchId,
  });

  final int regionId;
  final int chestId;
  final int tricepsId;
  final int benchId;
}

Future<_Catalog> _seed(AppDatabase database) async {
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
  for (var i = 0; i < 8; i++) {
    await database
        .into(database.exercises)
        .insert(
          ExercisesCompanion.insert(
            muscleGroupId: chestId,
            nameEn: 'Chest move $i',
          ),
        );
  }
  await database
      .into(database.exercises)
      .insert(
        ExercisesCompanion.insert(muscleGroupId: tricepsId, nameEn: 'Pushdown'),
      );
  return _Catalog(
    regionId: regionId,
    chestId: chestId,
    tricepsId: tricepsId,
    benchId: benchId,
  );
}
