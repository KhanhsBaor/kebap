// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Exercise {

 int get id; int get muscleGroupId; String get nameEn; String? get nameVi; bool get isCustom; String? get sourceId; ExerciseEquipment? get equipment;
/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExerciseCopyWith<Exercise> get copyWith => _$ExerciseCopyWithImpl<Exercise>(this as Exercise, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Exercise&&(identical(other.id, id) || other.id == id)&&(identical(other.muscleGroupId, muscleGroupId) || other.muscleGroupId == muscleGroupId)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.nameVi, nameVi) || other.nameVi == nameVi)&&(identical(other.isCustom, isCustom) || other.isCustom == isCustom)&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.equipment, equipment) || other.equipment == equipment));
}


@override
int get hashCode => Object.hash(runtimeType,id,muscleGroupId,nameEn,nameVi,isCustom,sourceId,equipment);

@override
String toString() {
  return 'Exercise(id: $id, muscleGroupId: $muscleGroupId, nameEn: $nameEn, nameVi: $nameVi, isCustom: $isCustom, sourceId: $sourceId, equipment: $equipment)';
}


}

/// @nodoc
abstract mixin class $ExerciseCopyWith<$Res>  {
  factory $ExerciseCopyWith(Exercise value, $Res Function(Exercise) _then) = _$ExerciseCopyWithImpl;
@useResult
$Res call({
 int id, int muscleGroupId, String nameEn, String? nameVi, bool isCustom, String? sourceId, ExerciseEquipment? equipment
});




}
/// @nodoc
class _$ExerciseCopyWithImpl<$Res>
    implements $ExerciseCopyWith<$Res> {
  _$ExerciseCopyWithImpl(this._self, this._then);

  final Exercise _self;
  final $Res Function(Exercise) _then;

/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? muscleGroupId = null,Object? nameEn = null,Object? nameVi = freezed,Object? isCustom = null,Object? sourceId = freezed,Object? equipment = freezed,}) {
  return _then(Exercise(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,muscleGroupId: null == muscleGroupId ? _self.muscleGroupId : muscleGroupId // ignore: cast_nullable_to_non_nullable
as int,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,nameVi: freezed == nameVi ? _self.nameVi : nameVi // ignore: cast_nullable_to_non_nullable
as String?,isCustom: null == isCustom ? _self.isCustom : isCustom // ignore: cast_nullable_to_non_nullable
as bool,sourceId: freezed == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String?,equipment: freezed == equipment ? _self.equipment : equipment // ignore: cast_nullable_to_non_nullable
as ExerciseEquipment?,
  ));
}

}


/// Adds pattern-matching-related methods to [Exercise].
extension ExercisePatterns on Exercise {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Exercise value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Exercise() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Exercise value)  $default,){
final _that = this;
switch (_that) {
case _Exercise():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Exercise value)?  $default,){
final _that = this;
switch (_that) {
case _Exercise() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int muscleGroupId,  String nameEn,  String? nameVi,  bool isCustom,  String? sourceId,  ExerciseEquipment? equipment)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Exercise() when $default != null:
return $default(_that.id,_that.muscleGroupId,_that.nameEn,_that.nameVi,_that.isCustom,_that.sourceId,_that.equipment);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int muscleGroupId,  String nameEn,  String? nameVi,  bool isCustom,  String? sourceId,  ExerciseEquipment? equipment)  $default,) {final _that = this;
switch (_that) {
case _Exercise():
return $default(_that.id,_that.muscleGroupId,_that.nameEn,_that.nameVi,_that.isCustom,_that.sourceId,_that.equipment);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int muscleGroupId,  String nameEn,  String? nameVi,  bool isCustom,  String? sourceId,  ExerciseEquipment? equipment)?  $default,) {final _that = this;
switch (_that) {
case _Exercise() when $default != null:
return $default(_that.id,_that.muscleGroupId,_that.nameEn,_that.nameVi,_that.isCustom,_that.sourceId,_that.equipment);case _:
  return null;

}
}

}

/// @nodoc


class _Exercise implements Exercise {
  const _Exercise({required this.id, required this.muscleGroupId, required this.nameEn, this.nameVi, required this.isCustom, this.sourceId, this.equipment});
  

@override final  int id;
@override final  int muscleGroupId;
@override final  String nameEn;
@override final  String? nameVi;
@override final  bool isCustom;
@override final  String? sourceId;
@override final  ExerciseEquipment? equipment;

/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExerciseCopyWith<_Exercise> get copyWith => __$ExerciseCopyWithImpl<_Exercise>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Exercise&&(identical(other.id, id) || other.id == id)&&(identical(other.muscleGroupId, muscleGroupId) || other.muscleGroupId == muscleGroupId)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.nameVi, nameVi) || other.nameVi == nameVi)&&(identical(other.isCustom, isCustom) || other.isCustom == isCustom)&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.equipment, equipment) || other.equipment == equipment));
}


@override
int get hashCode => Object.hash(runtimeType,id,muscleGroupId,nameEn,nameVi,isCustom,sourceId,equipment);

@override
String toString() {
  return 'Exercise(id: $id, muscleGroupId: $muscleGroupId, nameEn: $nameEn, nameVi: $nameVi, isCustom: $isCustom, sourceId: $sourceId, equipment: $equipment)';
}


}

/// @nodoc
abstract mixin class _$ExerciseCopyWith<$Res> implements $ExerciseCopyWith<$Res> {
  factory _$ExerciseCopyWith(_Exercise value, $Res Function(_Exercise) _then) = __$ExerciseCopyWithImpl;
@override @useResult
$Res call({
 int id, int muscleGroupId, String nameEn, String? nameVi, bool isCustom, String? sourceId, ExerciseEquipment? equipment
});




}
/// @nodoc
class __$ExerciseCopyWithImpl<$Res>
    implements _$ExerciseCopyWith<$Res> {
  __$ExerciseCopyWithImpl(this._self, this._then);

  final _Exercise _self;
  final $Res Function(_Exercise) _then;

/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? muscleGroupId = null,Object? nameEn = null,Object? nameVi = freezed,Object? isCustom = null,Object? sourceId = freezed,Object? equipment = freezed,}) {
  return _then(_Exercise(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,muscleGroupId: null == muscleGroupId ? _self.muscleGroupId : muscleGroupId // ignore: cast_nullable_to_non_nullable
as int,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,nameVi: freezed == nameVi ? _self.nameVi : nameVi // ignore: cast_nullable_to_non_nullable
as String?,isCustom: null == isCustom ? _self.isCustom : isCustom // ignore: cast_nullable_to_non_nullable
as bool,sourceId: freezed == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String?,equipment: freezed == equipment ? _self.equipment : equipment // ignore: cast_nullable_to_non_nullable
as ExerciseEquipment?,
  ));
}


}

// dart format on
