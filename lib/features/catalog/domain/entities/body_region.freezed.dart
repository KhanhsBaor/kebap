// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'body_region.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BodyRegion {

 int get id; String get slug; String get nameEn; String? get nameVi;
/// Create a copy of BodyRegion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BodyRegionCopyWith<BodyRegion> get copyWith => _$BodyRegionCopyWithImpl<BodyRegion>(this as BodyRegion, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BodyRegion&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.nameVi, nameVi) || other.nameVi == nameVi));
}


@override
int get hashCode => Object.hash(runtimeType,id,slug,nameEn,nameVi);

@override
String toString() {
  return 'BodyRegion(id: $id, slug: $slug, nameEn: $nameEn, nameVi: $nameVi)';
}


}

/// @nodoc
abstract mixin class $BodyRegionCopyWith<$Res>  {
  factory $BodyRegionCopyWith(BodyRegion value, $Res Function(BodyRegion) _then) = _$BodyRegionCopyWithImpl;
@useResult
$Res call({
 int id, String slug, String nameEn, String? nameVi
});




}
/// @nodoc
class _$BodyRegionCopyWithImpl<$Res>
    implements $BodyRegionCopyWith<$Res> {
  _$BodyRegionCopyWithImpl(this._self, this._then);

  final BodyRegion _self;
  final $Res Function(BodyRegion) _then;

/// Create a copy of BodyRegion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slug = null,Object? nameEn = null,Object? nameVi = freezed,}) {
  return _then(BodyRegion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,nameVi: freezed == nameVi ? _self.nameVi : nameVi // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BodyRegion].
extension BodyRegionPatterns on BodyRegion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BodyRegion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BodyRegion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BodyRegion value)  $default,){
final _that = this;
switch (_that) {
case _BodyRegion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BodyRegion value)?  $default,){
final _that = this;
switch (_that) {
case _BodyRegion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String slug,  String nameEn,  String? nameVi)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BodyRegion() when $default != null:
return $default(_that.id,_that.slug,_that.nameEn,_that.nameVi);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String slug,  String nameEn,  String? nameVi)  $default,) {final _that = this;
switch (_that) {
case _BodyRegion():
return $default(_that.id,_that.slug,_that.nameEn,_that.nameVi);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String slug,  String nameEn,  String? nameVi)?  $default,) {final _that = this;
switch (_that) {
case _BodyRegion() when $default != null:
return $default(_that.id,_that.slug,_that.nameEn,_that.nameVi);case _:
  return null;

}
}

}

/// @nodoc


class _BodyRegion implements BodyRegion {
  const _BodyRegion({required this.id, required this.slug, required this.nameEn, this.nameVi});
  

@override final  int id;
@override final  String slug;
@override final  String nameEn;
@override final  String? nameVi;

/// Create a copy of BodyRegion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BodyRegionCopyWith<_BodyRegion> get copyWith => __$BodyRegionCopyWithImpl<_BodyRegion>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BodyRegion&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.nameVi, nameVi) || other.nameVi == nameVi));
}


@override
int get hashCode => Object.hash(runtimeType,id,slug,nameEn,nameVi);

@override
String toString() {
  return 'BodyRegion(id: $id, slug: $slug, nameEn: $nameEn, nameVi: $nameVi)';
}


}

/// @nodoc
abstract mixin class _$BodyRegionCopyWith<$Res> implements $BodyRegionCopyWith<$Res> {
  factory _$BodyRegionCopyWith(_BodyRegion value, $Res Function(_BodyRegion) _then) = __$BodyRegionCopyWithImpl;
@override @useResult
$Res call({
 int id, String slug, String nameEn, String? nameVi
});




}
/// @nodoc
class __$BodyRegionCopyWithImpl<$Res>
    implements _$BodyRegionCopyWith<$Res> {
  __$BodyRegionCopyWithImpl(this._self, this._then);

  final _BodyRegion _self;
  final $Res Function(_BodyRegion) _then;

/// Create a copy of BodyRegion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slug = null,Object? nameEn = null,Object? nameVi = freezed,}) {
  return _then(_BodyRegion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,nameVi: freezed == nameVi ? _self.nameVi : nameVi // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
