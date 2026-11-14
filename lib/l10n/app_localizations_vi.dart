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

  @override
  String get discardWorkout => 'Hủy buổi tập';

  @override
  String get finishWorkout => 'Kết thúc';

  @override
  String get setColumn => 'Set';

  @override
  String get previousColumn => 'Lần trước';

  @override
  String get kgColumn => 'kg';

  @override
  String get repsColumn => 'Reps';

  @override
  String get saveSet => 'Lưu set';

  @override
  String get saveSetFailed => 'Không lưu được set.';

  @override
  String get undoSet => 'Hoàn tác set đã lưu';

  @override
  String get decreaseKg => 'Giảm tạ';

  @override
  String get increaseKg => 'Tăng tạ';

  @override
  String get decreaseReps => 'Giảm rep';

  @override
  String get increaseReps => 'Tăng rep';

  @override
  String get noPreviousSession => 'Chưa có lần trước';

  @override
  String get previousSetEmpty => '—';

  @override
  String get addSet => '+ Thêm set';

  @override
  String get warmupMark => 'W';

  @override
  String get skipRest => 'Bỏ qua';

  @override
  String kgComparedWithPrevious(String delta) {
    return '$delta kg so với lần trước';
  }

  @override
  String repsComparedWithPrevious(String delta) {
    return '$delta rep so với lần trước';
  }

  @override
  String get noExercisesInWorkout => 'Chưa có bài trong buổi.';

  @override
  String get addExercise => 'Thêm bài';

  @override
  String get searchExercises => 'Tìm theo tên';

  @override
  String get createExercise => 'Tạo bài mới';
}
