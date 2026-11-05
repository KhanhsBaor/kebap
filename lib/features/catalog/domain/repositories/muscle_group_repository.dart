import 'package:kebap/features/catalog/domain/entities/body_region.dart';
import 'package:kebap/features/catalog/domain/entities/muscle_group.dart';

/// Fixed catalog of regions and muscle groups. Lookups use [slug].
abstract class MuscleGroupRepository {
  Stream<List<MuscleGroup>> watchAll();

  Future<BodyRegion?> findRegionBySlug(String slug);

  Future<MuscleGroup?> findGroupBySlug(String slug);
}
