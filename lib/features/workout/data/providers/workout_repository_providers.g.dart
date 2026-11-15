// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_repository_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(workoutRepository)
final workoutRepositoryProvider = WorkoutRepositoryProvider._();

final class WorkoutRepositoryProvider
    extends
        $FunctionalProvider<
          WorkoutRepository,
          WorkoutRepository,
          WorkoutRepository
        >
    with $Provider<WorkoutRepository> {
  WorkoutRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workoutRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workoutRepositoryHash();

  @$internal
  @override
  $ProviderElement<WorkoutRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WorkoutRepository create(Ref ref) {
    return workoutRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WorkoutRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WorkoutRepository>(value),
    );
  }
}

String _$workoutRepositoryHash() => r'df86744e93a1b997dd9ef4bf8e3e3bf5430ba150';

@ProviderFor(workoutTransactionRunner)
final workoutTransactionRunnerProvider = WorkoutTransactionRunnerProvider._();

final class WorkoutTransactionRunnerProvider
    extends
        $FunctionalProvider<
          WorkoutTransactionRunner,
          WorkoutTransactionRunner,
          WorkoutTransactionRunner
        >
    with $Provider<WorkoutTransactionRunner> {
  WorkoutTransactionRunnerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workoutTransactionRunnerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workoutTransactionRunnerHash();

  @$internal
  @override
  $ProviderElement<WorkoutTransactionRunner> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WorkoutTransactionRunner create(Ref ref) {
    return workoutTransactionRunner(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WorkoutTransactionRunner value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WorkoutTransactionRunner>(value),
    );
  }
}

String _$workoutTransactionRunnerHash() =>
    r'ef37ae80376da7d0eee7653fcab4125b524dddf0';
