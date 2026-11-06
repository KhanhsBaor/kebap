import 'package:kebap/features/catalog/domain/repositories/muscle_group_repository.dart';
import 'package:kebap/features/workout/domain/entities/workout_session.dart';
import 'package:kebap/features/workout/domain/failures/workout_rule_exception.dart';
import 'package:kebap/features/workout/domain/repositories/workout_repository.dart';

class StartWorkout {
  const StartWorkout({
    required WorkoutRepository workoutRepository,
    required MuscleGroupRepository muscleGroupRepository,
  }) : _workouts = workoutRepository,
       _groups = muscleGroupRepository;

  final WorkoutRepository _workouts;
  final MuscleGroupRepository _groups;

  Future<WorkoutSession> call({
    required int regionId,
    required List<int> muscleGroupIds,
    required DateTime startedAt,
  }) async {
    if (muscleGroupIds.isEmpty) {
      throw const MuscleGroupsRequired();
    }
    if (muscleGroupIds.toSet().length != muscleGroupIds.length) {
      throw const DuplicateMuscleGroup();
    }
    final inProgress = await _workouts.findInProgress();
    if (inProgress != null) {
      throw const WorkoutAlreadyInProgress();
    }

    final groups = await _groups.listAll();
    final byId = {for (final group in groups) group.id: group};
    for (final id in muscleGroupIds) {
      final group = byId[id];
      if (group == null) {
        throw const MuscleGroupNotFound();
      }
      if (group.regionId != regionId) {
        throw const MuscleGroupOutsideRegion();
      }
    }

    return _workouts.insertInProgress(
      startedAt: startedAt,
      muscleGroupIds: muscleGroupIds,
    );
  }
}
