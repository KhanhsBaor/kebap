import 'package:flutter/material.dart';
import 'package:kebap/core/theme/kebap_colors.dart';
import 'package:kebap/core/theme/kebap_spacing.dart';
import 'package:kebap/core/theme/kebap_typography.dart';
import 'package:kebap/features/workout/domain/entities/set_log.dart';
import 'package:kebap/features/workout/presentation/widgets/load_format.dart';
import 'package:kebap/l10n/app_localizations.dart';

enum LoadField { kg, reps }

/// Unsaved row the user is editing. Lives on the screen, not in the database.
class SetDraft {
  SetDraft({this.kg, this.reps, this.isWarmup = false});

  double? kg;
  int? reps;
  bool isWarmup;
}

class SetLogRow extends StatelessWidget {
  const SetLogRow({
    required this.exerciseId,
    required this.position,
    required this.saved,
    required this.draft,
    required this.reference,
    required this.onStepKg,
    required this.onStepReps,
    required this.onEditKg,
    required this.onEditReps,
    required this.onSave,
    required this.onToggleWarmup,
    required this.onUndo,
    super.key,
  });

  final int exerciseId;
  final int position;
  final SetLog? saved;
  final SetDraft? draft;
  final SetLog? reference;
  final void Function(int direction) onStepKg;
  final void Function(int direction) onStepReps;
  final VoidCallback onEditKg;
  final VoidCallback onEditReps;
  final VoidCallback? onSave;
  final VoidCallback onToggleWarmup;
  final VoidCallback onUndo;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = Theme.of(context).extension<KebapSpacing>()!;
    final colors = Theme.of(context).extension<KebapColors>()!;
    final numbers = Theme.of(context).extension<KebapTypography>()!;
    final locale = Localizations.localeOf(context).languageCode;
    final kg = saved?.kg ?? draft?.kg;
    final reps = saved?.reps ?? draft?.reps;
    final warmup = saved?.isWarmup ?? draft?.isWarmup ?? false;

    return Padding(
      padding: EdgeInsets.only(bottom: spacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _index(warmup, l10n, spacing),
              SizedBox(width: spacing.sm),
              Expanded(
                child: Text(
                  _previous(l10n, locale),
                  key: Key('previous-$exerciseId-$position'),
                  style: numbers.secondaryNumber,
                ),
              ),
              if (saved != null) ...[
                Text(_kgLabel(l10n, locale, kg), style: numbers.entryNumber),
                SizedBox(width: spacing.sm),
                Text(
                  reps == null ? l10n.repsColumn : '$reps',
                  style: numbers.entryNumber,
                ),
                _check(spacing),
              ] else
                _value(
                  key: Key('kg-value-$exerciseId-$position'),
                  label: _kgLabel(l10n, locale, kg),
                  onTap: onEditKg,
                  spacing: spacing,
                  numbers: numbers,
                ),
            ],
          ),
          if (saved == null) ...[
            SizedBox(height: spacing.xs),
            Row(
              children: [
                _stepper(
                  minusKey: Key('kg-minus-$exerciseId-$position'),
                  plusKey: Key('kg-plus-$exerciseId-$position'),
                  onMinus: () => onStepKg(-1),
                  onPlus: () => onStepKg(1),
                  spacing: spacing,
                ),
                const Spacer(),
                _value(
                  key: Key('reps-value-$exerciseId-$position'),
                  label: reps == null ? l10n.repsColumn : '$reps',
                  onTap: onEditReps,
                  spacing: spacing,
                  numbers: numbers,
                ),
                _stepper(
                  minusKey: Key('reps-minus-$exerciseId-$position'),
                  plusKey: Key('reps-plus-$exerciseId-$position'),
                  onMinus: () => onStepReps(-1),
                  onPlus: () => onStepReps(1),
                  spacing: spacing,
                ),
              ],
            ),
            SizedBox(height: spacing.xs),
            FilledButton(
              key: Key('save-set-$exerciseId-$position'),
              style: FilledButton.styleFrom(
                minimumSize: Size.fromHeight(spacing.save),
              ),
              onPressed: onSave,
              child: Text(l10n.saveSet),
            ),
          ],
          for (final line in _deltas(l10n, locale, kg, reps))
            Text(
              line,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: colors.muted),
            ),
        ],
      ),
    );
  }

  Widget _index(bool warmup, AppLocalizations l10n, KebapSpacing spacing) {
    return SizedBox(
      width: spacing.touch,
      height: spacing.touch,
      child: TextButton(
        key: Key('set-index-$exerciseId-$position'),
        style: TextButton.styleFrom(
          minimumSize: Size(spacing.touch, spacing.touch),
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: onToggleWarmup,
        child: Text(warmup ? l10n.warmupMark : '$position'),
      ),
    );
  }

  Widget _check(KebapSpacing spacing) {
    return SizedBox(
      width: spacing.touch,
      height: spacing.touch,
      child: IconButton(
        key: Key('set-check-$exerciseId-$position'),
        style: IconButton.styleFrom(
          minimumSize: Size(spacing.touch, spacing.touch),
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: onUndo,
        icon: const Icon(Icons.check),
      ),
    );
  }

  Widget _value({
    required Key key,
    required String label,
    required VoidCallback onTap,
    required KebapSpacing spacing,
    required KebapTypography numbers,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: spacing.touch,
        minHeight: spacing.touch,
      ),
      child: TextButton(
        key: key,
        style: TextButton.styleFrom(
          minimumSize: Size(spacing.touch, spacing.touch),
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: onTap,
        child: Text(label, style: numbers.entryNumber),
      ),
    );
  }

  Widget _stepper({
    required Key minusKey,
    required Key plusKey,
    required VoidCallback onMinus,
    required VoidCallback onPlus,
    required KebapSpacing spacing,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: spacing.touch,
          height: spacing.touch,
          child: IconButton(
            key: minusKey,
            style: IconButton.styleFrom(
              minimumSize: Size(spacing.touch, spacing.touch),
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: onMinus,
            icon: const Icon(Icons.remove),
          ),
        ),
        SizedBox(
          width: spacing.touch,
          height: spacing.touch,
          child: IconButton(
            key: plusKey,
            style: IconButton.styleFrom(
              minimumSize: Size(spacing.touch, spacing.touch),
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: onPlus,
            icon: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  String _kgLabel(AppLocalizations l10n, String locale, double? kg) {
    if (kg == null) return l10n.kgColumn;
    return formatKg(kg, locale);
  }

  String _previous(AppLocalizations l10n, String locale) {
    final set = reference;
    if (set == null) return l10n.previousSetEmpty;
    return pair(set, locale);
  }

  List<String> _deltas(
    AppLocalizations l10n,
    String locale,
    double? kg,
    int? reps,
  ) {
    final set = reference;
    if (set == null || saved != null) return const [];
    final lines = <String>[];
    if (!sameKg(kg, set.kg) && kg != null && set.kg != null) {
      lines.add(
        l10n.kgComparedWithPrevious(formatSigned(kg - set.kg!, locale)),
      );
    }
    if (reps != null && set.reps != null && reps != set.reps) {
      lines.add(
        l10n.repsComparedWithPrevious(formatSigned(reps - set.reps!, locale)),
      );
    }
    return lines;
  }

  static String pair(SetLog set, String locale) {
    final kg = set.kg == null ? '—' : formatKg(set.kg!, locale);
    final reps = set.reps?.toString() ?? '—';
    return '$kg×$reps';
  }
}
