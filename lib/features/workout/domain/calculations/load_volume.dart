import 'package:kebap/features/workout/domain/entities/set_log.dart';

/// Load volume of one set: kg × reps (docs/03 mục 1).
double setVolume(double kg, int reps) => kg * reps;

/// Load volume of one exercise. Warmup sets and sets missing kg or reps
/// are skipped. A bodyweight set (kg == 0) stays and contributes 0.
double exerciseVolume(List<SetLog> sets) {
  return sets
      .where((set) => !set.isWarmup && set.kg != null && set.reps != null)
      .fold<double>(0.0, (sum, set) => sum + set.kg! * set.reps!);
}
