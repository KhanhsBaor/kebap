import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kebap/core/db/app_database.dart';
import 'package:kebap/core/db/db_enums.dart';
import 'package:kebap/core/db/seed/catalog_seeder.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('imports every valid bundled exercise once and '
      'filters by muscle group', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    final csv = await loadBundledExerciseSeedCsv();
    final expected = _expectedSeedRows(csv);
    expect(expected, hasLength(1323));
    expect(
      expected.values.where((row) => row.muscleGroupSlug == 'chest').length,
      163,
    );

    final regions = await database.select(database.regions).get();
    expect(regions.map((region) => region.slug).toSet(), {
      'upper_body',
      'lower_body',
      'other',
    });
    expect(regions.every((region) => region.nameVi == null), isTrue);

    final groups = await database.select(database.muscleGroups).get();
    expect(groups, hasLength(20));
    expect(groups.map((group) => group.slug), contains('others'));
    expect(groups.every((group) => group.nameVi == null), isTrue);
    final slugById = {for (final group in groups) group.id: group.slug};

    final stored = await database.select(database.exercises).get();
    expect(stored, hasLength(1323));
    expect(
      stored.map((exercise) => exercise.sourceId).toSet(),
      hasLength(1323),
    );
    for (final exercise in stored) {
      final row = expected[exercise.sourceId];
      expect(row, isNotNull, reason: exercise.sourceId);
      expect(slugById[exercise.muscleGroupId], row!.muscleGroupSlug);
      expect(exercise.equipment?.name, row.equipment);
      expect(exercise.nameEn, row.nameEn);
      expect(exercise.nameVi, row.nameVi);
      expect(exercise.isCustom, isFalse);
      expect(exercise.equipment, isNotNull);
      expect(exercise.nameVi, isNotEmpty);
    }

    final sample = stored.singleWhere(
      (exercise) => exercise.sourceId == 'abductors/lever-seated-hip-abduction',
    );
    expect(slugById[sample.muscleGroupId], 'abductors');
    expect(sample.equipment, ExerciseEquipment.machine);

    final chestId = groups.singleWhere((group) => group.slug == 'chest').id;
    final chestExercises = await (database.select(
      database.exercises,
    )..where((exercise) => exercise.muscleGroupId.equals(chestId))).get();
    expect(chestExercises, hasLength(163));
    expect(
      chestExercises.every((exercise) => exercise.muscleGroupId == chestId),
      isTrue,
    );

    await CatalogSeeder(database).run(loadBundledExerciseSeedCsv);
    final again = await database.select(database.exercises).get();
    expect(again, hasLength(1323));
    expect(again.map((exercise) => exercise.sourceId).toSet(), hasLength(1323));
  });

  test(
    'skips incomplete rows and still imports a row with reviewNote',
    () async {
      final database = AppDatabase(NativeDatabase.memory(), seedOnOpen: false);
      addTearDown(database.close);

      await CatalogSeeder(database).run(() async => _shortCsv);

      expect(
        database.exercises.$columns.map((column) => column.name),
        isNot(contains('review_note')),
      );

      final groups = await database.select(database.muscleGroups).get();
      final slugById = {for (final group in groups) group.id: group.slug};
      final stored = await database.select(database.exercises).get();
      expect(stored.map((exercise) => exercise.sourceId).toSet(), {
        'keep/barbell',
        'keep/cable',
      });

      final barbell = stored.singleWhere(
        (exercise) => exercise.sourceId == 'keep/barbell',
      );
      expect(slugById[barbell.muscleGroupId], 'biceps');
      expect(barbell.equipment, ExerciseEquipment.barbell);
      expect(barbell.nameVi, 'Cuốn tạ đòn');
      expect(barbell.isCustom, isFalse);

      final cable = stored.singleWhere(
        (exercise) => exercise.sourceId == 'keep/cable',
      );
      expect(slugById[cable.muscleGroupId], 'triceps');
      expect(cable.equipment, ExerciseEquipment.cable);
      expect(cable.nameVi, 'Đẩy cáp');
      expect(cable.isCustom, isFalse);
    },
  );
}

class _ExpectedSeed {
  const _ExpectedSeed({
    required this.nameEn,
    required this.nameVi,
    required this.muscleGroupSlug,
    required this.equipment,
  });

  final String nameEn;
  final String nameVi;
  final String muscleGroupSlug;
  final String equipment;
}

/// Column split of the bundled file. That file has no quoted commas, so this
/// stays independent of the production CSV parser.
Map<String, _ExpectedSeed> _expectedSeedRows(String csv) {
  final lines = csv
      .split(RegExp(r'\r?\n'))
      .where((line) => line.isNotEmpty)
      .map((line) => line.split(','))
      .toList();
  final header = lines.first;

  int indexOf(String name) {
    final index = header.indexOf(name);
    expect(index, isNonNegative, reason: name);
    return index;
  }

  final id = indexOf('id');
  final nameEn = indexOf('nameEn');
  final nameVi = indexOf('nameVi');
  final muscleGroup = indexOf('kebapMuscleGroup');
  final equipment = indexOf('kebapEquipment');
  final expected = <String, _ExpectedSeed>{};

  for (final record in lines.skip(1)) {
    String cell(int index) => index < record.length ? record[index].trim() : '';
    final sourceId = cell(id);
    final english = cell(nameEn);
    final vietnamese = cell(nameVi);
    final group = cell(muscleGroup);
    final gear = cell(equipment);
    if (sourceId.isEmpty ||
        english.isEmpty ||
        vietnamese.isEmpty ||
        group.isEmpty ||
        gear.isEmpty) {
      continue;
    }
    expected[sourceId] = _ExpectedSeed(
      nameEn: english,
      nameVi: vietnamese,
      muscleGroupSlug: group,
      equipment: gear,
    );
  }
  return expected;
}

const _shortCsv = '''
id,nameEn,nameVi,sourceMuscle,sourceEquipment,kebapMuscleGroup,kebapEquipment,sourceBodyPart,sourceCategory,gifFile,reviewNote
keep/barbell,Barbell Curl,Cuốn tạ đòn,biceps,barbell,biceps,barbell,upper arms,strength,keep.gif,tên cần xem
skip/vi,Missing Vi,,biceps,dumbbell,biceps,dumbbell,upper arms,strength,skip.gif,
skip/gear,Missing Gear,Thiếu dụng cụ,biceps,band,biceps,,upper arms,strength,skip2.gif,
keep/cable,Cable Pushdown,Đẩy cáp,triceps,cable,triceps,cable,upper arms,strength,keep2.gif,ok
''';
