import 'package:kebap/features/catalog/domain/entities/body_region.dart';
import 'package:kebap/features/catalog/domain/entities/muscle_group.dart';

/// Fixed catalog of regions and muscle groups. Lookups use [slug].
abstract class MuscleGroupRepository {
  Stream<List<BodyRegion>> watchRegions();

  Stream<List<MuscleGroup>> watchAll();

  Stream<List<MuscleGroup>> watchByRegionId(int regionId);

  Future<BodyRegion?> findRegionBySlug(String slug);

  Future<MuscleGroup?> findGroupBySlug(String slug);
}
