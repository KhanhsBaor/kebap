import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kebap/features/workout/presentation/providers/rest_timer_notifier.dart';

void main() {
  final now = DateTime.utc(2026, 11, 14, 10);

  ProviderContainer container() {
    final scope = ProviderContainer(
      overrides: [
        workoutClockProvider.overrideWith(
          (ref) =>
              () => now,
        ),
      ],
    );
    addTearDown(scope.dispose);
    return scope;
  }

  test('starts at the default, steps by 15 seconds, and dismisses', () {
    final scope = container();
    final timer = scope.read(restTimerProvider.notifier);

    expect(timer.remainingSeconds(), isNull);

    timer.start();
    expect(timer.remainingSeconds(), RestTimerNotifier.defaultSeconds);

    timer.addStep();
    expect(
      timer.remainingSeconds(),
      RestTimerNotifier.defaultSeconds + RestTimerNotifier.stepSeconds,
    );

    timer.subtractStep();
    timer.subtractStep();
    expect(
      timer.remainingSeconds(),
      RestTimerNotifier.defaultSeconds - RestTimerNotifier.stepSeconds,
    );

    timer.dismiss();
    expect(timer.remainingSeconds(), isNull);
    timer.addStep();
    expect(timer.remainingSeconds(), isNull);
  });

  test('remaining follows the clock instead of a tick count', () {
    var clock = DateTime.utc(2026, 11, 14, 10);
    final scope = ProviderContainer(
      overrides: [
        workoutClockProvider.overrideWith(
          (ref) =>
              () => clock,
        ),
      ],
    );
    addTearDown(scope.dispose);
    final timer = scope.read(restTimerProvider.notifier);

    timer.start();
    clock = clock.add(const Duration(seconds: 1));
    expect(timer.remainingSeconds(), RestTimerNotifier.defaultSeconds - 1);

    clock = clock.add(Duration(seconds: RestTimerNotifier.defaultSeconds));
    expect(timer.remainingSeconds(), 0);
  });

  test('subtract stops at zero', () {
    final scope = container();
    final timer = scope.read(restTimerProvider.notifier);

    timer.start();
    final steps =
        RestTimerNotifier.defaultSeconds ~/ RestTimerNotifier.stepSeconds + 1;
    for (var index = 0; index < steps; index++) {
      timer.subtractStep();
    }

    expect(timer.remainingSeconds(), 0);
  });
}
