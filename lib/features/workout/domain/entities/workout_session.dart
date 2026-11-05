import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kebap/features/workout/domain/entities/session_exercise.dart';
import 'package:kebap/features/workout/domain/entities/workout_status.dart';

part 'workout_session.freezed.dart';

@freezed
abstract class WorkoutSession with _$WorkoutSession {
  const factory WorkoutSession({
    required int id,
    required WorkoutStatus status,
    required DateTime startedAt,
    DateTime? endedAt,
    int? splitDayId,
    required List<int> muscleGroupIds,
    @Default(<SessionExercise>[]) List<SessionExercise> exercises,
  }) = _WorkoutSession;
}
