import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/settings/settings.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:material_ui/material_ui.dart';

class DownloadSettings extends ConsumerWidget {
  const DownloadSettings({super.key});

  Future<void> _change(WidgetRef ref, String? directory) async {
    final PreferenceStore store = ref.read(preferenceStoreProvider);
    final String? picked = await Downloads.pickDirectory(initial: directory);
    if (picked != null) await store.put(downloadDirectoryKey, picked);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final String? directory = ref.watch(downloadDirectoryProvider);
    final bool shares = ref.watch(sharesMediaProvider).value ?? false;
    final PreferenceStore store = ref.read(preferenceStoreProvider);
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            leading: Icon(
              Icons.folder_outlined,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            title: const Text('Save to'),
            subtitle: Text(switch (directory) {
              final String value => directoryLabel(value),
              null when shares =>
                'Pictures, Music or Download, in a $sharedMediaDirectory folder',
              null when defaultTargetPlatform == TargetPlatform.android =>
                'Asked on your first download',
              null => 'Your downloads folder',
            }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Space.small,
              0,
              Space.small,
              Space.small,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: Space.small,
              children: [
                if (directory != null)
                  TextButton(
                    onPressed: () => store.put(downloadDirectoryKey, ''),
                    child: const Text('Use default'),
                  ),
                TextButton(
                  onPressed: () => _change(ref, directory),
                  child: const Text('Choose a folder'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
