import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'rest_timer_notifier.g.dart';

/// In-memory rest countdown. Null means the timer is hidden.
///
/// Stores remaining seconds only — no wall clock. The screen drives the
/// 1 Hz countdown with [tick] (Ticker / periodic callback). [addStep] and
/// [subtractStep] are the ±15 second buttons from docs/05. Default 90
/// seconds is the general-health row in docs/01. Nothing is written to
/// the database; kill app drops this state (docs/06).
@riverpod
class RestTimerNotifier extends _$RestTimerNotifier {
  static const defaultSeconds = 90;
  static const stepSeconds = 15;

  @override
  int? build() => null;

  void start() => state = defaultSeconds;

  /// One second of countdown. No-op when hidden. Stops at 0.
  void tick() {
    final current = state;
    if (current == null || current <= 0) return;
    state = current - 1;
  }

  void addStep() {
    final current = state;
    if (current == null) return;
    state = current + stepSeconds;
  }

  void subtractStep() {
    final current = state;
    if (current == null) return;
    final next = current - stepSeconds;
    state = next < 0 ? 0 : next;
  }

  void dismiss() => state = null;
}
