/// Fixed body region shipped with the app. Display names follow docs/01.
class CatalogRegionSeed {
  const CatalogRegionSeed({required this.slug, required this.nameEn});

  final String slug;
  final String nameEn;
}

/// Fixed muscle group shipped with the app. [nameVi] stays null.
class CatalogMuscleGroupSeed {
  const CatalogMuscleGroupSeed({
    required this.regionSlug,
    required this.slug,
    required this.nameEn,
  });

  final String regionSlug;
  final String slug;
  final String nameEn;
}

const List<CatalogRegionSeed> catalogRegionSeeds = [
  CatalogRegionSeed(slug: 'upper_body', nameEn: 'Upper body'),
  CatalogRegionSeed(slug: 'lower_body', nameEn: 'Lower body'),
  CatalogRegionSeed(slug: 'other', nameEn: 'Other'),
];

const List<CatalogMuscleGroupSeed> catalogMuscleGroupSeeds = [
  CatalogMuscleGroupSeed(
    regionSlug: 'upper_body',
    slug: 'abdominals',
    nameEn: 'Abdominals',
  ),
  CatalogMuscleGroupSeed(
    regionSlug: 'upper_body',
    slug: 'biceps',
    nameEn: 'Biceps',
  ),
  CatalogMuscleGroupSeed(
    regionSlug: 'upper_body',
    slug: 'chest',
    nameEn: 'Chest',
  ),
  CatalogMuscleGroupSeed(
    regionSlug: 'upper_body',
    slug: 'forearms',
    nameEn: 'Forearms',
  ),
  CatalogMuscleGroupSeed(
    regionSlug: 'upper_body',
    slug: 'lats',
    nameEn: 'Lats',
  ),
  CatalogMuscleGroupSeed(
    regionSlug: 'upper_body',
    slug: 'lower_back',
    nameEn: 'Lower back',
  ),
  CatalogMuscleGroupSeed(
    regionSlug: 'upper_body',
    slug: 'neck',
    nameEn: 'Neck',
  ),
  CatalogMuscleGroupSeed(
    regionSlug: 'upper_body',
    slug: 'shoulders',
    nameEn: 'Shoulders',
  ),
  CatalogMuscleGroupSeed(
    regionSlug: 'upper_body',
    slug: 'traps',
    nameEn: 'Traps',
  ),
  CatalogMuscleGroupSeed(
    regionSlug: 'upper_body',
    slug: 'triceps',
    nameEn: 'Triceps',
  ),
  CatalogMuscleGroupSeed(
    regionSlug: 'upper_body',
    slug: 'upper_back',
    nameEn: 'Upper back',
  ),
  CatalogMuscleGroupSeed(
    regionSlug: 'lower_body',
    slug: 'abductors',
    nameEn: 'Abductors',
  ),
  CatalogMuscleGroupSeed(
    regionSlug: 'lower_body',
    slug: 'adductors',
    nameEn: 'Adductors',
  ),
  CatalogMuscleGroupSeed(
    regionSlug: 'lower_body',
    slug: 'calves',
    nameEn: 'Calves',
  ),
  CatalogMuscleGroupSeed(
    regionSlug: 'lower_body',
    slug: 'glutes',
    nameEn: 'Glutes',
  ),
  CatalogMuscleGroupSeed(
    regionSlug: 'lower_body',
    slug: 'hamstrings',
    nameEn: 'Hamstrings',
  ),
  CatalogMuscleGroupSeed(
    regionSlug: 'lower_body',
    slug: 'quadriceps',
    nameEn: 'Quadriceps',
  ),
  CatalogMuscleGroupSeed(regionSlug: 'other', slug: 'cardio', nameEn: 'Cardio'),
  CatalogMuscleGroupSeed(
    regionSlug: 'other',
    slug: 'full_body',
    nameEn: 'Full body',
  ),
  CatalogMuscleGroupSeed(regionSlug: 'other', slug: 'others', nameEn: 'Others'),
];
