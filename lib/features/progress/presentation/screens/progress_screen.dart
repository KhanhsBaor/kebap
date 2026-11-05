import 'package:flutter/material.dart';
import 'package:kebap/core/router/shell_placeholder.dart';
import 'package:kebap/l10n/app_localizations.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ShellPlaceholder(
      screenKey: const ValueKey('progress-screen'),
      title: l10n.progressLabel,
      message: l10n.progressEmpty,
    );
  }
}
