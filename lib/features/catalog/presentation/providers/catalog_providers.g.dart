// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(bodyRegions)
final bodyRegionsProvider = BodyRegionsProvider._();

final class BodyRegionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BodyRegion>>,
          List<BodyRegion>,
          Stream<List<BodyRegion>>
        >
    with $FutureModifier<List<BodyRegion>>, $StreamProvider<List<BodyRegion>> {
  BodyRegionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bodyRegionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bodyRegionsHash();

  @$internal
  @override
  $StreamProviderElement<List<BodyRegion>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<BodyRegion>> create(Ref ref) {
    return bodyRegions(ref);
  }
}

String _$bodyRegionsHash() => r'af0d5f0a9787af7c71bdea819b8855a5963c8485';

@ProviderFor(muscleGroups)
final muscleGroupsProvider = MuscleGroupsProvider._();

final class MuscleGroupsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MuscleGroup>>,
          List<MuscleGroup>,
          Stream<List<MuscleGroup>>
        >
    with
        $FutureModifier<List<MuscleGroup>>,
        $StreamProvider<List<MuscleGroup>> {
  MuscleGroupsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'muscleGroupsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$muscleGroupsHash();

  @$internal
  @override
  $StreamProviderElement<List<MuscleGroup>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<MuscleGroup>> create(Ref ref) {
    return muscleGroups(ref);
  }
}

String _$muscleGroupsHash() => r'0e804095992620875b771ed45a1f7f21cdd950f6';
