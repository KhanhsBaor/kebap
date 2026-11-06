/// A workout command refused to change stored data.
sealed class WorkoutRuleException implements Exception {
  const WorkoutRuleException();
}

final class WorkoutAlreadyInProgress extends WorkoutRuleException {
  const WorkoutAlreadyInProgress();
}

final class WorkoutNotFound extends WorkoutRuleException {
  const WorkoutNotFound();
}

final class WorkoutNotInProgress extends WorkoutRuleException {
  const WorkoutNotInProgress();
}

final class MuscleGroupsRequired extends WorkoutRuleException {
  const MuscleGroupsRequired();
}

final class DuplicateMuscleGroup extends WorkoutRuleException {
  const DuplicateMuscleGroup();
}

final class MuscleGroupNotFound extends WorkoutRuleException {
  const MuscleGroupNotFound();
}

final class MuscleGroupOutsideRegion extends WorkoutRuleException {
  const MuscleGroupOutsideRegion();
}

final class MuscleGroupNotOnWorkout extends WorkoutRuleException {
  const MuscleGroupNotOnWorkout();
}

final class ExerciseNotFound extends WorkoutRuleException {
  const ExerciseNotFound();
}

final class SessionExerciseNotFound extends WorkoutRuleException {
  const SessionExerciseNotFound();
}

final class SetNotFound extends WorkoutRuleException {
  const SetNotFound();
}

final class InvalidExerciseName extends WorkoutRuleException {
  const InvalidExerciseName();
}

final class InvalidSetValue extends WorkoutRuleException {
  const InvalidSetValue();
}

final class InvalidPlannedSetCount extends WorkoutRuleException {
  const InvalidPlannedSetCount();
}

final class WorkoutHasNoSavedSets extends WorkoutRuleException {
  const WorkoutHasNoSavedSets();
}
