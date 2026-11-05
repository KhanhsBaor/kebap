import 'package:kebap/core/db/app_database.dart' hide MuscleGroup;
import 'package:kebap/features/catalog/data/mappers/catalog_mapper.dart';
import 'package:kebap/features/catalog/domain/entities/body_region.dart';
import 'package:kebap/features/catalog/domain/entities/muscle_group.dart';
import 'package:kebap/features/catalog/domain/repositories/muscle_group_repository.dart';

class MuscleGroupRepositoryImpl implements MuscleGroupRepository {
  MuscleGroupRepositoryImpl(this._database);

  final AppDatabase _database;

  @override
  Stream<List<BodyRegion>> watchRegions() {
    return _database.catalogDao.watchRegions().map(
      (rows) => [for (final row in rows) toBodyRegion(row)],
    );
  }

  @override
  Stream<List<MuscleGroup>> watchAll() {
    return _database.catalogDao.watchMuscleGroups().map(
      (rows) => [for (final row in rows) toMuscleGroup(row)],
    );
  }

  @override
  Stream<List<MuscleGroup>> watchByRegionId(int regionId) {
    return _database.catalogDao
        .watchMuscleGroups(regionId: regionId)
        .map((rows) => [for (final row in rows) toMuscleGroup(row)]);
  }

  @override
  Future<BodyRegion?> findRegionBySlug(String slug) async {
    final row = await _database.catalogDao.findRegionBySlug(slug);
    return row == null ? null : toBodyRegion(row);
  }

  @override
  Future<MuscleGroup?> findGroupBySlug(String slug) async {
    final row = await _database.catalogDao.findGroupBySlug(slug);
    return row == null ? null : toMuscleGroup(row);
  }
}
