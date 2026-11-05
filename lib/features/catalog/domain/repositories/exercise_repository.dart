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

  Future<Exercise> insert({
    required int muscleGroupId,
    required String nameEn,
    String? nameVi,
    bool isCustom = false,
    String? sourceId,
    ExerciseEquipment? equipment,
  });
}
