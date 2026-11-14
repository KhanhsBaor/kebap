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

  @override
  String get startWorkoutTitle => 'Start a workout';

  @override
  String get startWorkoutAction => 'Start workout';

  @override
  String get noMuscleGroups => 'No muscle groups yet.';

  @override
  String get workoutInProgressTitle => 'You have a workout in progress';

  @override
  String get continueWorkout => 'Continue';

  @override
  String get continueThatWorkout => 'Continue that workout';

  @override
  String get discardAndStartNew => 'Discard and start a new one';

  @override
  String get activeWorkoutTitle => 'Workout';

  @override
  String get startWorkoutFailed => 'Could not start the workout.';

  @override
  String get discardWorkout => 'Discard workout';

  @override
  String get finishWorkout => 'Finish';

  @override
  String get setColumn => 'Set';

  @override
  String get previousColumn => 'Previous';

  @override
  String get kgColumn => 'kg';

  @override
  String get repsColumn => 'Reps';

  @override
  String get saveSet => 'Save set';

  @override
  String get noPreviousSession => 'No previous session';

  @override
  String get previousSetEmpty => '—';

  @override
  String get addSet => '+ Add set';

  @override
  String get warmupMark => 'W';

  @override
  String get skipRest => 'Skip';

  @override
  String kgComparedWithPrevious(String delta) {
    return '$delta kg vs last time';
  }

  @override
  String repsComparedWithPrevious(String delta) {
    return '$delta reps vs last time';
  }

  @override
  String get noExercisesInWorkout => 'No exercises in this workout yet.';

  @override
  String get addExercise => 'Add exercise';

  @override
  String get searchExercises => 'Search by name';

  @override
  String get createExercise => 'Create exercise';
}
