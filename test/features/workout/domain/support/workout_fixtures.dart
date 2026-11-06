import 'package:kebap/features/catalog/domain/entities/exercise.dart';
import 'package:kebap/features/catalog/domain/entities/muscle_group.dart';
import 'package:kebap/features/workout/domain/entities/session_exercise.dart';
import 'package:kebap/features/workout/domain/entities/set_log.dart';
import 'package:kebap/features/workout/domain/entities/workout_session.dart';
import 'package:kebap/features/workout/domain/entities/workout_status.dart';

const upperRegionId = 1;
const lowerRegionId = 2;
const chestId = 10;
const tricepsId = 11;
const quadricepsId = 20;
const benchId = 50;
const squatId = 51;

final fixtureStartedAt = DateTime.utc(2026, 11, 6, 8);
final fixtureEndedAt = DateTime.utc(2026, 11, 6, 9);

final chestGroup = MuscleGroup(
  id: chestId,
  regionId: upperRegionId,
  slug: 'chest',
  nameEn: 'Chest',
);

final tricepsGroup = MuscleGroup(
  id: tricepsId,
  regionId: upperRegionId,
  slug: 'triceps',
  nameEn: 'Triceps',
);

final quadricepsGroup = MuscleGroup(
  id: quadricepsId,
  regionId: lowerRegionId,
  slug: 'quadriceps',
  nameEn: 'Quadriceps',
);

Exercise catalogExercise({
  int id = benchId,
  int muscleGroupId = chestId,
  String nameEn = 'Bench Press',
  String? nameVi,
  bool isCustom = false,
}) {
  return Exercise(
    id: id,
    muscleGroupId: muscleGroupId,
    nameEn: nameEn,
    nameVi: nameVi,
    isCustom: isCustom,
  );
}

SetLog setLog({
  required int id,
  int sessionExerciseId = 100,
  required int position,
  bool isWarmup = false,
  double? kg = 60,
  int? reps = 10,
}) {
  return SetLog(
    id: id,
    sessionExerciseId: sessionExerciseId,
    position: position,
    isWarmup: isWarmup,
    kg: kg,
    reps: reps,
  );
}

SessionExercise sessionExercise({
  int id = 100,
  int exerciseId = benchId,
  int position = 1,
  List<SetLog> sets = const [],
}) {
  return SessionExercise(
    id: id,
    exerciseId: exerciseId,
    position: position,
    sets: sets,
  );
}

WorkoutSession workoutSession({
  int id = 1,
  WorkoutStatus status = WorkoutStatus.inProgress,
  DateTime? startedAt,
  DateTime? endedAt,
  List<int> muscleGroupIds = const [chestId, tricepsId],
  List<SessionExercise> exercises = const [],
}) {
  return WorkoutSession(
    id: id,
    status: status,
    startedAt: startedAt ?? fixtureStartedAt,
    endedAt: endedAt,
    muscleGroupIds: muscleGroupIds,
    exercises: exercises,
  );
}
