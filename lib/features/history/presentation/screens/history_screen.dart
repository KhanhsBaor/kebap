import 'package:flutter/material.dart';
import 'package:kebap/core/router/shell_placeholder.dart';
import 'package:kebap/l10n/app_localizations.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ShellPlaceholder(
      screenKey: const ValueKey('history-screen'),
      title: l10n.historyLabel,
      message: l10n.historyEmpty,
    );
  }
}
