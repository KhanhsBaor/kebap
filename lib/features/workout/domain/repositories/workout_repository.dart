import 'package:kebap/features/workout/domain/entities/session_exercise.dart';
import 'package:kebap/features/workout/domain/entities/set_log.dart';
import 'package:kebap/features/workout/domain/entities/workout_session.dart';

/// Thrown by [WorkoutRepository.insertInProgress] when a session is already
/// `in_progress`. At most one such session exists (`docs/06`).
final class WorkoutAlreadyInProgress implements Exception {
  const WorkoutAlreadyInProgress();

  @override
  String toString() => 'WorkoutAlreadyInProgress';
}

/// Persistence for a workout.
///
/// The single in-progress session is enforced here, inside one transaction.
/// Discard confirmation and "at least one saved set" stay in use cases
/// (`docs/06`).
abstract class WorkoutRepository {
  /// The in-progress session, or null when there is none.
  ///
  /// Includes muscle groups, exercises, and saved sets, each ordered by
  /// position. Planned rows that were never saved are absent.
  Stream<WorkoutSession?> watchInProgress();

  /// Inserts an in-progress session. [muscleGroupIds] order is the group
  /// position (index 0 is position 0). The list must be non-empty and must
  /// not contain duplicates.
  ///
  /// Throws [WorkoutAlreadyInProgress] when another in-progress session
  /// already exists.
  Future<WorkoutSession> insertInProgress({
    required DateTime startedAt,
    required List<int> muscleGroupIds,
    int? splitDayId,
  });

  Future<void> deleteWorkout(int id);

  Future<void> complete({required int id, required DateTime endedAt});

  /// Appends [exerciseId] to the session and returns it with no saved sets.
  ///
  /// Does not check that the exercise belongs to the session's muscle groups.
  /// The use case does.
  Future<SessionExercise> addExercise({
    required int workoutId,
    required int exerciseId,
  });

  /// Deletes the session exercise and its saved sets.
  ///
  /// Finish uses this for an exercise that never received a saved set.
  Future<void> removeExercise(int sessionExerciseId);

  Future<SetLog> insertSet({
    required int sessionExerciseId,
    required int position,
    bool isWarmup = false,
    double? kg,
    int? reps,
  });

  Future<SetLog> updateSet({
    required int id,
    required bool isWarmup,
    double? kg,
    int? reps,
  });

  Future<void> deleteSet(int id);

  /// Sets from the latest `completed` session that logged [exerciseId] and
  /// ended before [startedAt], ordered by position. In-progress sessions are
  /// ignored. Empty when no such session exists.
  Future<List<SetLog>> findPreviousSets({
    required int exerciseId,
    required DateTime startedAt,
  });
}
