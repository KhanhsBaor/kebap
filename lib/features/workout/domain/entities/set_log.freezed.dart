// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'set_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SetLog {

 int get id; int get sessionExerciseId; int get position; bool get isWarmup; double? get kg; int? get reps;
/// Create a copy of SetLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetLogCopyWith<SetLog> get copyWith => _$SetLogCopyWithImpl<SetLog>(this as SetLog, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetLog&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionExerciseId, sessionExerciseId) || other.sessionExerciseId == sessionExerciseId)&&(identical(other.position, position) || other.position == position)&&(identical(other.isWarmup, isWarmup) || other.isWarmup == isWarmup)&&(identical(other.kg, kg) || other.kg == kg)&&(identical(other.reps, reps) || other.reps == reps));
}


@override
int get hashCode => Object.hash(runtimeType,id,sessionExerciseId,position,isWarmup,kg,reps);

@override
String toString() {
  return 'SetLog(id: $id, sessionExerciseId: $sessionExerciseId, position: $position, isWarmup: $isWarmup, kg: $kg, reps: $reps)';
}


}

/// @nodoc
abstract mixin class $SetLogCopyWith<$Res>  {
  factory $SetLogCopyWith(SetLog value, $Res Function(SetLog) _then) = _$SetLogCopyWithImpl;
@useResult
$Res call({
 int id, int sessionExerciseId, int position, bool isWarmup, double? kg, int? reps
});




}
/// @nodoc
class _$SetLogCopyWithImpl<$Res>
    implements $SetLogCopyWith<$Res> {
  _$SetLogCopyWithImpl(this._self, this._then);

  final SetLog _self;
  final $Res Function(SetLog) _then;

/// Create a copy of SetLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sessionExerciseId = null,Object? position = null,Object? isWarmup = null,Object? kg = freezed,Object? reps = freezed,}) {
  return _then(SetLog(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,sessionExerciseId: null == sessionExerciseId ? _self.sessionExerciseId : sessionExerciseId // ignore: cast_nullable_to_non_nullable
as int,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,isWarmup: null == isWarmup ? _self.isWarmup : isWarmup // ignore: cast_nullable_to_non_nullable
as bool,kg: freezed == kg ? _self.kg : kg // ignore: cast_nullable_to_non_nullable
as double?,reps: freezed == reps ? _self.reps : reps // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [SetLog].
extension SetLogPatterns on SetLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SetLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SetLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SetLog value)  $default,){
final _that = this;
switch (_that) {
case _SetLog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SetLog value)?  $default,){
final _that = this;
switch (_that) {
case _SetLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int sessionExerciseId,  int position,  bool isWarmup,  double? kg,  int? reps)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SetLog() when $default != null:
return $default(_that.id,_that.sessionExerciseId,_that.position,_that.isWarmup,_that.kg,_that.reps);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int sessionExerciseId,  int position,  bool isWarmup,  double? kg,  int? reps)  $default,) {final _that = this;
switch (_that) {
case _SetLog():
return $default(_that.id,_that.sessionExerciseId,_that.position,_that.isWarmup,_that.kg,_that.reps);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int sessionExerciseId,  int position,  bool isWarmup,  double? kg,  int? reps)?  $default,) {final _that = this;
switch (_that) {
case _SetLog() when $default != null:
return $default(_that.id,_that.sessionExerciseId,_that.position,_that.isWarmup,_that.kg,_that.reps);case _:
  return null;

}
}

}

/// @nodoc


class _SetLog implements SetLog {
  const _SetLog({required this.id, required this.sessionExerciseId, required this.position, required this.isWarmup, this.kg, this.reps});
  

@override final  int id;
@override final  int sessionExerciseId;
@override final  int position;
@override final  bool isWarmup;
@override final  double? kg;
@override final  int? reps;

/// Create a copy of SetLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetLogCopyWith<_SetLog> get copyWith => __$SetLogCopyWithImpl<_SetLog>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetLog&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionExerciseId, sessionExerciseId) || other.sessionExerciseId == sessionExerciseId)&&(identical(other.position, position) || other.position == position)&&(identical(other.isWarmup, isWarmup) || other.isWarmup == isWarmup)&&(identical(other.kg, kg) || other.kg == kg)&&(identical(other.reps, reps) || other.reps == reps));
}


@override
int get hashCode => Object.hash(runtimeType,id,sessionExerciseId,position,isWarmup,kg,reps);

@override
String toString() {
  return 'SetLog(id: $id, sessionExerciseId: $sessionExerciseId, position: $position, isWarmup: $isWarmup, kg: $kg, reps: $reps)';
}


}

/// @nodoc
abstract mixin class _$SetLogCopyWith<$Res> implements $SetLogCopyWith<$Res> {
  factory _$SetLogCopyWith(_SetLog value, $Res Function(_SetLog) _then) = __$SetLogCopyWithImpl;
@override @useResult
$Res call({
 int id, int sessionExerciseId, int position, bool isWarmup, double? kg, int? reps
});




}
/// @nodoc
class __$SetLogCopyWithImpl<$Res>
    implements _$SetLogCopyWith<$Res> {
  __$SetLogCopyWithImpl(this._self, this._then);

  final _SetLog _self;
  final $Res Function(_SetLog) _then;

/// Create a copy of SetLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sessionExerciseId = null,Object? position = null,Object? isWarmup = null,Object? kg = freezed,Object? reps = freezed,}) {
  return _then(_SetLog(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,sessionExerciseId: null == sessionExerciseId ? _self.sessionExerciseId : sessionExerciseId // ignore: cast_nullable_to_non_nullable
as int,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,isWarmup: null == isWarmup ? _self.isWarmup : isWarmup // ignore: cast_nullable_to_non_nullable
as bool,kg: freezed == kg ? _self.kg : kg // ignore: cast_nullable_to_non_nullable
as double?,reps: freezed == reps ? _self.reps : reps // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
