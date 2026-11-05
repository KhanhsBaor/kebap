// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_dao.dart';

// ignore_for_file: type=lint
mixin _$WorkoutDaoMixin on DatabaseAccessor<AppDatabase> {
  $WorkoutsTable get workouts => attachedDatabase.workouts;
  $RegionsTable get regions => attachedDatabase.regions;
  $MuscleGroupsTable get muscleGroups => attachedDatabase.muscleGroups;
  $WorkoutMuscleGroupsTable get workoutMuscleGroups =>
      attachedDatabase.workoutMuscleGroups;
  $ExercisesTable get exercises => attachedDatabase.exercises;
  $WorkoutExercisesTable get workoutExercises =>
      attachedDatabase.workoutExercises;
  $WorkoutSetsTable get workoutSets => attachedDatabase.workoutSets;
  WorkoutDaoManager get managers => WorkoutDaoManager(this);
}

class WorkoutDaoManager {
  final _$WorkoutDaoMixin _db;
  WorkoutDaoManager(this._db);
  $$WorkoutsTableTableManager get workouts =>
      $$WorkoutsTableTableManager(_db.attachedDatabase, _db.workouts);
  $$RegionsTableTableManager get regions =>
      $$RegionsTableTableManager(_db.attachedDatabase, _db.regions);
  $$MuscleGroupsTableTableManager get muscleGroups =>
      $$MuscleGroupsTableTableManager(_db.attachedDatabase, _db.muscleGroups);
  $$WorkoutMuscleGroupsTableTableManager get workoutMuscleGroups =>
      $$WorkoutMuscleGroupsTableTableManager(
        _db.attachedDatabase,
        _db.workoutMuscleGroups,
      );
  $$ExercisesTableTableManager get exercises =>
      $$ExercisesTableTableManager(_db.attachedDatabase, _db.exercises);
  $$WorkoutExercisesTableTableManager get workoutExercises =>
      $$WorkoutExercisesTableTableManager(
        _db.attachedDatabase,
        _db.workoutExercises,
      );
  $$WorkoutSetsTableTableManager get workoutSets =>
      $$WorkoutSetsTableTableManager(_db.attachedDatabase, _db.workoutSets);
}
