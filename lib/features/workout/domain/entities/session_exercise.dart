import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kebap/features/workout/domain/entities/set_log.dart';

part 'session_exercise.freezed.dart';

/// Exercise attached to one workout. The catalog row stays the source of the name.
@freezed
abstract class SessionExercise with _$SessionExercise {
  const factory SessionExercise({
    required int id,
    required int exerciseId,
    required int position,
    @Default(<SetLog>[]) List<SetLog> sets,
  }) = _SessionExercise;
}
