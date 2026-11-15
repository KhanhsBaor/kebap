/// Runs several repository writes as one unit of work.
///
/// The Drift implementation uses [AppDatabase.transaction], so nested
/// DAO calls join the same SQLite transaction through Dart zones.
abstract interface class WorkoutTransactionRunner {
  Future<T> run<T>(Future<T> Function() action);
}
