import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kebap/core/db/app_database.dart';
import 'package:kebap/core/db/app_database_provider.dart';
import 'package:kebap/features/catalog/data/providers/catalog_repository_providers.dart';
import 'package:kebap/features/workout/data/providers/workout_repository_providers.dart';

void main() {
  test('repository providers read the overridden database', () async {
    final database = AppDatabase(NativeDatabase.memory(), seedOnOpen: false);
    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWith((ref) => database)],
    );
    addTearDown(container.dispose);
    addTearDown(database.close);

    expect(
      await container.read(muscleGroupRepositoryProvider).watchAll().first,
      isEmpty,
    );
    expect(
      await container
          .read(exerciseRepositoryProvider)
          .findBySourceId('missing'),
      isNull,
    );
    expect(
      await container.read(workoutRepositoryProvider).watchInProgress().first,
      isNull,
    );
  });
}
