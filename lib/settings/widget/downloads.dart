import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/settings/settings.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:material_ui/material_ui.dart';

class DownloadSettings extends ConsumerWidget {
  const DownloadSettings({super.key});

  Future<void> _change(WidgetRef ref, String? folder) async {
    final PreferenceStore store = ref.read(preferenceStoreProvider);
    final String? picked = await Downloads.pickFolder(initial: folder);
    if (picked != null) await store.put(downloadFolderKey, picked);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final String? folder = ref.watch(downloadFolderProvider);
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
            subtitle: Text(switch (folder) {
              final String value => folderLabel(value),
              null when shares =>
                'Pictures, Music or Download, in a $sharedMediaFolder folder',
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
                if (folder != null)
                  TextButton(
                    onPressed: () => store.put(downloadFolderKey, ''),
                    child: const Text('Use default'),
                  ),
                TextButton(
                  onPressed: () => _change(ref, folder),
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
