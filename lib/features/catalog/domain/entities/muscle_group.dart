import 'package:freezed_annotation/freezed_annotation.dart';

part 'muscle_group.freezed.dart';

@freezed
abstract class MuscleGroup with _$MuscleGroup {
  const factory MuscleGroup({
    required int id,
    required int regionId,
    required String slug,
    required String nameEn,
    String? nameVi,
  }) = _MuscleGroup;
}
