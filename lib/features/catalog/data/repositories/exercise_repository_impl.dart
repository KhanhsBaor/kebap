import 'package:kebap/core/db/app_database.dart' hide Exercise;
import 'package:kebap/features/catalog/data/mappers/catalog_mapper.dart';
import 'package:kebap/features/catalog/domain/entities/exercise.dart';
import 'package:kebap/features/catalog/domain/entities/exercise_equipment.dart';
import 'package:kebap/features/catalog/domain/repositories/exercise_repository.dart';

class ExerciseRepositoryImpl implements ExerciseRepository {
  ExerciseRepositoryImpl(this._database);

  final AppDatabase _database;

  @override
  Stream<List<Exercise>> watchByMuscleGroupIds(Set<int> muscleGroupIds) {
    return _database.catalogDao
        .watchExercisesByMuscleGroupIds(muscleGroupIds)
        .map((rows) => [for (final row in rows) toExercise(row)]);
  }

  @override
  Future<Exercise?> findBySourceId(String sourceId) async {
    final row = await _database.catalogDao.findExerciseBySourceId(sourceId);
    return row == null ? null : toExercise(row);
  }

  @override
  Future<Exercise?> findByNameInGroup({
    required int muscleGroupId,
    required String name,
  }) async {
    final needle = name.toLowerCase();
    final rows = await _database.catalogDao.exercisesInGroup(muscleGroupId);
    for (final row in rows) {
      final english = row.nameEn.toLowerCase();
      final vietnamese = row.nameVi?.toLowerCase();
      if (english == needle || vietnamese == needle) {
        return toExercise(row);
      }
    }
    return null;
  }

  @override
  Future<Exercise> insert({
    required int muscleGroupId,
    required String nameEn,
    String? nameVi,
    required bool isCustom,
    String? sourceId,
    ExerciseEquipment? equipment,
  }) async {
    final row = await _database.catalogDao.insertExercise(
      exerciseCompanion(
        muscleGroupId: muscleGroupId,
        nameEn: nameEn,
        nameVi: nameVi,
        isCustom: isCustom,
        sourceId: sourceId,
        equipment: equipment,
      ),
    );
    return toExercise(row);
  }
}
