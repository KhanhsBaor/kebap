import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'rest_timer_notifier.g.dart';

/// Clock for the rest countdown. Tests override this so they do not wait.
@riverpod
DateTime Function() workoutClock(Ref ref) => DateTime.now;

/// In-memory rest countdown. Null means the timer is hidden.
///
/// The stored value is the moment the rest ends, not a tick count, so a
/// gap in the background does not drift the display. Nothing is written
/// to the database; killing the app drops this state (docs/06).
@riverpod
class RestTimerNotifier extends _$RestTimerNotifier {
  static const defaultSeconds = 90;
  static const stepSeconds = 15;

  @override
  DateTime? build() => null;

  /// Whole seconds left, or null when the timer is hidden. Zero means
  /// the rest has finished and the bar is still visible.
  int? remainingSeconds() {
    final endsAt = state;
    if (endsAt == null) return null;
    final seconds = endsAt.difference(_now()).inSeconds;
    return seconds < 0 ? 0 : seconds;
  }

  void start() {
    state = _now().add(const Duration(seconds: defaultSeconds));
  }

  void addStep() {
    final endsAt = state;
    if (endsAt == null) return;
    state = endsAt.add(const Duration(seconds: stepSeconds));
  }

  void subtractStep() {
    final endsAt = state;
    if (endsAt == null) return;
    final next = endsAt.subtract(const Duration(seconds: stepSeconds));
    final now = _now();
    state = next.isBefore(now) ? now : next;
  }

  void dismiss() => state = null;

  DateTime _now() => ref.read(workoutClockProvider)();
}
