import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kebap/core/db/app_database.dart';
import 'package:kebap/core/db/db_enums.dart';
import 'package:kebap/features/catalog/data/repositories/exercise_repository_impl.dart';

void main() {
  late AppDatabase database;
  late ExerciseRepositoryImpl repository;
  late int chestId;
  late int tricepsId;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory(), seedOnOpen: false);
    repository = ExerciseRepositoryImpl(database);
    final regionId = await database
        .into(database.regions)
        .insert(
          RegionsCompanion.insert(slug: 'upper_body', nameEn: 'Upper body'),
        );
    chestId = await database
        .into(database.muscleGroups)
        .insert(
          MuscleGroupsCompanion.insert(
            regionId: regionId,
            slug: 'chest',
            nameEn: 'Chest',
          ),
        );
    tricepsId = await database
        .into(database.muscleGroups)
        .insert(
          MuscleGroupsCompanion.insert(
            regionId: regionId,
            slug: 'triceps',
            nameEn: 'Triceps',
          ),
        );
  });

  tearDown(() => database.close());

  test('watchByMuscleGroupIds returns seed and custom exercises', () async {
    expect(await repository.watchByMuscleGroupIds({}).first, isEmpty);

    final seed = await repository.insert(
      muscleGroupId: chestId,
      nameEn: 'Bench press',
      nameVi: 'Đẩy ngực',
      isCustom: false,
      sourceId: 'chest/bench',
      equipment: ExerciseEquipment.barbell,
    );
    final custom = await repository.insert(
      muscleGroupId: tricepsId,
      nameEn: 'Band pushdown',
      isCustom: true,
    );

    final chest = await repository.watchByMuscleGroupIds({chestId}).first;
    expect(chest.map((exercise) => exercise.id), [seed.id]);
    expect(chest.single.isCustom, isFalse);
    expect(chest.single.equipment, ExerciseEquipment.barbell);

    final both = await repository.watchByMuscleGroupIds({
      chestId,
      tricepsId,
    }).first;
    expect(both.map((exercise) => exercise.id), [seed.id, custom.id]);
  });

  test('findBySourceId returns the exercise or null', () async {
    final seed = await repository.insert(
      muscleGroupId: chestId,
      nameEn: 'Bench press',
      isCustom: false,
      sourceId: 'chest/bench',
      equipment: ExerciseEquipment.barbell,
    );

    expect(await repository.findBySourceId('chest/bench'), seed);
    expect(await repository.findBySourceId('missing'), isNull);
  });

  test('findByNameInGroup matches either language ignoring case', () async {
    final bench = await repository.insert(
      muscleGroupId: chestId,
      nameEn: 'Bench Press',
      nameVi: 'Đẩy ngực',
      isCustom: true,
    );

    expect(
      await repository.findByNameInGroup(
        muscleGroupId: chestId,
        name: 'bench press',
      ),
      bench,
    );
    expect(
      await repository.findByNameInGroup(
        muscleGroupId: chestId,
        name: 'ĐẨY NGỰC',
      ),
      bench,
    );
    expect(
      await repository.findByNameInGroup(
        muscleGroupId: tricepsId,
        name: 'bench press',
      ),
      isNull,
    );
    expect(
      await repository.findByNameInGroup(muscleGroupId: chestId, name: 'squat'),
      isNull,
    );
  });

  test('insert stores a duplicate custom name with null equipment', () async {
    final first = await repository.insert(
      muscleGroupId: chestId,
      nameEn: 'Bench Press',
      isCustom: true,
    );
    final duplicate = await repository.insert(
      muscleGroupId: chestId,
      nameEn: 'bench press',
      isCustom: true,
    );

    expect(duplicate.id, isNot(first.id));
    expect(duplicate.isCustom, isTrue);
    expect(duplicate.equipment, isNull);
    expect(duplicate.sourceId, isNull);
    expect(
      await repository.findByNameInGroup(
        muscleGroupId: chestId,
        name: 'BENCH PRESS',
      ),
      first,
    );
  });
}
