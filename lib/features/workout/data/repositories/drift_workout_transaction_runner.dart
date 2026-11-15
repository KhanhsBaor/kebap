import 'package:kebap/core/db/app_database.dart';
import 'package:kebap/features/workout/domain/repositories/workout_transaction_runner.dart';

class DriftWorkoutTransactionRunner implements WorkoutTransactionRunner {
  DriftWorkoutTransactionRunner(this._database);

  final AppDatabase _database;

  @override
  Future<T> run<T>(Future<T> Function() action) {
    return _database.transaction(action);
  }
}
