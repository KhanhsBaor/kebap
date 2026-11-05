import 'package:kebap/features/workout/domain/entities/session_exercise.dart';
import 'package:kebap/features/workout/domain/entities/set_log.dart';
import 'package:kebap/features/workout/domain/entities/workout_session.dart';

/// Persistence for a workout. Start, cancel, and finish rules live in use cases.
abstract class WorkoutRepository {
  Stream<WorkoutSession?> watchInProgress();

  /// Inserts an in-progress session. [muscleGroupIds] order is the group position.
  Future<WorkoutSession> insertInProgress({
    required DateTime startedAt,
    required List<int> muscleGroupIds,
    int? splitDayId,
  });

  Future<void> deleteWorkout(int id);

  Future<void> complete({required int id, required DateTime endedAt});

  /// Appends [exerciseId] to the session and returns it with no saved sets.
  Future<SessionExercise> addExercise({
    required int workoutId,
    required int exerciseId,
  });

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
}
