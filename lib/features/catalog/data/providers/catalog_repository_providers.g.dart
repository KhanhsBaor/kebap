// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_repository_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(muscleGroupRepository)
final muscleGroupRepositoryProvider = MuscleGroupRepositoryProvider._();

final class MuscleGroupRepositoryProvider
    extends
        $FunctionalProvider<
          MuscleGroupRepository,
          MuscleGroupRepository,
          MuscleGroupRepository
        >
    with $Provider<MuscleGroupRepository> {
  MuscleGroupRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'muscleGroupRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$muscleGroupRepositoryHash();

  @$internal
  @override
  $ProviderElement<MuscleGroupRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MuscleGroupRepository create(Ref ref) {
    return muscleGroupRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MuscleGroupRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MuscleGroupRepository>(value),
    );
  }
}

String _$muscleGroupRepositoryHash() =>
    r'e9ef2d579c2bc2869d88f83d6eda8d4441b09bd6';

@ProviderFor(exerciseRepository)
final exerciseRepositoryProvider = ExerciseRepositoryProvider._();

final class ExerciseRepositoryProvider
    extends
        $FunctionalProvider<
          ExerciseRepository,
          ExerciseRepository,
          ExerciseRepository
        >
    with $Provider<ExerciseRepository> {
  ExerciseRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exerciseRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exerciseRepositoryHash();

  @$internal
  @override
  $ProviderElement<ExerciseRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ExerciseRepository create(Ref ref) {
    return exerciseRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExerciseRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExerciseRepository>(value),
    );
  }
}

String _$exerciseRepositoryHash() =>
    r'd568021872f9f16343ef7abbd7c14678e9fe0e11';
