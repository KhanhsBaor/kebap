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

  @override
  String get startWorkoutTitle => 'Bắt đầu buổi';

  @override
  String get startWorkoutAction => 'Bắt đầu buổi tập';

  @override
  String get noMuscleGroups => 'Chưa có nhóm cơ.';

  @override
  String get workoutInProgressTitle => 'Bạn đang có buổi tập dở';

  @override
  String get continueWorkout => 'Tiếp tục';

  @override
  String get continueThatWorkout => 'Tiếp tục buổi đó';

  @override
  String get discardAndStartNew => 'Hủy và bắt đầu buổi mới';

  @override
  String get activeWorkoutTitle => 'Đang tập';

  @override
  String get startWorkoutFailed => 'Không bắt đầu được buổi tập.';
}
