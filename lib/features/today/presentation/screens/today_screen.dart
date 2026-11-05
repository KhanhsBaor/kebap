import 'package:flutter/material.dart';
import 'package:kebap/core/router/shell_placeholder.dart';
import 'package:kebap/l10n/app_localizations.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ShellPlaceholder(
      screenKey: const ValueKey('today-screen'),
      title: l10n.todayLabel,
      message: l10n.todayEmpty,
    );
  }
}
