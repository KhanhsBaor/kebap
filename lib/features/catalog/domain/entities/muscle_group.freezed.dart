// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'muscle_group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MuscleGroup {

 int get id; int get regionId; String get slug; String get nameEn; String? get nameVi;
/// Create a copy of MuscleGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MuscleGroupCopyWith<MuscleGroup> get copyWith => _$MuscleGroupCopyWithImpl<MuscleGroup>(this as MuscleGroup, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MuscleGroup&&(identical(other.id, id) || other.id == id)&&(identical(other.regionId, regionId) || other.regionId == regionId)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.nameVi, nameVi) || other.nameVi == nameVi));
}


@override
int get hashCode => Object.hash(runtimeType,id,regionId,slug,nameEn,nameVi);

@override
String toString() {
  return 'MuscleGroup(id: $id, regionId: $regionId, slug: $slug, nameEn: $nameEn, nameVi: $nameVi)';
}


}

/// @nodoc
abstract mixin class $MuscleGroupCopyWith<$Res>  {
  factory $MuscleGroupCopyWith(MuscleGroup value, $Res Function(MuscleGroup) _then) = _$MuscleGroupCopyWithImpl;
@useResult
$Res call({
 int id, int regionId, String slug, String nameEn, String? nameVi
});




}
/// @nodoc
class _$MuscleGroupCopyWithImpl<$Res>
    implements $MuscleGroupCopyWith<$Res> {
  _$MuscleGroupCopyWithImpl(this._self, this._then);

  final MuscleGroup _self;
  final $Res Function(MuscleGroup) _then;

/// Create a copy of MuscleGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? regionId = null,Object? slug = null,Object? nameEn = null,Object? nameVi = freezed,}) {
  return _then(MuscleGroup(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,regionId: null == regionId ? _self.regionId : regionId // ignore: cast_nullable_to_non_nullable
as int,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,nameVi: freezed == nameVi ? _self.nameVi : nameVi // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MuscleGroup].
extension MuscleGroupPatterns on MuscleGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MuscleGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MuscleGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MuscleGroup value)  $default,){
final _that = this;
switch (_that) {
case _MuscleGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MuscleGroup value)?  $default,){
final _that = this;
switch (_that) {
case _MuscleGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int regionId,  String slug,  String nameEn,  String? nameVi)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MuscleGroup() when $default != null:
return $default(_that.id,_that.regionId,_that.slug,_that.nameEn,_that.nameVi);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int regionId,  String slug,  String nameEn,  String? nameVi)  $default,) {final _that = this;
switch (_that) {
case _MuscleGroup():
return $default(_that.id,_that.regionId,_that.slug,_that.nameEn,_that.nameVi);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int regionId,  String slug,  String nameEn,  String? nameVi)?  $default,) {final _that = this;
switch (_that) {
case _MuscleGroup() when $default != null:
return $default(_that.id,_that.regionId,_that.slug,_that.nameEn,_that.nameVi);case _:
  return null;

}
}

}

/// @nodoc


class _MuscleGroup implements MuscleGroup {
  const _MuscleGroup({required this.id, required this.regionId, required this.slug, required this.nameEn, this.nameVi});
  

@override final  int id;
@override final  int regionId;
@override final  String slug;
@override final  String nameEn;
@override final  String? nameVi;

/// Create a copy of MuscleGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MuscleGroupCopyWith<_MuscleGroup> get copyWith => __$MuscleGroupCopyWithImpl<_MuscleGroup>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MuscleGroup&&(identical(other.id, id) || other.id == id)&&(identical(other.regionId, regionId) || other.regionId == regionId)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.nameVi, nameVi) || other.nameVi == nameVi));
}


@override
int get hashCode => Object.hash(runtimeType,id,regionId,slug,nameEn,nameVi);

@override
String toString() {
  return 'MuscleGroup(id: $id, regionId: $regionId, slug: $slug, nameEn: $nameEn, nameVi: $nameVi)';
}


}

/// @nodoc
abstract mixin class _$MuscleGroupCopyWith<$Res> implements $MuscleGroupCopyWith<$Res> {
  factory _$MuscleGroupCopyWith(_MuscleGroup value, $Res Function(_MuscleGroup) _then) = __$MuscleGroupCopyWithImpl;
@override @useResult
$Res call({
 int id, int regionId, String slug, String nameEn, String? nameVi
});




}
/// @nodoc
class __$MuscleGroupCopyWithImpl<$Res>
    implements _$MuscleGroupCopyWith<$Res> {
  __$MuscleGroupCopyWithImpl(this._self, this._then);

  final _MuscleGroup _self;
  final $Res Function(_MuscleGroup) _then;

/// Create a copy of MuscleGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? regionId = null,Object? slug = null,Object? nameEn = null,Object? nameVi = freezed,}) {
  return _then(_MuscleGroup(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,regionId: null == regionId ? _self.regionId : regionId // ignore: cast_nullable_to_non_nullable
as int,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,nameVi: freezed == nameVi ? _self.nameVi : nameVi // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
