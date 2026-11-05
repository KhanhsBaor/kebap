import 'package:drift/drift.dart';
import 'package:kebap/core/db/app_database.dart';
import 'package:kebap/core/db/tables/exercises_table.dart';
import 'package:kebap/core/db/tables/muscle_groups_table.dart';
import 'package:kebap/core/db/tables/regions_table.dart';

part 'catalog_dao.g.dart';

@DriftAccessor(tables: [Regions, MuscleGroups, Exercises])
class CatalogDao extends DatabaseAccessor<AppDatabase> with _$CatalogDaoMixin {
  CatalogDao(super.db);

  Stream<List<Region>> watchRegions() {
    return (select(
      regions,
    )..orderBy([(row) => OrderingTerm.asc(row.id)])).watch();
  }

  Stream<List<MuscleGroup>> watchMuscleGroups({int? regionId}) {
    final query = select(muscleGroups)
      ..orderBy([(row) => OrderingTerm.asc(row.id)]);
    if (regionId != null) {
      query.where((row) => row.regionId.equals(regionId));
    }
    return query.watch();
  }

  Future<Region?> findRegionBySlug(String slug) {
    return (select(regions)
          ..where((row) => row.slug.equals(slug))
          ..limit(1))
        .getSingleOrNull();
  }

  Future<MuscleGroup?> findGroupBySlug(String slug) {
    return (select(muscleGroups)
          ..where((row) => row.slug.equals(slug))
          ..limit(1))
        .getSingleOrNull();
  }

  Stream<List<Exercise>> watchExercisesByMuscleGroupIds(Set<int> ids) {
    if (ids.isEmpty) return Stream.value(const []);
    return (select(exercises)
          ..where((row) => row.muscleGroupId.isIn(ids))
          ..orderBy([(row) => OrderingTerm.asc(row.id)]))
        .watch();
  }

  Future<Exercise?> findExerciseBySourceId(String sourceId) {
    return (select(exercises)
          ..where((row) => row.sourceId.equals(sourceId))
          ..limit(1))
        .getSingleOrNull();
  }

  Future<List<Exercise>> exercisesInGroup(int muscleGroupId) {
    return (select(exercises)
          ..where((row) => row.muscleGroupId.equals(muscleGroupId))
          ..orderBy([(row) => OrderingTerm.asc(row.id)]))
        .get();
  }

  Future<Exercise> insertExercise(ExercisesCompanion companion) {
    return into(exercises).insertReturning(companion);
  }
}
