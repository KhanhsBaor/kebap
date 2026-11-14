// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_workout_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Session commands. Each method calls one use case and stores a notice
/// when the screen has to ask or explain.
///
/// [requestFinish] / [confirmFinish] take [plannedSetsByExercise] keyed by
/// session exercise id. Omit a key to use
/// [FinishWorkout.defaultPlannedSetsPerExercise]. For an unsaved draft row
/// (`docs/06` mục 5), pass saved count + 1 for that exercise so the confirm
/// dialog counts it; the draft itself is not written here.

@ProviderFor(ActiveWorkoutCommands)
final activeWorkoutCommandsProvider = ActiveWorkoutCommandsProvider._();

/// Session commands. Each method calls one use case and stores a notice
/// when the screen has to ask or explain.
///
/// [requestFinish] / [confirmFinish] take [plannedSetsByExercise] keyed by
/// session exercise id. Omit a key to use
/// [FinishWorkout.defaultPlannedSetsPerExercise]. For an unsaved draft row
/// (`docs/06` mục 5), pass saved count + 1 for that exercise so the confirm
/// dialog counts it; the draft itself is not written here.
final class ActiveWorkoutCommandsProvider
    extends $NotifierProvider<ActiveWorkoutCommands, ActiveWorkoutNotice?> {
  /// Session commands. Each method calls one use case and stores a notice
  /// when the screen has to ask or explain.
  ///
  /// [requestFinish] / [confirmFinish] take [plannedSetsByExercise] keyed by
  /// session exercise id. Omit a key to use
  /// [FinishWorkout.defaultPlannedSetsPerExercise]. For an unsaved draft row
  /// (`docs/06` mục 5), pass saved count + 1 for that exercise so the confirm
  /// dialog counts it; the draft itself is not written here.
  ActiveWorkoutCommandsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeWorkoutCommandsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeWorkoutCommandsHash();

  @$internal
  @override
  ActiveWorkoutCommands create() => ActiveWorkoutCommands();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ActiveWorkoutNotice? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ActiveWorkoutNotice?>(value),
    );
  }
}

String _$activeWorkoutCommandsHash() =>
    r'602ce182c88eafd6c0336f3199197f4c65c7681f';

/// Session commands. Each method calls one use case and stores a notice
/// when the screen has to ask or explain.
///
/// [requestFinish] / [confirmFinish] take [plannedSetsByExercise] keyed by
/// session exercise id. Omit a key to use
/// [FinishWorkout.defaultPlannedSetsPerExercise]. For an unsaved draft row
/// (`docs/06` mục 5), pass saved count + 1 for that exercise so the confirm
/// dialog counts it; the draft itself is not written here.

abstract class _$ActiveWorkoutCommands extends $Notifier<ActiveWorkoutNotice?> {
  ActiveWorkoutNotice? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ActiveWorkoutNotice?, ActiveWorkoutNotice?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ActiveWorkoutNotice?, ActiveWorkoutNotice?>,
              ActiveWorkoutNotice?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
