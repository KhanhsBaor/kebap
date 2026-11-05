// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WorkoutSession {

 int get id; WorkoutStatus get status; DateTime get startedAt; DateTime? get endedAt; int? get splitDayId; List<int> get muscleGroupIds; List<SessionExercise> get exercises;
/// Create a copy of WorkoutSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkoutSessionCopyWith<WorkoutSession> get copyWith => _$WorkoutSessionCopyWithImpl<WorkoutSession>(this as WorkoutSession, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkoutSession&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.splitDayId, splitDayId) || other.splitDayId == splitDayId)&&const DeepCollectionEquality().equals(other.muscleGroupIds, muscleGroupIds)&&const DeepCollectionEquality().equals(other.exercises, exercises));
}


@override
int get hashCode => Object.hash(runtimeType,id,status,startedAt,endedAt,splitDayId,const DeepCollectionEquality().hash(muscleGroupIds),const DeepCollectionEquality().hash(exercises));

@override
String toString() {
  return 'WorkoutSession(id: $id, status: $status, startedAt: $startedAt, endedAt: $endedAt, splitDayId: $splitDayId, muscleGroupIds: $muscleGroupIds, exercises: $exercises)';
}


}

/// @nodoc
abstract mixin class $WorkoutSessionCopyWith<$Res>  {
  factory $WorkoutSessionCopyWith(WorkoutSession value, $Res Function(WorkoutSession) _then) = _$WorkoutSessionCopyWithImpl;
@useResult
$Res call({
 int id, WorkoutStatus status, DateTime startedAt, DateTime? endedAt, int? splitDayId, List<int> muscleGroupIds, List<SessionExercise> exercises
});




}
/// @nodoc
class _$WorkoutSessionCopyWithImpl<$Res>
    implements $WorkoutSessionCopyWith<$Res> {
  _$WorkoutSessionCopyWithImpl(this._self, this._then);

  final WorkoutSession _self;
  final $Res Function(WorkoutSession) _then;

/// Create a copy of WorkoutSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = null,Object? startedAt = null,Object? endedAt = freezed,Object? splitDayId = freezed,Object? muscleGroupIds = null,Object? exercises = null,}) {
  return _then(WorkoutSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as WorkoutStatus,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,splitDayId: freezed == splitDayId ? _self.splitDayId : splitDayId // ignore: cast_nullable_to_non_nullable
as int?,muscleGroupIds: null == muscleGroupIds ? _self.muscleGroupIds : muscleGroupIds // ignore: cast_nullable_to_non_nullable
as List<int>,exercises: null == exercises ? _self.exercises : exercises // ignore: cast_nullable_to_non_nullable
as List<SessionExercise>,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkoutSession].
extension WorkoutSessionPatterns on WorkoutSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkoutSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkoutSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkoutSession value)  $default,){
final _that = this;
switch (_that) {
case _WorkoutSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkoutSession value)?  $default,){
final _that = this;
switch (_that) {
case _WorkoutSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  WorkoutStatus status,  DateTime startedAt,  DateTime? endedAt,  int? splitDayId,  List<int> muscleGroupIds,  List<SessionExercise> exercises)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkoutSession() when $default != null:
return $default(_that.id,_that.status,_that.startedAt,_that.endedAt,_that.splitDayId,_that.muscleGroupIds,_that.exercises);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  WorkoutStatus status,  DateTime startedAt,  DateTime? endedAt,  int? splitDayId,  List<int> muscleGroupIds,  List<SessionExercise> exercises)  $default,) {final _that = this;
switch (_that) {
case _WorkoutSession():
return $default(_that.id,_that.status,_that.startedAt,_that.endedAt,_that.splitDayId,_that.muscleGroupIds,_that.exercises);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  WorkoutStatus status,  DateTime startedAt,  DateTime? endedAt,  int? splitDayId,  List<int> muscleGroupIds,  List<SessionExercise> exercises)?  $default,) {final _that = this;
switch (_that) {
case _WorkoutSession() when $default != null:
return $default(_that.id,_that.status,_that.startedAt,_that.endedAt,_that.splitDayId,_that.muscleGroupIds,_that.exercises);case _:
  return null;

}
}

}

/// @nodoc


class _WorkoutSession implements WorkoutSession {
  const _WorkoutSession({required this.id, required this.status, required this.startedAt, this.endedAt, this.splitDayId, required  List<int> muscleGroupIds,  List<SessionExercise> exercises = const <SessionExercise>[]}): _muscleGroupIds = muscleGroupIds,_exercises = exercises;
  

@override final  int id;
@override final  WorkoutStatus status;
@override final  DateTime startedAt;
@override final  DateTime? endedAt;
@override final  int? splitDayId;
 final  List<int> _muscleGroupIds;
@override List<int> get muscleGroupIds {
  if (_muscleGroupIds is EqualUnmodifiableListView) return _muscleGroupIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_muscleGroupIds);
}

 final  List<SessionExercise> _exercises;
@override@JsonKey() List<SessionExercise> get exercises {
  if (_exercises is EqualUnmodifiableListView) return _exercises;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_exercises);
}


/// Create a copy of WorkoutSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkoutSessionCopyWith<_WorkoutSession> get copyWith => __$WorkoutSessionCopyWithImpl<_WorkoutSession>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkoutSession&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.splitDayId, splitDayId) || other.splitDayId == splitDayId)&&const DeepCollectionEquality().equals(other._muscleGroupIds, _muscleGroupIds)&&const DeepCollectionEquality().equals(other._exercises, _exercises));
}


@override
int get hashCode => Object.hash(runtimeType,id,status,startedAt,endedAt,splitDayId,const DeepCollectionEquality().hash(_muscleGroupIds),const DeepCollectionEquality().hash(_exercises));

@override
String toString() {
  return 'WorkoutSession(id: $id, status: $status, startedAt: $startedAt, endedAt: $endedAt, splitDayId: $splitDayId, muscleGroupIds: $muscleGroupIds, exercises: $exercises)';
}


}

/// @nodoc
abstract mixin class _$WorkoutSessionCopyWith<$Res> implements $WorkoutSessionCopyWith<$Res> {
  factory _$WorkoutSessionCopyWith(_WorkoutSession value, $Res Function(_WorkoutSession) _then) = __$WorkoutSessionCopyWithImpl;
@override @useResult
$Res call({
 int id, WorkoutStatus status, DateTime startedAt, DateTime? endedAt, int? splitDayId, List<int> muscleGroupIds, List<SessionExercise> exercises
});




}
/// @nodoc
class __$WorkoutSessionCopyWithImpl<$Res>
    implements _$WorkoutSessionCopyWith<$Res> {
  __$WorkoutSessionCopyWithImpl(this._self, this._then);

  final _WorkoutSession _self;
  final $Res Function(_WorkoutSession) _then;

/// Create a copy of WorkoutSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = null,Object? startedAt = null,Object? endedAt = freezed,Object? splitDayId = freezed,Object? muscleGroupIds = null,Object? exercises = null,}) {
  return _then(_WorkoutSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as WorkoutStatus,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,splitDayId: freezed == splitDayId ? _self.splitDayId : splitDayId // ignore: cast_nullable_to_non_nullable
as int?,muscleGroupIds: null == muscleGroupIds ? _self._muscleGroupIds : muscleGroupIds // ignore: cast_nullable_to_non_nullable
as List<int>,exercises: null == exercises ? _self._exercises : exercises // ignore: cast_nullable_to_non_nullable
as List<SessionExercise>,
  ));
}


}

// dart format on
