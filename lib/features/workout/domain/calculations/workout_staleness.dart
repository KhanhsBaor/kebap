import 'package:kebap/features/workout/domain/entities/workout_session.dart';

/// An open session idle longer than this asks to be saved or discarded
/// (`docs/06` mục 3.4). The value is a guess to tune with real data.
const staleWorkoutThreshold = Duration(hours: 6);

/// Latest saved set, or [WorkoutSession.startedAt] when no set has a
/// saved time (no sets yet, or sets written before schema v2).
DateTime lastWorkoutActivity(WorkoutSession session) {
  var latest = session.startedAt;
  for (final exercise in session.exercises) {
    for (final set in exercise.sets) {
      final savedAt = set.savedAt;
      if (savedAt != null && savedAt.isAfter(latest)) latest = savedAt;
    }
  }
  return latest;
}

/// True only when more than [staleWorkoutThreshold] has passed.
bool isStaleWorkout({required DateTime lastActivityAt, required DateTime now}) {
  return now.difference(lastActivityAt) > staleWorkoutThreshold;
}
