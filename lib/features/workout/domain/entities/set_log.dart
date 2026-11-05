import 'package:freezed_annotation/freezed_annotation.dart';

part 'set_log.freezed.dart';

/// A set that was saved. Planned rows that were never saved are not set logs.
@freezed
abstract class SetLog with _$SetLog {
  const factory SetLog({
    required int id,
    required int sessionExerciseId,
    required int position,
    required bool isWarmup,
    double? kg,
    int? reps,
  }) = _SetLog;
}
