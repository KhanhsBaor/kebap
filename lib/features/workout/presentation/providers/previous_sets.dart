import 'package:kebap/features/workout/data/providers/workout_repository_providers.dart';
import 'package:kebap/features/workout/domain/entities/set_log.dart';
import 'package:kebap/features/workout/presentation/providers/active_workout.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'previous_sets.g.dart';

/// Saved sets from the latest completed session of [exerciseId]
/// that ended before this session started. Empty when there is none.
@riverpod
Future<List<SetLog>> previousSets(Ref ref, int exerciseId) {
  final session = ref.watch(activeWorkoutProvider).asData?.value;
  if (session == null) return Future.value(const []);
  return ref
      .watch(workoutRepositoryProvider)
      .findPreviousSets(exerciseId: exerciseId, startedAt: session.startedAt);
}
