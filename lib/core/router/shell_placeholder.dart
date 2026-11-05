import 'package:flutter/material.dart';
import 'package:kebap/core/theme/kebap_spacing.dart';

class ShellPlaceholder extends StatelessWidget {
  const ShellPlaceholder({
    required this.screenKey,
    required this.title,
    required this.message,
    super.key,
  });

  final Key screenKey;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<KebapSpacing>()!;
    return Scaffold(
      key: screenKey,
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.md,
          vertical: spacing.xl,
        ),
        child: Text(message, style: Theme.of(context).textTheme.bodyLarge),
      ),
    );
  }
}
