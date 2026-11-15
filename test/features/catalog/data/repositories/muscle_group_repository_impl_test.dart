import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kebap/core/db/app_database.dart' hide MuscleGroup;
import 'package:kebap/features/catalog/data/repositories/muscle_group_repository_impl.dart';
import 'package:kebap/features/catalog/domain/entities/body_region.dart';
import 'package:kebap/features/catalog/domain/entities/muscle_group.dart';

void main() {
  late AppDatabase database;
  late MuscleGroupRepositoryImpl repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory(), seedOnOpen: false);
    repository = MuscleGroupRepositoryImpl(database);
  });

  tearDown(() => database.close());

  test('watchRegions emits regions in id order', () async {
    final events = <List<BodyRegion>>[];
    final subscription = repository.watchRegions().listen(events.add);
    addTearDown(subscription.cancel);

    await waitUntil(() => events.isNotEmpty);
    expect(events.single, isEmpty);

    final upperId = await insertRegion(database, 'upper_body', 'Upper body');
    final lowerId = await insertRegion(database, 'lower_body', 'Lower body');
    await waitUntil(() => events.length >= 2 && events.last.length == 2);

    expect(events.last.map((region) => region.id), [upperId, lowerId]);
    expect(events.last.map((region) => region.slug), [
      'upper_body',
      'lower_body',
    ]);
    expect(events.last.every((region) => region.nameVi == null), isTrue);
  });

  test('watchAll emits every muscle group in id order', () async {
    final regionId = await insertRegion(database, 'upper_body', 'Upper body');
    final chestId = await insertGroup(database, regionId, 'chest', 'Chest');
    final bicepsId = await insertGroup(database, regionId, 'biceps', 'Biceps');

    final groups = await repository.watchAll().first;
    expect(groups.map((group) => group.id), [chestId, bicepsId]);
    expect(groups.map((group) => group.slug), ['chest', 'biceps']);
  });

  test('watchByRegionId emits only groups in that region', () async {
    final upperId = await insertRegion(database, 'upper_body', 'Upper body');
    final lowerId = await insertRegion(database, 'lower_body', 'Lower body');
    await insertGroup(database, upperId, 'chest', 'Chest');
    final quadsId = await insertGroup(
      database,
      lowerId,
      'quadriceps',
      'Quadriceps',
    );

    final groups = await repository.watchByRegionId(lowerId).first;
    expect(groups.map((group) => group.id), [quadsId]);
    expect(groups.single.regionId, lowerId);
  });

  test('findRegionBySlug returns the region or null', () async {
    await insertRegion(database, 'other', 'Other');

    final found = await repository.findRegionBySlug('other');
    expect(found, isA<BodyRegion>());
    expect(found!.nameEn, 'Other');
    expect(await repository.findRegionBySlug('missing'), isNull);
  });

  test('findGroupBySlug returns the group or null', () async {
    final regionId = await insertRegion(database, 'upper_body', 'Upper body');
    await insertGroup(database, regionId, 'triceps', 'Triceps');

    final found = await repository.findGroupBySlug('triceps');
    expect(found, isA<MuscleGroup>());
    expect(found!.regionId, regionId);
    expect(await repository.findGroupBySlug('missing'), isNull);
  });
}

Future<int> insertRegion(AppDatabase database, String slug, String nameEn) {
  return database
      .into(database.regions)
      .insert(RegionsCompanion.insert(slug: slug, nameEn: nameEn));
}

Future<int> insertGroup(
  AppDatabase database,
  int regionId,
  String slug,
  String nameEn,
) {
  return database
      .into(database.muscleGroups)
      .insert(
        MuscleGroupsCompanion.insert(
          regionId: regionId,
          slug: slug,
          nameEn: nameEn,
        ),
      );
}

Future<void> waitUntil(bool Function() ready) async {
  for (var attempt = 0; attempt < 50; attempt++) {
    if (ready()) return;
    await Future<void>.delayed(const Duration(milliseconds: 20));
  }
  fail('timed out waiting for a stream event');
}
