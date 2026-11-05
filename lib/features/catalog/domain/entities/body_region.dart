import 'package:freezed_annotation/freezed_annotation.dart';

part 'body_region.freezed.dart';

@freezed
abstract class BodyRegion with _$BodyRegion {
  const factory BodyRegion({
    required int id,
    required String slug,
    required String nameEn,
    String? nameVi,
  }) = _BodyRegion;
}
