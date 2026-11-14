// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rest_timer_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// In-memory rest countdown. Null means the timer is hidden.
///
/// Stores remaining seconds only — no wall clock. The screen drives the
/// 1 Hz countdown with [tick] (Ticker / periodic callback). [addStep] and
/// [subtractStep] are the ±15 second buttons from docs/05. Default 90
/// seconds is the general-health row in docs/01. Nothing is written to
/// the database; kill app drops this state (docs/06).

@ProviderFor(RestTimerNotifier)
final restTimerProvider = RestTimerNotifierProvider._();

/// In-memory rest countdown. Null means the timer is hidden.
///
/// Stores remaining seconds only — no wall clock. The screen drives the
/// 1 Hz countdown with [tick] (Ticker / periodic callback). [addStep] and
/// [subtractStep] are the ±15 second buttons from docs/05. Default 90
/// seconds is the general-health row in docs/01. Nothing is written to
/// the database; kill app drops this state (docs/06).
final class RestTimerNotifierProvider
    extends $NotifierProvider<RestTimerNotifier, int?> {
  /// In-memory rest countdown. Null means the timer is hidden.
  ///
  /// Stores remaining seconds only — no wall clock. The screen drives the
  /// 1 Hz countdown with [tick] (Ticker / periodic callback). [addStep] and
  /// [subtractStep] are the ±15 second buttons from docs/05. Default 90
  /// seconds is the general-health row in docs/01. Nothing is written to
  /// the database; kill app drops this state (docs/06).
  RestTimerNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'restTimerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$restTimerNotifierHash();

  @$internal
  @override
  RestTimerNotifier create() => RestTimerNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int?>(value),
    );
  }
}

String _$restTimerNotifierHash() => r'13eb8a6fca9522f6bc3ee710059ec2dee5961829';

/// In-memory rest countdown. Null means the timer is hidden.
///
/// Stores remaining seconds only — no wall clock. The screen drives the
/// 1 Hz countdown with [tick] (Ticker / periodic callback). [addStep] and
/// [subtractStep] are the ±15 second buttons from docs/05. Default 90
/// seconds is the general-health row in docs/01. Nothing is written to
/// the database; kill app drops this state (docs/06).

abstract class _$RestTimerNotifier extends $Notifier<int?> {
  int? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int?, int?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int?, int?>,
              int?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
