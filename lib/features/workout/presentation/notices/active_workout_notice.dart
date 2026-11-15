import 'package:kebap/features/catalog/domain/entities/exercise.dart';
import 'package:kebap/features/workout/domain/failures/workout_rule_exception.dart';

/// One-shot result of a session command, for the screen to show a dialog.
sealed class ActiveWorkoutNotice {
  const ActiveWorkoutNotice();
}

final class ActiveWorkoutNoSavedSets extends ActiveWorkoutNotice {
  const ActiveWorkoutNoSavedSets();
}

final class ActiveWorkoutNeedsConfirmation extends ActiveWorkoutNotice {
  const ActiveWorkoutNeedsConfirmation({
    required this.unloggedSetCount,
    required this.exerciseCount,
  });

  final int unloggedSetCount;
  final int exerciseCount;
}

final class ActiveWorkoutDuplicateName extends ActiveWorkoutNotice {
  const ActiveWorkoutDuplicateName(this.exercise);

  final Exercise exercise;
}

final class ActiveWorkoutRejected extends ActiveWorkoutNotice {
  const ActiveWorkoutRejected(this.failure);

  final WorkoutRuleException failure;
}

/// Catalog or workout write failed for a reason outside the domain rules.
final class ActiveWorkoutSaveFailed extends ActiveWorkoutNotice {
  const ActiveWorkoutSaveFailed();
}
