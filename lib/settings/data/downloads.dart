import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/settings/settings.dart';
import 'package:furlovin/shared/shared.dart';

const String downloadDirectoryKey = 'downloads.directory';

final Provider<String?> downloadDirectoryProvider = Provider<String?>((ref) {
  final String? directory = ref
      .watch(preferencesProvider)
      .value?[downloadDirectoryKey];
  return directory == null || directory.isEmpty ? null : directory;
});

final FutureProvider<bool> sharesMediaProvider = FutureProvider<bool>(
  (ref) => Downloads.sharesMedia(),
);
