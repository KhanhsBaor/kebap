import 'package:drift/drift.dart';
import 'package:kebap/core/db/app_database.dart' as db;
import 'package:kebap/features/catalog/domain/entities/body_region.dart';
import 'package:kebap/features/catalog/domain/entities/exercise.dart';
import 'package:kebap/features/catalog/domain/entities/exercise_equipment.dart';
import 'package:kebap/features/catalog/domain/entities/muscle_group.dart';

BodyRegion toBodyRegion(db.Region row) {
  return BodyRegion(
    id: row.id,
    slug: row.slug,
    nameEn: row.nameEn,
    nameVi: row.nameVi,
  );
}

MuscleGroup toMuscleGroup(db.MuscleGroup row) {
  return MuscleGroup(
    id: row.id,
    regionId: row.regionId,
    slug: row.slug,
    nameEn: row.nameEn,
    nameVi: row.nameVi,
  );
}

Exercise toExercise(db.Exercise row) {
  return Exercise(
    id: row.id,
    muscleGroupId: row.muscleGroupId,
    nameEn: row.nameEn,
    nameVi: row.nameVi,
    isCustom: row.isCustom,
    sourceId: row.sourceId,
    equipment: row.equipment,
  );
}

db.ExercisesCompanion exerciseCompanion({
  required int muscleGroupId,
  required String nameEn,
  String? nameVi,
  bool isCustom = false,
  String? sourceId,
  ExerciseEquipment? equipment,
}) {
  return db.ExercisesCompanion.insert(
    muscleGroupId: muscleGroupId,
    nameEn: nameEn,
    nameVi: Value<String?>(nameVi),
    isCustom: Value(isCustom),
    sourceId: Value<String?>(sourceId),
    equipment: Value<ExerciseEquipment?>(equipment),
  );
}
