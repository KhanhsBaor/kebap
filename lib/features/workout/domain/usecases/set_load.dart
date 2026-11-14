import 'package:kebap/features/workout/domain/failures/workout_rule_exception.dart';

/// Saved sets may omit kg or reps. A present kg is finite and at least 0
/// (0 is bodyweight). A present reps value is at least 1.
void requireValidSetLoad({double? kg, int? reps}) {
  if (kg == null && reps == null) {
    throw const InvalidSetValue();
  }
  if (kg != null && (kg.isNaN || kg.isInfinite || kg < 0)) {
    throw const InvalidSetValue();
  }
  if (reps != null && reps < 1) {
    throw const InvalidSetValue();
  }
}
