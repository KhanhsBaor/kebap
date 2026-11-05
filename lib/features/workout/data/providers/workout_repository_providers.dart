import 'package:kebap/core/db/app_database_provider.dart';
import 'package:kebap/features/workout/data/repositories/workout_repository_impl.dart';
import 'package:kebap/features/workout/domain/repositories/workout_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'workout_repository_providers.g.dart';

@riverpod
WorkoutRepository workoutRepository(Ref ref) {
  return WorkoutRepositoryImpl(ref.watch(appDatabaseProvider));
}
