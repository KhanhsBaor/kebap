// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_dao.dart';

// ignore_for_file: type=lint
mixin _$CatalogDaoMixin on DatabaseAccessor<AppDatabase> {
  $RegionsTable get regions => attachedDatabase.regions;
  $MuscleGroupsTable get muscleGroups => attachedDatabase.muscleGroups;
  $ExercisesTable get exercises => attachedDatabase.exercises;
  CatalogDaoManager get managers => CatalogDaoManager(this);
}

class CatalogDaoManager {
  final _$CatalogDaoMixin _db;
  CatalogDaoManager(this._db);
  $$RegionsTableTableManager get regions =>
      $$RegionsTableTableManager(_db.attachedDatabase, _db.regions);
  $$MuscleGroupsTableTableManager get muscleGroups =>
      $$MuscleGroupsTableTableManager(_db.attachedDatabase, _db.muscleGroups);
  $$ExercisesTableTableManager get exercises =>
      $$ExercisesTableTableManager(_db.attachedDatabase, _db.exercises);
}
