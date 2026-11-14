import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kebap/core/theme/kebap_spacing.dart';
import 'package:kebap/core/theme/kebap_typography.dart';
import 'package:kebap/features/workout/presentation/providers/rest_timer_notifier.dart';
import 'package:kebap/l10n/app_localizations.dart';

/// Rest bar. The number is `endsAt − now`, refreshed once a second.
class RestTimerBar extends ConsumerStatefulWidget {
  const RestTimerBar({super.key});

  @override
  ConsumerState<RestTimerBar> createState() => _RestTimerBarState();
}

class _RestTimerBarState extends ConsumerState<RestTimerBar> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<KebapSpacing>()!;
    final numbers = Theme.of(context).extension<KebapTypography>()!;
    final l10n = AppLocalizations.of(context);
    final endsAt = ref.watch(restTimerProvider);
    final remaining = endsAt == null
        ? null
        : ref.read(restTimerProvider.notifier).remainingSeconds();
    if (remaining == null) return const SizedBox.shrink();
    final timer = ref.read(restTimerProvider.notifier);

    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.md,
          vertical: spacing.sm,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                '$remaining',
                key: const Key('rest-seconds'),
                style: numbers.entryNumber,
              ),
            ),
            _step(
              context,
              key: const Key('rest-minus'),
              label: '−15',
              onPressed: timer.subtractStep,
            ),
            SizedBox(width: spacing.sm),
            _step(
              context,
              key: const Key('rest-plus'),
              label: '+15',
              onPressed: timer.addStep,
            ),
            SizedBox(width: spacing.sm),
            TextButton(
              key: const Key('rest-skip'),
              onPressed: timer.dismiss,
              child: Text(l10n.skipRest),
            ),
          ],
        ),
      ),
    );
  }

  Widget _step(
    BuildContext context, {
    required Key key,
    required String label,
    required VoidCallback onPressed,
  }) {
    final spacing = Theme.of(context).extension<KebapSpacing>()!;
    return TextButton(
      key: key,
      style: TextButton.styleFrom(
        minimumSize: Size(spacing.touch, spacing.touch),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
