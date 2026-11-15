// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rest_timer_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Clock for the rest countdown. Tests override this so they do not wait.

@ProviderFor(workoutClock)
final workoutClockProvider = WorkoutClockProvider._();

/// Clock for the rest countdown. Tests override this so they do not wait.

final class WorkoutClockProvider
    extends
        $FunctionalProvider<
          DateTime Function(),
          DateTime Function(),
          DateTime Function()
        >
    with $Provider<DateTime Function()> {
  /// Clock for the rest countdown. Tests override this so they do not wait.
  WorkoutClockProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workoutClockProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workoutClockHash();

  @$internal
  @override
  $ProviderElement<DateTime Function()> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DateTime Function() create(Ref ref) {
    return workoutClock(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime Function() value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime Function()>(value),
    );
  }
}

String _$workoutClockHash() => r'66d12c9b2e08b1aefb721531c39e1efe06de5b81';

/// In-memory rest countdown. Null means the timer is hidden.
///
/// The stored value is the moment the rest ends, not a tick count, so a
/// gap in the background does not drift the display. Nothing is written
/// to the database; killing the app drops this state (docs/06).

@ProviderFor(RestTimerNotifier)
final restTimerProvider = RestTimerNotifierProvider._();

/// In-memory rest countdown. Null means the timer is hidden.
///
/// The stored value is the moment the rest ends, not a tick count, so a
/// gap in the background does not drift the display. Nothing is written
/// to the database; killing the app drops this state (docs/06).
final class RestTimerNotifierProvider
    extends $NotifierProvider<RestTimerNotifier, DateTime?> {
  /// In-memory rest countdown. Null means the timer is hidden.
  ///
  /// The stored value is the moment the rest ends, not a tick count, so a
  /// gap in the background does not drift the display. Nothing is written
  /// to the database; killing the app drops this state (docs/06).
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
  Override overrideWithValue(DateTime? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime?>(value),
    );
  }
}

String _$restTimerNotifierHash() => r'7c78ebbe132830079f79eebaeca4c10514ed65a8';

/// In-memory rest countdown. Null means the timer is hidden.
///
/// The stored value is the moment the rest ends, not a tick count, so a
/// gap in the background does not drift the display. Nothing is written
/// to the database; killing the app drops this state (docs/06).

abstract class _$RestTimerNotifier extends $Notifier<DateTime?> {
  DateTime? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DateTime?, DateTime?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DateTime?, DateTime?>,
              DateTime?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
