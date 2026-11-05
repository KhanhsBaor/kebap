import 'package:kebap/core/db/app_database.dart';
import 'package:kebap/core/db/connection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_database_provider.g.dart';

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final database = AppDatabase(openConnection());
  ref.onDispose(database.close);
  return database;
}
