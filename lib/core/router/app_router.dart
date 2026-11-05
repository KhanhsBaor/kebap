import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kebap/core/router/app_routes.dart';
import 'package:kebap/core/router/app_shell.dart';
import 'package:kebap/features/history/presentation/screens/history_screen.dart';
import 'package:kebap/features/progress/presentation/screens/progress_screen.dart';
import 'package:kebap/features/today/presentation/screens/today_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
  final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.today,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.today,
                name: AppRoutes.todayName,
                builder: (context, state) => const TodayScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.progress,
                name: AppRoutes.progressName,
                builder: (context, state) => const ProgressScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.history,
                name: AppRoutes.historyName,
                builder: (context, state) => const HistoryScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
}
