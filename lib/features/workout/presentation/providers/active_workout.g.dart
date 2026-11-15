// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_workout.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The in-progress session, or null. Groups, exercises, and saved sets
/// come from the workout repository watch.

@ProviderFor(activeWorkout)
final activeWorkoutProvider = ActiveWorkoutProvider._();

/// The in-progress session, or null. Groups, exercises, and saved sets
/// come from the workout repository watch.

final class ActiveWorkoutProvider
    extends
        $FunctionalProvider<
          AsyncValue<WorkoutSession?>,
          WorkoutSession?,
          Stream<WorkoutSession?>
        >
    with $FutureModifier<WorkoutSession?>, $StreamProvider<WorkoutSession?> {
  /// The in-progress session, or null. Groups, exercises, and saved sets
  /// come from the workout repository watch.
  ActiveWorkoutProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeWorkoutProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeWorkoutHash();

  @$internal
  @override
  $StreamProviderElement<WorkoutSession?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<WorkoutSession?> create(Ref ref) {
    return activeWorkout(ref);
  }
}

String _$activeWorkoutHash() => r'6283afab4e6fe68bbfe9767d5cdcb5dcba0a3b3a';
