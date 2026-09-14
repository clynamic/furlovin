import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/settings/settings.dart';
import 'package:furlovin/shared/shared.dart';

const String downloadFolderKey = 'downloads.folder';

final Provider<String?> downloadFolderProvider = Provider<String?>((ref) {
  final String? folder = ref
      .watch(preferencesProvider)
      .value?[downloadFolderKey];
  return folder == null || folder.isEmpty ? null : folder;
});

final FutureProvider<bool> sharesMediaProvider = FutureProvider<bool>(
  (ref) => Downloads.sharesMedia(),
);
