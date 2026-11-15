// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'previous_sets.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Saved sets from the latest completed session of [exerciseId]
/// that ended before this session started. Empty when there is none.

@ProviderFor(previousSets)
final previousSetsProvider = PreviousSetsFamily._();

/// Saved sets from the latest completed session of [exerciseId]
/// that ended before this session started. Empty when there is none.

final class PreviousSetsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SetLog>>,
          List<SetLog>,
          FutureOr<List<SetLog>>
        >
    with $FutureModifier<List<SetLog>>, $FutureProvider<List<SetLog>> {
  /// Saved sets from the latest completed session of [exerciseId]
  /// that ended before this session started. Empty when there is none.
  PreviousSetsProvider._({
    required PreviousSetsFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'previousSetsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$previousSetsHash();

  @override
  String toString() {
    return r'previousSetsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<SetLog>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<SetLog>> create(Ref ref) {
    final argument = this.argument as int;
    return previousSets(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PreviousSetsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$previousSetsHash() => r'1a4461add76465cb26771ae105f08110a704f557';

/// Saved sets from the latest completed session of [exerciseId]
/// that ended before this session started. Empty when there is none.

final class PreviousSetsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<SetLog>>, int> {
  PreviousSetsFamily._()
    : super(
        retry: null,
        name: r'previousSetsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Saved sets from the latest completed session of [exerciseId]
  /// that ended before this session started. Empty when there is none.

  PreviousSetsProvider call(int exerciseId) =>
      PreviousSetsProvider._(argument: exerciseId, from: this);

  @override
  String toString() => r'previousSetsProvider';
}
