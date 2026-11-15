import 'package:flutter_test/flutter_test.dart';
import 'package:kebap/features/workout/domain/entities/workout_status.dart';
import 'package:kebap/features/workout/domain/failures/workout_rule_exception.dart';
import 'package:kebap/features/workout/domain/usecases/create_custom_exercise.dart';
import 'package:mocktail/mocktail.dart';

import '../support/mock_repositories.dart';
import '../support/workout_fixtures.dart';

void main() {
  late MockWorkoutRepository workouts;
  late MockExerciseRepository exercises;
  late CreateCustomExercise useCase;

  setUpAll(registerWorkoutFallbacks);

  setUp(() {
    workouts = MockWorkoutRepository();
    exercises = MockExerciseRepository();
    useCase = CreateCustomExercise(
      workoutRepository: workouts,
      exerciseRepository: exercises,
      transactionRunner: const PassthroughTransactionRunner(),
    );
    when(() => workouts.findById(1)).thenAnswer((_) async => workoutSession());
  });

  test('creates a custom exercise and adds it to the workout', () async {
    final created = catalogExercise(
      id: 90,
      nameEn: 'Close grip',
      isCustom: true,
    );
    final added = sessionExercise(exerciseId: 90);
    when(
      () => exercises.findByNameInGroup(
        muscleGroupId: chestId,
        name: 'Close grip',
      ),
    ).thenAnswer((_) async => null);
    when(
      () => exercises.insert(
        muscleGroupId: chestId,
        nameEn: 'Close grip',
        isCustom: true,
      ),
    ).thenAnswer((_) async => created);
    when(
      () => workouts.addExercise(workoutId: 1, exerciseId: 90),
    ).thenAnswer((_) async => added);

    final result = await useCase.call(
      workoutId: 1,
      name: '  Close grip  ',
      muscleGroupId: chestId,
    );

    expect(result, isA<CustomExerciseCreated>());
    final createdResult = result as CustomExerciseCreated;
    expect(createdResult.exercise, same(created));
    expect(createdResult.exercise.isCustom, isTrue);
    expect(createdResult.sessionExercise, same(added));
    verify(
      () => exercises.insert(
        muscleGroupId: chestId,
        nameEn: 'Close grip',
        isCustom: true,
      ),
    ).called(1);
  });

  test('keeps internal spaces in the trimmed name', () async {
    when(
      () => exercises.findByNameInGroup(
        muscleGroupId: chestId,
        name: 'Close  grip',
      ),
    ).thenAnswer((_) async => null);
    when(
      () => exercises.insert(
        muscleGroupId: any(named: 'muscleGroupId'),
        nameEn: any(named: 'nameEn'),
        isCustom: any(named: 'isCustom'),
      ),
    ).thenAnswer(
      (_) async => catalogExercise(nameEn: 'Close  grip', isCustom: true),
    );
    when(
      () => workouts.addExercise(
        workoutId: any(named: 'workoutId'),
        exerciseId: any(named: 'exerciseId'),
      ),
    ).thenAnswer((_) async => sessionExercise());

    await useCase.call(
      workoutId: 1,
      name: '  Close  grip  ',
      muscleGroupId: chestId,
    );

    verify(
      () => exercises.insert(
        muscleGroupId: chestId,
        nameEn: 'Close  grip',
        isCustom: true,
      ),
    ).called(1);
  });

  test('returns the existing exercise and does not insert or add it', () async {
    final seed = catalogExercise(nameVi: 'Đẩy ngực');
    when(
      () => exercises.findByNameInGroup(
        muscleGroupId: chestId,
        name: 'Bench Press',
      ),
    ).thenAnswer((_) async => seed);

    final result = await useCase.call(
      workoutId: 1,
      name: '  Bench Press  ',
      muscleGroupId: chestId,
    );

    expect(result, isA<CustomExerciseDuplicate>());
    expect((result as CustomExerciseDuplicate).exercise, same(seed));
    verifyNever(
      () => exercises.insert(
        muscleGroupId: any(named: 'muscleGroupId'),
        nameEn: any(named: 'nameEn'),
        isCustom: any(named: 'isCustom'),
      ),
    );
    verifyNever(
      () => workouts.addExercise(
        workoutId: any(named: 'workoutId'),
        exerciseId: any(named: 'exerciseId'),
      ),
    );
  });

  test('throws when the name is blank', () async {
    await expectLater(
      useCase.call(workoutId: 1, name: '   ', muscleGroupId: chestId),
      throwsA(isA<InvalidExerciseName>()),
    );
    verifyNever(() => workouts.findById(any()));
    verifyNever(
      () => exercises.insert(
        muscleGroupId: any(named: 'muscleGroupId'),
        nameEn: any(named: 'nameEn'),
        isCustom: any(named: 'isCustom'),
      ),
    );
  });

  test('throws when the muscle group is not on the workout', () async {
    await expectLater(
      useCase.call(
        workoutId: 1,
        name: 'Goblet squat',
        muscleGroupId: quadricepsId,
      ),
      throwsA(isA<MuscleGroupNotOnWorkout>()),
    );
    verifyNever(
      () => exercises.findByNameInGroup(
        muscleGroupId: any(named: 'muscleGroupId'),
        name: any(named: 'name'),
      ),
    );
    verifyNever(
      () => exercises.insert(
        muscleGroupId: any(named: 'muscleGroupId'),
        nameEn: any(named: 'nameEn'),
        isCustom: any(named: 'isCustom'),
      ),
    );
  });

  test('throws when the workout is not in progress', () async {
    when(
      () => workouts.findById(1),
    ).thenAnswer((_) async => workoutSession(status: WorkoutStatus.completed));

    await expectLater(
      useCase.call(workoutId: 1, name: 'Close grip', muscleGroupId: chestId),
      throwsA(isA<WorkoutNotInProgress>()),
    );
    verifyNever(
      () => exercises.insert(
        muscleGroupId: any(named: 'muscleGroupId'),
        nameEn: any(named: 'nameEn'),
        isCustom: any(named: 'isCustom'),
      ),
    );
  });

  test('throws when the workout does not exist', () async {
    when(() => workouts.findById(1)).thenAnswer((_) async => null);

    await expectLater(
      useCase.call(workoutId: 1, name: 'Close grip', muscleGroupId: chestId),
      throwsA(isA<WorkoutNotFound>()),
    );
    verifyNever(
      () => exercises.insert(
        muscleGroupId: any(named: 'muscleGroupId'),
        nameEn: any(named: 'nameEn'),
        isCustom: any(named: 'isCustom'),
      ),
    );
  });
}
