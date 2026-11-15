import 'package:kebap/features/workout/domain/entities/session_exercise.dart';
import 'package:kebap/features/workout/domain/entities/set_log.dart';
import 'package:kebap/features/workout/domain/entities/workout_session.dart';

/// Persistence for a workout.
///
/// The single in-progress session is enforced here, inside one transaction.
/// Discard confirmation and "at least one saved set" stay in use cases
/// (`docs/06`). A second in-progress insert throws `WorkoutAlreadyInProgress`.
abstract class WorkoutRepository {
  /// The in-progress session, or null when there is none.
  ///
  /// Includes muscle groups, exercises, and saved sets, each ordered by
  /// position. Planned rows that were never saved are absent.
  Stream<WorkoutSession?> watchInProgress();

  /// The single in-progress session, or null. Commands use this lookup.
  /// The graph matches [watchInProgress].
  Future<WorkoutSession?> findInProgress();

  /// Session [id] with its exercises and sets, or null.
  Future<WorkoutSession?> findById(int id);

  /// Inserts an in-progress session. [muscleGroupIds] order is the group
  /// position (index 0 is position 0). The list must be non-empty and must
  /// not contain duplicates.
  ///
  /// Throws `WorkoutAlreadyInProgress` when another in-progress session
  /// already exists. The use case checks [findInProgress] first; this method
  /// is the backstop (`docs/06` mục 1).
  Future<WorkoutSession> insertInProgress({
    required DateTime startedAt,
    required List<int> muscleGroupIds,
    int? splitDayId,
  });

  Future<void> deleteWorkout(int id);

  /// Marks [id] completed at [endedAt] and removes [dropSessionExerciseIds]
  /// in one transaction. Returns the completed session.
  Future<WorkoutSession> complete({
    required int id,
    required DateTime endedAt,
    List<int> dropSessionExerciseIds = const [],
  });

  /// Appends [exerciseId] to the session and returns it with no saved sets.
  ///
  /// Does not check that the exercise belongs to the session's muscle groups.
  /// The use case does.
  Future<SessionExercise> addExercise({
    required int workoutId,
    required int exerciseId,
  });

  /// Deletes the session exercise and its saved sets.
  Future<void> removeExercise(int sessionExerciseId);

  Future<SetLog> insertSet({
    required int sessionExerciseId,
    required int position,
    bool isWarmup = false,
    double? kg,
    int? reps,
    DateTime? savedAt,
  });

  Future<SetLog> updateSet({
    required int id,
    required bool isWarmup,
    double? kg,
    int? reps,
  });

  /// Deletes set [id] and writes [positions] (set id → position) for the sets
  /// that remain on that exercise, in one transaction.
  Future<void> deleteSet({required int id, required Map<int, int> positions});

  /// Sets from the latest `completed` session that logged [exerciseId] and
  /// ended before [startedAt], ordered by position. In-progress sessions are
  /// ignored. Empty when no such session exists.
  Future<List<SetLog>> findPreviousSets({
    required int exerciseId,
    required DateTime startedAt,
  });
}
