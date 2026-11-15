import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kebap/core/db/app_database.dart';
import 'package:kebap/core/db/app_database_provider.dart';
import 'package:kebap/core/db/db_enums.dart';
import 'package:kebap/core/router/app_routes.dart';
import 'package:kebap/core/theme/kebap_colors.dart';
import 'package:kebap/core/theme/kebap_theme.dart';
import 'package:kebap/features/today/presentation/screens/today_screen.dart';
import 'package:kebap/features/workout/data/repositories/workout_repository_impl.dart';
import 'package:kebap/features/workout/presentation/providers/rest_timer_notifier.dart';
import 'package:kebap/features/workout/presentation/screens/active_workout_screen.dart';
import 'package:kebap/features/workout/presentation/screens/start_workout_screen.dart';
import 'package:kebap/l10n/app_localizations.dart';

final _startedAt = DateTime.utc(2026, 11, 15, 8, 30);
final _lastSetAt = DateTime.utc(2026, 11, 15, 8, 55);

void main() {
  late AppDatabase database;
  late _Catalog catalog;
  late DateTime now;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory(), seedOnOpen: false);
    catalog = await _seedCatalog(database);
    now = _lastSetAt.add(const Duration(hours: 1));
  });

  tearDown(() => database.close());

  Future<void> openToday(WidgetTester tester, {Key? key}) async {
    final router = GoRouter(
      initialLocation: AppRoutes.today,
      routes: [
        GoRoute(
          path: AppRoutes.today,
          name: AppRoutes.todayName,
          builder: (context, state) => const TodayScreen(),
        ),
        GoRoute(
          path: AppRoutes.startWorkout,
          name: AppRoutes.startWorkoutName,
          builder: (context, state) => const StartWorkoutScreen(),
        ),
        GoRoute(
          path: AppRoutes.activeWorkout,
          name: AppRoutes.activeWorkoutName,
          builder: (context, state) => const ActiveWorkoutScreen(),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        key: key,
        overrides: [
          appDatabaseProvider.overrideWith((ref) => database),
          workoutClockProvider.overrideWith(
            (ref) =>
                () => now,
          ),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          theme: KebapTheme.light(),
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await _until(tester, find.byKey(const ValueKey('today-screen')));
  }

  Future<void> unmount(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 20));
  }

  Future<List<Workout>> workouts(WidgetTester tester) async {
    return (await tester.runAsync(
      () => database.select(database.workouts).get(),
    ))!;
  }

  testWidgets('no open session shows the start button and no banner', (
    tester,
  ) async {
    await openToday(tester);
    await _until(tester, find.byKey(const ValueKey('today-start-workout')));

    expect(find.byKey(const ValueKey('in-progress-banner')), findsNothing);
    await unmount(tester);
  });

  testWidgets('banner replaces start and shows groups, sets and start time', (
    tester,
  ) async {
    await tester.runAsync(() => _openSession(database, catalog, sets: 2));
    await openToday(tester);
    await _until(tester, find.byKey(const ValueKey('in-progress-banner')));

    expect(find.byKey(const ValueKey('today-start-workout')), findsNothing);
    expect(find.text('Workout in progress'), findsOneWidget);
    expect(find.text('Triceps · Chest'), findsOneWidget);
    final time = DateFormat.Hm('en').format(_startedAt.toLocal());
    final sameDay = _sameLocalDay(_startedAt, now);
    final expectedStart = sameDay
        ? time
        : '${DateFormat.yMd('en').format(_startedAt.toLocal())} $time';
    expect(find.text('2 sets saved · Started $expectedStart'), findsOneWidget);
    expect(find.byType(ActiveWorkoutScreen), findsNothing);

    for (final key in ['today-continue-workout', 'today-discard-workout']) {
      expect(
        tester.getSize(find.byKey(ValueKey(key))).height,
        greaterThanOrEqualTo(48),
      );
    }
    final discard = tester.widget<OutlinedButton>(
      find.byKey(const ValueKey('today-discard-workout')),
    );
    expect(
      discard.style?.foregroundColor?.resolve({}),
      KebapColors.light.trendDown,
    );
    await unmount(tester);
  });

  testWidgets('a rebuilt ProviderScope on the same database keeps 2 sets', (
    tester,
  ) async {
    await tester.runAsync(() => _openSession(database, catalog, sets: 2));
    await openToday(tester, key: const ValueKey('first'));
    await _until(tester, find.textContaining('2 sets saved'));
    await unmount(tester);

    await openToday(tester, key: const ValueKey('second'));
    await _until(tester, find.textContaining('2 sets saved'));
    expect(find.byType(ActiveWorkoutScreen), findsNothing);
    await unmount(tester);
  });

  testWidgets('Continue opens S05', (tester) async {
    await tester.runAsync(() => _openSession(database, catalog, sets: 2));
    await openToday(tester);
    await _until(tester, find.byKey(const ValueKey('today-continue-workout')));

    await tester.tap(find.byKey(const ValueKey('today-continue-workout')));
    await _until(tester, find.byType(ActiveWorkoutScreen));
    await unmount(tester);
  });

  testWidgets('discard with no sets deletes at once and stays on Today', (
    tester,
  ) async {
    await tester.runAsync(() => _openSession(database, catalog, sets: 0));
    await openToday(tester);
    await _until(tester, find.byKey(const ValueKey('today-discard-workout')));

    await tester.tap(find.byKey(const ValueKey('today-discard-workout')));
    await _until(tester, find.byKey(const ValueKey('today-start-workout')));

    expect(find.byType(AlertDialog), findsNothing);
    expect(await workouts(tester), isEmpty);
    expect(find.byKey(const ValueKey('today-screen')), findsOneWidget);
    await unmount(tester);
  });

  testWidgets('discard with 2 sets asks, keep is safe, confirm deletes all', (
    tester,
  ) async {
    await tester.runAsync(() => _openSession(database, catalog, sets: 2));
    await openToday(tester);
    await _until(tester, find.byKey(const ValueKey('today-discard-workout')));

    await tester.tap(find.byKey(const ValueKey('today-discard-workout')));
    await _until(tester, find.byType(AlertDialog));
    expect(
      find.text('Discard workout? 2 saved sets will be deleted.'),
      findsOneWidget,
    );
    final keep = tester.widget<FilledButton>(
      find.byKey(const ValueKey('discard-keep-training')),
    );
    expect(keep.autofocus, isTrue);
    expect(find.text('Keep training'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('discard-keep-training')));
    await _until(tester, find.byType(AlertDialog), absent: true);
    expect(await workouts(tester), hasLength(1));

    await tester.tap(find.byKey(const ValueKey('today-discard-workout')));
    await _until(tester, find.byKey(const ValueKey('discard-confirm')));
    await tester.tap(find.byKey(const ValueKey('discard-confirm')));
    await _until(tester, find.byKey(const ValueKey('today-start-workout')));

    final remaining = await tester.runAsync(
      () async => [
        await database.select(database.workouts).get(),
        await database.select(database.workoutMuscleGroups).get(),
        await database.select(database.workoutExercises).get(),
        await database.select(database.workoutSets).get(),
      ],
    );
    expect(remaining!.every((rows) => rows.isEmpty), isTrue);
    expect(find.byType(ActiveWorkoutScreen), findsNothing);
    await unmount(tester);
  });

  testWidgets('cold start 7h after the last set asks, save ends at that set', (
    tester,
  ) async {
    await tester.runAsync(() => _openSession(database, catalog, sets: 2));
    now = _lastSetAt.add(const Duration(hours: 7));
    await openToday(tester);
    await _until(tester, find.byType(AlertDialog));

    final time = DateFormat.Hm('en').format(_startedAt.toLocal());
    expect(find.textContaining('started at'), findsOneWidget);
    expect(find.textContaining(time), findsWidgets);
    expect(find.byKey(const ValueKey('stale-resume')), findsOneWidget);
    expect(find.byKey(const ValueKey('stale-discard')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('stale-save')));
    await _until(tester, find.byKey(const ValueKey('today-start-workout')));

    final stored = (await workouts(tester)).single;
    expect(stored.status, WorkoutStatus.completed);
    expect(stored.endedAt!.isAtSameMomentAs(_lastSetAt), isTrue);
    expect(find.byType(ActiveWorkoutScreen), findsNothing);
    await unmount(tester);
  });

  testWidgets('a stale session without sets has no save option', (
    tester,
  ) async {
    await tester.runAsync(() => _openSession(database, catalog, sets: 0));
    now = _startedAt.add(const Duration(hours: 7));
    await openToday(tester);
    await _until(tester, find.byType(AlertDialog));

    expect(find.byKey(const ValueKey('stale-save')), findsNothing);
    await tester.tap(find.byKey(const ValueKey('stale-discard')));
    await _until(tester, find.byKey(const ValueKey('today-start-workout')));
    expect(await workouts(tester), isEmpty);
    await unmount(tester);
  });

  testWidgets('stale continue opens S05 and is not asked again', (
    tester,
  ) async {
    await tester.runAsync(() => _openSession(database, catalog, sets: 2));
    now = _lastSetAt.add(const Duration(hours: 7));
    await openToday(tester);
    await _until(tester, find.byKey(const ValueKey('stale-resume')));

    await tester.tap(find.byKey(const ValueKey('stale-resume')));
    await _until(tester, find.byType(ActiveWorkoutScreen));

    final router = GoRouter.of(
      tester.element(find.byType(ActiveWorkoutScreen)),
    );
    router.pop();
    await _until(tester, find.byType(ActiveWorkoutScreen), absent: true);
    expect(find.byType(AlertDialog), findsNothing);

    await tester.tap(find.byKey(const ValueKey('today-continue-workout')));
    await _until(tester, find.byType(ActiveWorkoutScreen));
    expect(find.byType(AlertDialog), findsNothing);
    await unmount(tester);
  });
}

bool _sameLocalDay(DateTime a, DateTime b) {
  final left = a.toLocal();
  final right = b.toLocal();
  return left.year == right.year &&
      left.month == right.month &&
      left.day == right.day;
}

Future<void> _until(
  WidgetTester tester,
  Finder finder, {
  bool absent = false,
}) async {
  for (var attempt = 0; attempt < 100; attempt++) {
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pump(const Duration(milliseconds: 20));
    if (finder.evaluate().isNotEmpty != absent) return;
  }
  fail('timed out waiting for $finder${absent ? ' to go away' : ''}');
}

Future<void> _openSession(
  AppDatabase database,
  _Catalog catalog, {
  required int sets,
}) async {
  final repository = WorkoutRepositoryImpl(database);
  final session = await repository.insertInProgress(
    startedAt: _startedAt,
    muscleGroupIds: [catalog.tricepsId, catalog.chestId],
  );
  if (sets == 0) return;
  final added = await repository.addExercise(
    workoutId: session.id,
    exerciseId: catalog.benchId,
  );
  for (var position = 1; position <= sets; position++) {
    await repository.insertSet(
      sessionExerciseId: added.id,
      position: position,
      kg: 60,
      reps: 8,
      savedAt: position == sets
          ? _lastSetAt
          : _startedAt.add(const Duration(minutes: 10)),
    );
  }
}

class _Catalog {
  const _Catalog({
    required this.chestId,
    required this.tricepsId,
    required this.benchId,
  });

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
  return _Catalog(chestId: chestId, tricepsId: tricepsId, benchId: benchId);
}
