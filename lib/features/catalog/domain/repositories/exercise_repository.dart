import 'package:kebap/features/catalog/domain/entities/exercise.dart';
import 'package:kebap/features/catalog/domain/entities/exercise_equipment.dart';

abstract class ExerciseRepository {
  Stream<List<Exercise>> watchByMuscleGroupIds(Set<int> muscleGroupIds);

  Future<Exercise?> findBySourceId(String sourceId);

  /// Exercise in [muscleGroupId] whose `nameEn` or `nameVi` equals [name],
  /// ignoring case. Blocking a duplicate custom name is a use case decision.
  Future<Exercise?> findByNameInGroup({
    required int muscleGroupId,
    required String name,
  });

  /// Inserts one exercise and returns it with the assigned id.
  ///
  /// [isCustom] is required so a seed row is not created by omitting the flag.
  /// Seed rows pass `isCustom: false` and a non-null [equipment]. Custom rows
  /// pass `isCustom: true` and leave [equipment] null.
  Future<Exercise> insert({
    required int muscleGroupId,
    required String nameEn,
    String? nameVi,
    required bool isCustom,
    String? sourceId,
    ExerciseEquipment? equipment,
  });
}
