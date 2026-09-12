import 'package:furlovin/database/database.dart';

class PreferenceStore {
  const PreferenceStore(this.database);

  final AppDatabase database;

  Stream<Map<String, String>> watch() => database
      .select(database.preferences)
      .watch()
      .map((rows) => {for (final Preference row in rows) row.name: row.value});

  Future<void> put(String name, String value) => database
      .into(database.preferences)
      .insertOnConflictUpdate(
        PreferencesCompanion.insert(name: name, value: value),
      );
}
