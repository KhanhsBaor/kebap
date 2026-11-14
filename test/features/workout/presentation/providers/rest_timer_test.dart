import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kebap/features/workout/presentation/providers/rest_timer_notifier.dart';

void main() {
  test('starts at the default, steps by 15 seconds, and dismisses', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final timer = container.read(restTimerProvider.notifier);

    expect(container.read(restTimerProvider), isNull);

    timer.start();
    expect(container.read(restTimerProvider), RestTimerNotifier.defaultSeconds);

    timer.addStep();
    expect(
      container.read(restTimerProvider),
      RestTimerNotifier.defaultSeconds + RestTimerNotifier.stepSeconds,
    );

    timer.subtractStep();
    timer.subtractStep();
    expect(
      container.read(restTimerProvider),
      RestTimerNotifier.defaultSeconds - RestTimerNotifier.stepSeconds,
    );

    timer.dismiss();
    expect(container.read(restTimerProvider), isNull);
    timer.addStep();
    expect(container.read(restTimerProvider), isNull);
  });

  test('tick counts down one second and stops at zero', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final timer = container.read(restTimerProvider.notifier);

    timer.tick();
    expect(container.read(restTimerProvider), isNull);

    timer.start();
    timer.tick();
    expect(
      container.read(restTimerProvider),
      RestTimerNotifier.defaultSeconds - 1,
    );

    for (var index = 0; index < RestTimerNotifier.defaultSeconds; index++) {
      timer.tick();
    }
    expect(container.read(restTimerProvider), 0);
    timer.tick();
    expect(container.read(restTimerProvider), 0);
  });

  test('subtract stops at zero', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final timer = container.read(restTimerProvider.notifier);

    timer.start();
    final steps =
        RestTimerNotifier.defaultSeconds ~/ RestTimerNotifier.stepSeconds + 1;
    for (var index = 0; index < steps; index++) {
      timer.subtractStep();
    }

    expect(container.read(restTimerProvider), 0);
  });
}
