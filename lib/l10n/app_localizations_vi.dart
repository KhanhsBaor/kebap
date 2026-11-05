// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get todayLabel => 'Hôm nay';

  @override
  String get progressLabel => 'Tiến trình';

  @override
  String get historyLabel => 'Lịch sử';

  @override
  String get todayEmpty => 'Chưa có buổi tập.';

  @override
  String get progressEmpty => 'Chart sẽ hiện sau khi có buổi đã hoàn thành.';

  @override
  String get historyEmpty => 'Buổi đã hoàn thành sẽ nằm ở đây.';
}
