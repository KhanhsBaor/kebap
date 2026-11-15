import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// Local `H:m` of [startedAt], with the date in front when it is not the
/// same local day as [now].
String formatWorkoutStart(
  BuildContext context, {
  required DateTime startedAt,
  required DateTime now,
}) {
  final locale = Localizations.localeOf(context).toLanguageTag();
  final start = startedAt.toLocal();
  final today = now.toLocal();
  final time = DateFormat.Hm(locale).format(start);
  final sameDay =
      start.year == today.year &&
      start.month == today.month &&
      start.day == today.day;
  if (sameDay) return time;
  return '${DateFormat.yMd(locale).format(start)} $time';
}
