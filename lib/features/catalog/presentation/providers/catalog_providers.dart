import 'package:kebap/features/catalog/data/providers/catalog_repository_providers.dart';
import 'package:kebap/features/catalog/domain/entities/body_region.dart';
import 'package:kebap/features/catalog/domain/entities/muscle_group.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'catalog_providers.g.dart';

@riverpod
Stream<List<BodyRegion>> bodyRegions(Ref ref) {
  return ref.watch(muscleGroupRepositoryProvider).watchRegions();
}

@riverpod
Stream<List<MuscleGroup>> muscleGroups(Ref ref) {
  return ref.watch(muscleGroupRepositoryProvider).watchAll();
}
