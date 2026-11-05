import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kebap/features/catalog/domain/entities/exercise_equipment.dart';

part 'exercise.freezed.dart';

@freezed
abstract class Exercise with _$Exercise {
  const factory Exercise({
    required int id,
    required int muscleGroupId,
    required String nameEn,
    String? nameVi,
    required bool isCustom,
    String? sourceId,
    ExerciseEquipment? equipment,
  }) = _Exercise;
}
