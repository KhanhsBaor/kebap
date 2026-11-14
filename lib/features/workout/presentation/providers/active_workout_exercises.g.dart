// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_workout_exercises.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Catalog exercises for the muscle groups on the open session.

@ProviderFor(activeWorkoutExercises)
final activeWorkoutExercisesProvider = ActiveWorkoutExercisesProvider._();

/// Catalog exercises for the muscle groups on the open session.

final class ActiveWorkoutExercisesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Exercise>>,
          List<Exercise>,
          Stream<List<Exercise>>
        >
    with $FutureModifier<List<Exercise>>, $StreamProvider<List<Exercise>> {
  /// Catalog exercises for the muscle groups on the open session.
  ActiveWorkoutExercisesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeWorkoutExercisesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeWorkoutExercisesHash();

  @$internal
  @override
  $StreamProviderElement<List<Exercise>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Exercise>> create(Ref ref) {
    return activeWorkoutExercises(ref);
  }
}

String _$activeWorkoutExercisesHash() =>
    r'c325fb6b7f7196d0e875451e59cf39e0289ab1e6';
