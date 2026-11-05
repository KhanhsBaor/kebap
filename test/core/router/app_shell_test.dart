import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kebap/app.dart';
import 'package:kebap/core/db/app_database.dart';
import 'package:kebap/core/db/app_database_provider.dart';
import 'package:kebap/core/theme/kebap_colors.dart';
import 'package:kebap/features/history/presentation/screens/history_screen.dart';
import 'package:kebap/features/progress/presentation/screens/progress_screen.dart';
import 'package:kebap/features/today/presentation/screens/today_screen.dart';

void main() {
  testWidgets('switches tabs in light and dark themes', (tester) async {
    for (final themeMode in [ThemeMode.light, ThemeMode.dark]) {
      final database = AppDatabase(NativeDatabase.memory());
      try {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [appDatabaseProvider.overrideWith((ref) => database)],
            child: KebapApp(themeMode: themeMode, locale: const Locale('en')),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('No workout yet.'), findsOneWidget);
        expect(find.byType(TodayScreen), findsOneWidget);
        final todayContext = tester.element(find.byType(TodayScreen));
        expect(GoRouterState.of(todayContext).uri.path, '/today');
        final colors = themeMode == ThemeMode.light
            ? KebapColors.light
            : KebapColors.dark;
        expect(
          Theme.of(todayContext).scaffoldBackgroundColor,
          colors.background,
        );

        await tester.tap(find.byKey(const ValueKey('tab-progress')));
        await tester.pumpAndSettle();
        expect(
          find.text('Charts will appear after a completed workout.'),
          findsOneWidget,
        );
        expect(find.byType(ProgressScreen), findsOneWidget);
        final progressContext = tester.element(find.byType(ProgressScreen));
        expect(GoRouterState.of(progressContext).uri.path, '/progress');

        await tester.tap(find.byKey(const ValueKey('tab-history')));
        await tester.pumpAndSettle();
        expect(
          find.text('Completed workouts will show up here.'),
          findsOneWidget,
        );
        expect(find.byType(HistoryScreen), findsOneWidget);
        final historyContext = tester.element(find.byType(HistoryScreen));
        expect(GoRouterState.of(historyContext).uri.path, '/history');

        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pumpAndSettle();
      } finally {
        await database.close();
      }
    }
  });

  testWidgets('shows Vietnamese tab copy', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWith((ref) => database)],
        child: const KebapApp(locale: Locale('vi')),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Chưa có buổi tập.'), findsOneWidget);
    expect(find.text('Hôm nay'), findsWidgets);
    expect(find.text('Tiến trình'), findsOneWidget);
    expect(find.text('Lịch sử'), findsOneWidget);
  });
}
