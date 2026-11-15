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
  String get saveSetFailed => 'Could not save the set.';

  @override
  String get undoSet => 'Undo saved set';

  @override
  String get decreaseKg => 'Decrease weight';

  @override
  String get increaseKg => 'Increase weight';

  @override
  String get decreaseReps => 'Decrease reps';

  @override
  String get increaseReps => 'Increase reps';

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

  @override
  String get exerciseNameLabel => 'Exercise name';

  @override
  String get addToWorkout => 'Add to workout';

  @override
  String get duplicateExerciseInGroup =>
      'This exercise is already in the group.';

  @override
  String get useExistingExercise => 'Use the existing exercise';

  @override
  String get customExerciseSaveFailed =>
      'Could not save the exercise. Try again.';

  @override
  String get muscleGroupLabel => 'Muscle group';

  @override
  String get inProgressBannerTitle => 'Workout in progress';

  @override
  String savedSetCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sets saved',
      one: '1 set saved',
    );
    return '$_temp0';
  }

  @override
  String startedAtLabel(String time) {
    return 'Started $time';
  }

  @override
  String get discardSession => 'Discard';

  @override
  String discardConfirmTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Discard workout? $count saved sets will be deleted.',
      one: 'Discard workout? 1 saved set will be deleted.',
    );
    return '$_temp0';
  }

  @override
  String get keepTraining => 'Keep training';

  @override
  String staleWorkoutTitle(String time) {
    return 'The workout started at $time was not finished.';
  }

  @override
  String get saveAsCompleted => 'Save as a finished workout';
}
