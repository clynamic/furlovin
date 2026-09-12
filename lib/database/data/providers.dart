import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/database/database.dart';

final Provider<AppDatabase> databaseProvider = Provider<AppDatabase>((ref) {
  final AppDatabase database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});
