// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get todayLabel => 'Today';

  @override
  String get progressLabel => 'Progress';

  @override
  String get historyLabel => 'History';

  @override
  String get todayEmpty => 'No workout yet.';

  @override
  String get progressEmpty => 'Charts will appear after a completed workout.';

  @override
  String get historyEmpty => 'Completed workouts will show up here.';
}
