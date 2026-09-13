import 'package:flutter/foundation.dart';
import 'package:furlovin/routing/routing.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:furlovin/submission/submission.dart';
import 'package:material_ui/material_ui.dart';

extension GallerySourceRouting on BuildContext {
  void openSource(GallerySource source, {bool replace = false}) =>
      switch (source.shelf) {
        GalleryShelf.main => openGallery(source.user, replace: replace),
        GalleryShelf.scraps => openScraps(source.user, replace: replace),
        GalleryShelf.folder => openFolder(
          source.user,
          source.folder!,
          source.slug!,
          replace: replace,
        ),
      };
}

extension FolderSource on Folder {
  GallerySource get source => GallerySource.folder(user, id, slug);

  String labelAmong(List<Folder> folders) {
    final bool shared = folders.any((e) => e.id != id && e.name == name);
    return shared && group != null ? '$name ($group)' : name;
  }
}

class GalleryShelves extends StatelessWidget {
  const GalleryShelves({
    super.key,
    required this.source,
    required this.folders,
  });

  final GallerySource source;
  final ValueListenable<List<Folder>?> folders;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<List<Folder>?>(
    valueListenable: folders,
    builder: (context, known, child) {
      final ThemeData theme = Theme.of(context);
      final List<Folder> all = known ?? const [];
      final int open = all.indexWhere(source.holds);
      void go(GallerySource next) {
        if (next != source) context.openSource(next, replace: true);
      }

      return Padding(
        padding: const EdgeInsets.fromLTRB(
          Space.medium,
          0,
          Space.medium,
          Space.small,
        ),
        child: PriorityRow(
          spacing: Space.small,
          pinned: {
            switch (source.shelf) {
              GalleryShelf.main => 0,
              GalleryShelf.scraps => 1,
              GalleryShelf.folder => open < 0 ? -1 : open + 2,
            },
          },
          overflow: ActionChip(
            avatar: const Icon(Icons.folder_outlined),
            label: const Text('All folders'),
            onPressed: () async {
              final GallerySource? picked = await showDialog<GallerySource>(
                context: context,
                builder: (context) =>
                    FolderPicker(source: source, folders: all),
              );
              if (picked != null) go(picked);
            },
          ),
          children: [
            ChoiceChip(
              showCheckmark: false,
              label: const Text('Main Gallery'),
              selected: source.shelf == GalleryShelf.main,
              onSelected: (value) => go(GallerySource.main(source.user)),
            ),
            ChoiceChip(
              showCheckmark: false,
              label: const Text('Scraps'),
              selected: source.shelf == GalleryShelf.scraps,
              onSelected: (value) => go(GallerySource.scraps(source.user)),
            ),
            for (final Folder folder in all)
              ChoiceChip(
                showCheckmark: false,
                label: Text.rich(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  TextSpan(
                    text: folder.labelAmong(all),
                    children: [
                      if (folder.count case final int count)
                        TextSpan(
                          text: '  $count',
                          style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
                selected: source.holds(folder),
                onSelected: (value) => go(folder.source),
              ),
          ],
        ),
      );
    },
  );
}

class FolderPicker extends StatelessWidget {
  const FolderPicker({super.key, required this.source, required this.folders});

  final GallerySource source;
  final List<Folder> folders;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    Widget row(String label, GallerySource target, {int? count}) => ListTile(
      title: Text(label),
      trailing: count == null ? null : Text('$count'),
      selected: target == source,
      shape: const RoundedRectangleBorder(borderRadius: Corner.panels),
      onTap: () => Navigator.of(context).pop(target),
    );

    final List<Widget> rows = [
      row('Main Gallery', GallerySource.main(source.user)),
      row('Scraps', GallerySource.scraps(source.user)),
    ];
    String? heading;
    for (final Folder folder in folders) {
      if (folder.group != heading) {
        heading = folder.group;
        rows.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Space.medium,
              Space.medium,
              Space.medium,
              Space.tight,
            ),
            child: Text(
              heading ?? 'Other folders',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        );
      }
      rows.add(row(folder.name, folder.source, count: folder.count));
    }

    return AlertDialog(
      title: const Text('Folders'),
      contentPadding: const EdgeInsets.symmetric(vertical: Space.small),
      content: SizedBox(
        width: 360,
        child: ListView(shrinkWrap: true, children: rows),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
