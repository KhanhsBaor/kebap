// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_exercise.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SessionExercise {

 int get id; int get exerciseId; int get position; List<SetLog> get sets;
/// Create a copy of SessionExercise
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionExerciseCopyWith<SessionExercise> get copyWith => _$SessionExerciseCopyWithImpl<SessionExercise>(this as SessionExercise, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionExercise&&(identical(other.id, id) || other.id == id)&&(identical(other.exerciseId, exerciseId) || other.exerciseId == exerciseId)&&(identical(other.position, position) || other.position == position)&&const DeepCollectionEquality().equals(other.sets, sets));
}


@override
int get hashCode => Object.hash(runtimeType,id,exerciseId,position,const DeepCollectionEquality().hash(sets));

@override
String toString() {
  return 'SessionExercise(id: $id, exerciseId: $exerciseId, position: $position, sets: $sets)';
}


}

/// @nodoc
abstract mixin class $SessionExerciseCopyWith<$Res>  {
  factory $SessionExerciseCopyWith(SessionExercise value, $Res Function(SessionExercise) _then) = _$SessionExerciseCopyWithImpl;
@useResult
$Res call({
 int id, int exerciseId, int position, List<SetLog> sets
});




}
/// @nodoc
class _$SessionExerciseCopyWithImpl<$Res>
    implements $SessionExerciseCopyWith<$Res> {
  _$SessionExerciseCopyWithImpl(this._self, this._then);

  final SessionExercise _self;
  final $Res Function(SessionExercise) _then;

/// Create a copy of SessionExercise
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? exerciseId = null,Object? position = null,Object? sets = null,}) {
  return _then(SessionExercise(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,exerciseId: null == exerciseId ? _self.exerciseId : exerciseId // ignore: cast_nullable_to_non_nullable
as int,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,sets: null == sets ? _self.sets : sets // ignore: cast_nullable_to_non_nullable
as List<SetLog>,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionExercise].
extension SessionExercisePatterns on SessionExercise {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionExercise value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionExercise() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionExercise value)  $default,){
final _that = this;
switch (_that) {
case _SessionExercise():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionExercise value)?  $default,){
final _that = this;
switch (_that) {
case _SessionExercise() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int exerciseId,  int position,  List<SetLog> sets)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionExercise() when $default != null:
return $default(_that.id,_that.exerciseId,_that.position,_that.sets);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int exerciseId,  int position,  List<SetLog> sets)  $default,) {final _that = this;
switch (_that) {
case _SessionExercise():
return $default(_that.id,_that.exerciseId,_that.position,_that.sets);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int exerciseId,  int position,  List<SetLog> sets)?  $default,) {final _that = this;
switch (_that) {
case _SessionExercise() when $default != null:
return $default(_that.id,_that.exerciseId,_that.position,_that.sets);case _:
  return null;

}
}

}

/// @nodoc


class _SessionExercise implements SessionExercise {
  const _SessionExercise({required this.id, required this.exerciseId, required this.position,  List<SetLog> sets = const <SetLog>[]}): _sets = sets;
  

@override final  int id;
@override final  int exerciseId;
@override final  int position;
 final  List<SetLog> _sets;
@override@JsonKey() List<SetLog> get sets {
  if (_sets is EqualUnmodifiableListView) return _sets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sets);
}


/// Create a copy of SessionExercise
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionExerciseCopyWith<_SessionExercise> get copyWith => __$SessionExerciseCopyWithImpl<_SessionExercise>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionExercise&&(identical(other.id, id) || other.id == id)&&(identical(other.exerciseId, exerciseId) || other.exerciseId == exerciseId)&&(identical(other.position, position) || other.position == position)&&const DeepCollectionEquality().equals(other._sets, _sets));
}


@override
int get hashCode => Object.hash(runtimeType,id,exerciseId,position,const DeepCollectionEquality().hash(_sets));

@override
String toString() {
  return 'SessionExercise(id: $id, exerciseId: $exerciseId, position: $position, sets: $sets)';
}


}

/// @nodoc
abstract mixin class _$SessionExerciseCopyWith<$Res> implements $SessionExerciseCopyWith<$Res> {
  factory _$SessionExerciseCopyWith(_SessionExercise value, $Res Function(_SessionExercise) _then) = __$SessionExerciseCopyWithImpl;
@override @useResult
$Res call({
 int id, int exerciseId, int position, List<SetLog> sets
});




}
/// @nodoc
class __$SessionExerciseCopyWithImpl<$Res>
    implements _$SessionExerciseCopyWith<$Res> {
  __$SessionExerciseCopyWithImpl(this._self, this._then);

  final _SessionExercise _self;
  final $Res Function(_SessionExercise) _then;

/// Create a copy of SessionExercise
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? exerciseId = null,Object? position = null,Object? sets = null,}) {
  return _then(_SessionExercise(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,exerciseId: null == exerciseId ? _self.exerciseId : exerciseId // ignore: cast_nullable_to_non_nullable
as int,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,sets: null == sets ? _self._sets : sets // ignore: cast_nullable_to_non_nullable
as List<SetLog>,
  ));
}


}

// dart format on
