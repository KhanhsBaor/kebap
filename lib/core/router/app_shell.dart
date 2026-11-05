import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kebap/l10n/app_localizations.dart';

class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: navigationShell.goBranch,
        destinations: [
          NavigationDestination(
            key: const ValueKey('tab-today'),
            icon: const Icon(Icons.today_outlined),
            selectedIcon: const Icon(Icons.today_outlined),
            label: l10n.todayLabel,
          ),
          NavigationDestination(
            key: const ValueKey('tab-progress'),
            icon: const Icon(Icons.insights_outlined),
            selectedIcon: const Icon(Icons.insights_outlined),
            label: l10n.progressLabel,
          ),
          NavigationDestination(
            key: const ValueKey('tab-history'),
            icon: const Icon(Icons.history_outlined),
            selectedIcon: const Icon(Icons.history_outlined),
            label: l10n.historyLabel,
          ),
        ],
      ),
    );
  }
}
