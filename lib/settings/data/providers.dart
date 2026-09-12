import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/database/database.dart';
import 'package:furlovin/settings/settings.dart';

final Provider<PreferenceStore> preferenceStoreProvider =
    Provider<PreferenceStore>(
      (ref) => PreferenceStore(ref.watch(databaseProvider)),
    );

final StreamProvider<Map<String, String>> preferencesProvider =
    StreamProvider<Map<String, String>>(
      (ref) => ref.watch(preferenceStoreProvider).watch(),
    );
