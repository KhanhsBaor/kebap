import 'package:kebap/core/db/app_database_provider.dart';
import 'package:kebap/features/catalog/data/repositories/exercise_repository_impl.dart';
import 'package:kebap/features/catalog/data/repositories/muscle_group_repository_impl.dart';
import 'package:kebap/features/catalog/domain/repositories/exercise_repository.dart';
import 'package:kebap/features/catalog/domain/repositories/muscle_group_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'catalog_repository_providers.g.dart';

@riverpod
MuscleGroupRepository muscleGroupRepository(Ref ref) {
  return MuscleGroupRepositoryImpl(ref.watch(appDatabaseProvider));
}

@riverpod
ExerciseRepository exerciseRepository(Ref ref) {
  return ExerciseRepositoryImpl(ref.watch(appDatabaseProvider));
}
