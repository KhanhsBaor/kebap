import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kebap/core/router/app_routes.dart';
import 'package:kebap/core/theme/kebap_colors.dart';
import 'package:kebap/core/theme/kebap_theme.dart';
import 'package:kebap/features/catalog/domain/entities/body_region.dart';
import 'package:kebap/features/catalog/domain/entities/exercise.dart';
import 'package:kebap/features/catalog/domain/entities/muscle_group.dart';
import 'package:kebap/features/catalog/presentation/providers/catalog_providers.dart';
import 'package:kebap/features/today/presentation/screens/today_screen.dart';
import 'package:kebap/features/workout/domain/entities/workout_session.dart';
import 'package:kebap/features/workout/domain/entities/workout_status.dart';
import 'package:kebap/features/workout/presentation/notices/active_workout_notice.dart';
import 'package:kebap/features/workout/presentation/providers/active_workout.dart';
import 'package:kebap/features/workout/presentation/providers/active_workout_exercises.dart';
import 'package:kebap/features/workout/presentation/providers/active_workout_notifier.dart';
import 'package:kebap/features/workout/presentation/screens/active_workout_screen.dart';
import 'package:kebap/features/workout/presentation/screens/start_workout_screen.dart';
import 'package:kebap/l10n/app_localizations.dart';

const _upper = BodyRegion(id: 1, slug: 'upper_body', nameEn: 'Upper body');
const _lower = BodyRegion(id: 2, slug: 'lower_body', nameEn: 'Lower body');
const _chest = MuscleGroup(id: 10, regionId: 1, slug: 'chest', nameEn: 'Chest');
const _triceps = MuscleGroup(
  id: 11,
  regionId: 1,
  slug: 'triceps',
  nameEn: 'Triceps',
);
const _quads = MuscleGroup(
  id: 20,
  regionId: 2,
  slug: 'quadriceps',
  nameEn: 'Quadriceps',
);

final _recordedStarts = <({int regionId, List<int> muscleGroupIds})>[];
var _cancelCount = 0;

class _RecordingCommands extends ActiveWorkoutCommands {
  @override
  ActiveWorkoutNotice? build() => null;

  @override
  Future<void> startWorkout({
    required int regionId,
    required List<int> muscleGroupIds,
  }) async {
    _recordedStarts.add((
      regionId: regionId,
      muscleGroupIds: List<int>.of(muscleGroupIds),
    ));
  }

  @override
  Future<void> cancelWorkout() async {
    _cancelCount += 1;
  }
}

void main() {
  setUp(() {
    _recordedStarts.clear();
    _cancelCount = 0;
  });

  testWidgets('start stays disabled until a muscle group is selected', (
    tester,
  ) async {
    for (final themeMode in [ThemeMode.light, ThemeMode.dark]) {
      final router = _router(AppRoutes.startWorkout);
      addTearDown(router.dispose);
      await tester.pumpWidget(_scope(router: router, themeMode: themeMode));
      await tester.pumpAndSettle();

      final button = tester.widget<FilledButton>(
        find.byKey(const ValueKey('start-workout-button')),
      );
      expect(button.onPressed, isNull);
      final colors = themeMode == ThemeMode.light
          ? KebapColors.light
          : KebapColors.dark;
      expect(
        button.style?.backgroundColor?.resolve({WidgetState.disabled}),
        colors.border,
      );
      expect(
        button.style?.foregroundColor?.resolve({WidgetState.disabled}),
        colors.muted,
      );
      expect(
        tester
            .getSize(find.byKey(const ValueKey('start-workout-button')))
            .height,
        greaterThanOrEqualTo(48),
      );
      expect(
        tester.getSize(find.byKey(const ValueKey('group-chest'))).height,
        greaterThanOrEqualTo(48),
      );
    }
  });

  testWidgets('Chest then Triceps keeps order and starts that workout', (
    tester,
  ) async {
    final router = _router(AppRoutes.today);
    addTearDown(router.dispose);
    await tester.pumpWidget(_scope(router: router));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('today-start-workout')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('start-workout-screen')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('group-chest')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('group-triceps')));
    await tester.pump();

    expect(
      tester.widget<Text>(find.byKey(const ValueKey('group-order-chest'))).data,
      '1',
    );
    expect(
      tester
          .widget<Text>(find.byKey(const ValueKey('group-order-triceps')))
          .data,
      '2',
    );

    final button = tester.widget<FilledButton>(
      find.byKey(const ValueKey('start-workout-button')),
    );
    expect(
      button.style?.backgroundColor?.resolve({}),
      KebapColors.light.primary,
    );

    await tester.tap(find.byKey(const ValueKey('start-workout-button')));
    await tester.pumpAndSettle();

    expect(_recordedStarts.single.regionId, _upper.id);
    expect(_recordedStarts.single.muscleGroupIds, [_chest.id, _triceps.id]);
    expect(find.byType(ActiveWorkoutScreen), findsOneWidget);
    expect(
      GoRouterState.of(
        tester.element(find.byType(ActiveWorkoutScreen)),
      ).uri.path,
      AppRoutes.activeWorkout,
    );
  });

  testWidgets('switching region clears the selected groups', (tester) async {
    final router = _router(AppRoutes.startWorkout);
    addTearDown(router.dispose);
    await tester.pumpWidget(_scope(router: router));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('group-chest')));
    await tester.pump();
    expect(find.byKey(const ValueKey('group-order-chest')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('region-lower_body')));
    await tester.pump();

    expect(find.byKey(const ValueKey('group-chest')), findsNothing);
    expect(find.byKey(const ValueKey('group-order-chest')), findsNothing);
    expect(find.byKey(const ValueKey('group-quadriceps')), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(
            find.byKey(const ValueKey('start-workout-button')),
          )
          .onPressed,
      isNull,
    );
  });

  testWidgets('an in-progress workout asks before a new one starts', (
    tester,
  ) async {
    final router = _router(AppRoutes.startWorkout);
    addTearDown(router.dispose);
    await tester.pumpWidget(
      _scope(
        router: router,
        session: WorkoutSession(
          id: 7,
          status: WorkoutStatus.inProgress,
          startedAt: DateTime.utc(2026, 11, 14),
          muscleGroupIds: [_chest.id],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('You have a workout in progress'), findsOneWidget);
    expect(find.text('Continue that workout'), findsOneWidget);
    expect(find.text('Discard and start a new one'), findsOneWidget);
  });

  testWidgets('continue from the in-progress dialog opens the workout', (
    tester,
  ) async {
    final router = _router(AppRoutes.startWorkout);
    addTearDown(router.dispose);
    await tester.pumpWidget(
      _scope(
        router: router,
        session: WorkoutSession(
          id: 7,
          status: WorkoutStatus.inProgress,
          startedAt: DateTime.utc(2026, 11, 14),
          muscleGroupIds: [_chest.id],
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('continue-that-workout')));
    await tester.pumpAndSettle();

    expect(find.byType(ActiveWorkoutScreen), findsOneWidget);
    expect(find.text('You have a workout in progress'), findsNothing);
  });

  testWidgets('discard from the in-progress dialog cancels the session', (
    tester,
  ) async {
    final router = _router(AppRoutes.startWorkout);
    addTearDown(router.dispose);
    await tester.pumpWidget(
      _scope(
        router: router,
        session: WorkoutSession(
          id: 7,
          status: WorkoutStatus.inProgress,
          startedAt: DateTime.utc(2026, 11, 14),
          muscleGroupIds: [_chest.id],
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('discard-and-start-new')));
    await tester.pumpAndSettle();

    expect(_cancelCount, 1);
    expect(find.text('You have a workout in progress'), findsNothing);
    expect(find.byKey(const ValueKey('start-workout-screen')), findsOneWidget);
  });

  testWidgets('Today continues an open session instead of a blank body', (
    tester,
  ) async {
    final router = _router(AppRoutes.today);
    addTearDown(router.dispose);
    await tester.pumpWidget(
      _scope(
        router: router,
        session: WorkoutSession(
          id: 7,
          status: WorkoutStatus.inProgress,
          startedAt: DateTime.utc(2026, 11, 14),
          muscleGroupIds: [_chest.id],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('today-start-workout')), findsNothing);
    expect(
      find.byKey(const ValueKey('today-continue-workout')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('today-continue-workout')));
    await tester.pumpAndSettle();
    expect(find.byType(ActiveWorkoutScreen), findsOneWidget);
  });
}

GoRouter _router(String location) {
  return GoRouter(
    initialLocation: location,
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
}

Widget _scope({
  required GoRouter router,
  ThemeMode themeMode = ThemeMode.light,
  WorkoutSession? session,
}) {
  return ProviderScope(
    overrides: [
      bodyRegionsProvider.overrideWith(
        (ref) => Stream.value(const [_upper, _lower]),
      ),
      muscleGroupsProvider.overrideWith(
        (ref) => Stream.value(const [_chest, _triceps, _quads]),
      ),
      activeWorkoutProvider.overrideWith((ref) => Stream.value(session)),
      activeWorkoutExercisesProvider.overrideWith(
        (ref) => Stream.value(const <Exercise>[]),
      ),
      activeWorkoutCommandsProvider.overrideWith(_RecordingCommands.new),
    ],
    child: MaterialApp.router(
      routerConfig: router,
      theme: KebapTheme.light(),
      darkTheme: KebapTheme.dark(),
      themeMode: themeMode,
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    ),
  );
}
