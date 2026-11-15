import 'package:flutter_test/flutter_test.dart';
import 'package:kebap/features/workout/domain/failures/workout_rule_exception.dart';
import 'package:kebap/features/workout/domain/usecases/start_workout.dart';
import 'package:mocktail/mocktail.dart';

import '../support/mock_repositories.dart';
import '../support/workout_fixtures.dart';

void main() {
  late MockWorkoutRepository workouts;
  late MockMuscleGroupRepository groups;
  late StartWorkout useCase;

  setUpAll(registerWorkoutFallbacks);

  setUp(() {
    workouts = MockWorkoutRepository();
    groups = MockMuscleGroupRepository();
    useCase = StartWorkout(
      workoutRepository: workouts,
      muscleGroupRepository: groups,
    );
  });

  test('inserts an in-progress session and keeps muscle group order', () async {
    final inserted = workoutSession(muscleGroupIds: [tricepsId, chestId]);
    when(() => workouts.findInProgress()).thenAnswer((_) async => null);
    when(
      () => groups.listAll(),
    ).thenAnswer((_) async => [chestGroup, tricepsGroup, quadricepsGroup]);
    when(
      () => workouts.insertInProgress(
        startedAt: any(named: 'startedAt'),
        muscleGroupIds: any(named: 'muscleGroupIds'),
      ),
    ).thenAnswer((_) async => inserted);

    final result = await useCase.call(
      regionId: upperRegionId,
      muscleGroupIds: [tricepsId, chestId],
      startedAt: fixtureStartedAt,
    );

    expect(result, same(inserted));
    verify(
      () => workouts.insertInProgress(
        startedAt: fixtureStartedAt,
        muscleGroupIds: any(
          named: 'muscleGroupIds',
          that: equals([tricepsId, chestId]),
        ),
      ),
    ).called(1);
  });

  test(
    'throws when a session is already in progress and does not insert',
    () async {
      when(
        () => workouts.findInProgress(),
      ).thenAnswer((_) async => workoutSession());

      await expectLater(
        useCase.call(
          regionId: upperRegionId,
          muscleGroupIds: [chestId],
          startedAt: fixtureStartedAt,
        ),
        throwsA(isA<WorkoutAlreadyInProgress>()),
      );
      verifyNever(
        () => workouts.insertInProgress(
          startedAt: any(named: 'startedAt'),
          muscleGroupIds: any(named: 'muscleGroupIds'),
        ),
      );
    },
  );

  test('throws when no muscle group is selected', () async {
    await expectLater(
      useCase.call(
        regionId: upperRegionId,
        muscleGroupIds: const [],
        startedAt: fixtureStartedAt,
      ),
      throwsA(isA<MuscleGroupsRequired>()),
    );
    verifyNever(
      () => workouts.insertInProgress(
        startedAt: any(named: 'startedAt'),
        muscleGroupIds: any(named: 'muscleGroupIds'),
      ),
    );
  });

  test('throws when a muscle group id is repeated', () async {
    await expectLater(
      useCase.call(
        regionId: upperRegionId,
        muscleGroupIds: [chestId, chestId],
        startedAt: fixtureStartedAt,
      ),
      throwsA(isA<DuplicateMuscleGroup>()),
    );
    verifyNever(
      () => workouts.insertInProgress(
        startedAt: any(named: 'startedAt'),
        muscleGroupIds: any(named: 'muscleGroupIds'),
      ),
    );
  });

  test('throws when a muscle group id does not exist', () async {
    when(() => workouts.findInProgress()).thenAnswer((_) async => null);
    when(() => groups.listAll()).thenAnswer((_) async => [chestGroup]);

    await expectLater(
      useCase.call(
        regionId: upperRegionId,
        muscleGroupIds: [chestId, 99],
        startedAt: fixtureStartedAt,
      ),
      throwsA(isA<MuscleGroupNotFound>()),
    );
    verifyNever(
      () => workouts.insertInProgress(
        startedAt: any(named: 'startedAt'),
        muscleGroupIds: any(named: 'muscleGroupIds'),
      ),
    );
  });

  test('throws when a muscle group belongs to another region', () async {
    when(() => workouts.findInProgress()).thenAnswer((_) async => null);
    when(
      () => groups.listAll(),
    ).thenAnswer((_) async => [chestGroup, quadricepsGroup]);

    await expectLater(
      useCase.call(
        regionId: upperRegionId,
        muscleGroupIds: [chestId, quadricepsId],
        startedAt: fixtureStartedAt,
      ),
      throwsA(isA<MuscleGroupOutsideRegion>()),
    );
    verifyNever(
      () => workouts.insertInProgress(
        startedAt: any(named: 'startedAt'),
        muscleGroupIds: any(named: 'muscleGroupIds'),
      ),
    );
  });
}
