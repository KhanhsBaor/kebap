import 'package:drift/drift.dart';
import 'package:kebap/core/db/app_database.dart';
import 'package:kebap/core/db/db_enums.dart';
import 'package:kebap/core/db/seed/catalog_taxonomy.dart';
import 'package:kebap/core/db/seed/exercise_seed_csv.dart';

/// Inserts the fixed catalog, then seed exercises, in one transaction.
class CatalogSeeder {
  CatalogSeeder(this._database);

  final AppDatabase _database;

  /// Ensures regions and muscle groups exist, then imports exercises from
  /// [readCsv] when the table has no seed row (`isCustom = false`).
  ///
  /// A later call does not parse the CSV again. Slugs are resolved to int
  /// keys. An unknown muscle-group slug throws and rolls the transaction back.
  Future<void> run(Future<String> Function() readCsv) async {
    await _database.transaction(() async {
      final muscleGroupIds = await _ensureTaxonomy();
      if (await _hasSeedExercise()) return;

      final rows = parseExerciseSeedCsv(await readCsv());
      final companions = <ExercisesCompanion>[];
      for (final row in rows) {
        final muscleGroupId = muscleGroupIds[row.muscleGroupSlug];
        if (muscleGroupId == null) {
          throw FormatException(
            'Unknown kebapMuscleGroup "${row.muscleGroupSlug}" '
            'for ${row.sourceId}',
          );
        }
        companions.add(
          ExercisesCompanion.insert(
            muscleGroupId: muscleGroupId,
            nameEn: row.nameEn,
            nameVi: Value<String?>(row.nameVi),
            isCustom: const Value(false),
            sourceId: Value<String?>(row.sourceId),
            equipment: Value<ExerciseEquipment?>(row.equipment),
          ),
        );
      }

      if (companions.isEmpty) return;
      await _database.batch((batch) {
        batch.insertAll(_database.exercises, companions);
      });
    });
  }

  Future<Map<String, int>> _ensureTaxonomy() async {
    for (final region in catalogRegionSeeds) {
      await _database
          .into(_database.regions)
          .insert(
            RegionsCompanion.insert(slug: region.slug, nameEn: region.nameEn),
            mode: InsertMode.insertOrIgnore,
          );
    }

    final regionIds = {
      for (final region in await _database.select(_database.regions).get())
        region.slug: region.id,
    };

    for (final group in catalogMuscleGroupSeeds) {
      final regionId = regionIds[group.regionSlug];
      if (regionId == null) {
        throw StateError('Missing region ${group.regionSlug}');
      }
      await _database
          .into(_database.muscleGroups)
          .insert(
            MuscleGroupsCompanion.insert(
              regionId: regionId,
              slug: group.slug,
              nameEn: group.nameEn,
            ),
            mode: InsertMode.insertOrIgnore,
          );
    }

    return {
      for (final group in await _database.select(_database.muscleGroups).get())
        group.slug: group.id,
    };
  }

  Future<bool> _hasSeedExercise() async {
    final existing =
        await (_database.select(_database.exercises)
              ..where((exercise) => exercise.isCustom.equals(false))
              ..limit(1))
            .getSingleOrNull();
    return existing != null;
  }
}
