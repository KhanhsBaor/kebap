import 'package:kebap/features/catalog/domain/entities/exercise_equipment.dart';

/// One classified exercise row from `seed/exercises.csv`.
class ExerciseSeedRow {
  const ExerciseSeedRow({
    required this.sourceId,
    required this.nameEn,
    required this.nameVi,
    required this.muscleGroupSlug,
    required this.equipment,
  });

  final String sourceId;
  final String nameEn;
  final String nameVi;
  final String muscleGroupSlug;
  final ExerciseEquipment equipment;
}

/// Parses seed exercises.
///
/// A row is imported only when `id`, `nameEn`, `nameVi`, `kebapMuscleGroup`,
/// and `kebapEquipment` are non-empty after trimming. `reviewNote` and the
/// source columns are ignored. A non-empty equipment value outside the enum
/// throws [FormatException].
List<ExerciseSeedRow> parseExerciseSeedCsv(String csv) {
  final records = _parseCsvRecords(csv);
  if (records.isEmpty) {
    throw const FormatException('Exercise seed CSV is empty');
  }

  final header = records.first.map((cell) => cell.trim()).toList();
  final column = <String, int>{
    for (var index = 0; index < header.length; index++) header[index]: index,
  };
  for (final name in const [
    'id',
    'nameEn',
    'nameVi',
    'kebapMuscleGroup',
    'kebapEquipment',
  ]) {
    if (!column.containsKey(name)) {
      throw FormatException('Exercise seed CSV is missing column $name');
    }
  }

  final rows = <ExerciseSeedRow>[];
  for (final record in records.skip(1)) {
    if (record.every((cell) => cell.trim().isEmpty)) continue;

    String cell(String name) {
      final index = column[name]!;
      if (index >= record.length) return '';
      return record[index].trim();
    }

    final sourceId = cell('id');
    final nameEn = cell('nameEn');
    final nameVi = cell('nameVi');
    final muscleGroupSlug = cell('kebapMuscleGroup');
    final equipmentName = cell('kebapEquipment');
    if (sourceId.isEmpty ||
        nameEn.isEmpty ||
        nameVi.isEmpty ||
        muscleGroupSlug.isEmpty ||
        equipmentName.isEmpty) {
      continue;
    }

    rows.add(
      ExerciseSeedRow(
        sourceId: sourceId,
        nameEn: nameEn,
        nameVi: nameVi,
        muscleGroupSlug: muscleGroupSlug,
        equipment: _equipment(equipmentName, sourceId),
      ),
    );
  }
  return rows;
}

ExerciseEquipment _equipment(String name, String sourceId) {
  for (final equipment in ExerciseEquipment.values) {
    if (equipment.name == name) return equipment;
  }
  throw FormatException('Unknown kebapEquipment "$name" for $sourceId');
}

List<List<String>> _parseCsvRecords(String csv) {
  final records = <List<String>>[];
  final row = <String>[];
  final cell = StringBuffer();
  var inQuotes = false;

  void finishRow() {
    row.add(cell.toString());
    cell.clear();
    if (row.any((value) => value.isNotEmpty)) {
      records.add(List<String>.of(row));
    }
    row.clear();
  }

  for (var index = 0; index < csv.length; index++) {
    final char = csv[index];
    if (inQuotes) {
      if (char == '"') {
        final escaped = index + 1 < csv.length && csv[index + 1] == '"';
        if (escaped) {
          cell.write('"');
          index++;
        } else {
          inQuotes = false;
        }
      } else {
        cell.write(char);
      }
      continue;
    }

    if (char == '"') {
      inQuotes = true;
    } else if (char == ',') {
      row.add(cell.toString());
      cell.clear();
    } else if (char == '\n') {
      finishRow();
    } else if (char != '\r') {
      cell.write(char);
    }
  }

  if (cell.isNotEmpty || row.isNotEmpty) {
    finishRow();
  }
  return records;
}
