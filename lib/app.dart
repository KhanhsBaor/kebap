import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kebap/core/db/app_database_provider.dart';
import 'package:kebap/core/router/app_router.dart';
import 'package:kebap/core/theme/kebap_theme.dart';
import 'package:kebap/l10n/app_localizations.dart';

class KebapApp extends ConsumerWidget {
  const KebapApp({super.key, this.themeMode = ThemeMode.system, this.locale});

  final ThemeMode themeMode;
  final Locale? locale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    ref.watch(appDatabaseProvider);
    return MaterialApp.router(
      title: 'Kebap',
      routerConfig: router,
      theme: KebapTheme.light(),
      darkTheme: KebapTheme.dark(),
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
