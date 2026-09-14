import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/markup/markup.dart';
import 'package:furlovin/settings/settings.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:furlovin/submission/submission.dart';
import 'package:furlovin/theme/theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:share_plus/share_plus.dart';

bool get platformShares => switch (defaultTargetPlatform) {
  TargetPlatform.android || TargetPlatform.iOS || TargetPlatform.macOS => true,
  _ => false,
};

enum SubmissionAction { copy, browser }

class SubmissionActions extends ConsumerStatefulWidget {
  const SubmissionActions({super.key, required this.id, this.submission});

  final int id;
  final Submission? submission;

  @override
  ConsumerState<SubmissionActions> createState() => _SubmissionActionsState();
}

class _SubmissionActionsState extends ConsumerState<SubmissionActions> {
  int get id => widget.id;

  Submission? get submission => widget.submission;

  String? get favouriteLink => submission?.favouriteLink;

  bool get favourited => submission?.favourited ?? false;

  Future<void> _toggle() async {
    unawaited(HapticFeedback.lightImpact());
    try {
      await ref
          .read(submissionProvider(id).notifier)
          .setFavourited(!favourited);
    } on Object catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(describeFailure(error)),
        ),
      );
    }
  }

  String get link => Uri.parse(faOrigin).resolve('/view/$id/').toString();

  Future<void> _share(BuildContext context) async {
    if (!platformShares) return _copy(context);
    try {
      await SharePlus.instance.share(
        ShareParams(uri: Uri.parse(link), title: submission?.title),
      );
    } on Object {
      if (context.mounted) await _copy(context);
    }
  }

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: link));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Link copied'),
      ),
    );
  }

  bool _downloading = false;

  void _say(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(behavior: SnackBarBehavior.floating, content: Text(message)),
    );
  }

  Future<void> _download(String file) async {
    final CacheManager artwork = ref.read(artworkCacheProvider);
    final PreferenceStore store = ref.read(preferenceStoreProvider);
    final String? folder = ref.read(downloadFolderProvider);
    final String discriminator =
        ref.read(sessionProvider).asData?.value.discriminator ??
        const Session().discriminator;
    try {
      final DownloadTarget target = await Downloads.target(
        chosen: folder,
        onChosen: (value) => store.put(downloadFolderKey, value),
      );
      if (!mounted) return;
      setState(() => _downloading = true);
      final File local = await artwork.getSingleFile(
        file,
        key: '$file#$discriminator',
      );
      final String saved = await Downloads.write(
        file: local,
        name: Uri.parse(file).pathSegments.last,
        target: target,
      );
      _say('Saved to $saved');
    } on DownloadCancelled {
      return;
    } on Object catch (error) {
      _say(describeFailure(error));
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool authenticated = ref.watch(authenticatedProvider);
    ref.watch(downloadFolderProvider);
    final String? file = submission?.file;
    final double gutter = Layout.gutterOf(context);
    final Hand handedness = ref.watch(handProvider);
    final List<Widget> toolbar = [
      Material(
        color: theme.colorScheme.surfaceContainerLowest,
        elevation: floatingElevation(theme),
        shadowColor: Colors.black,
        borderRadius: Corner.toolbar,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.tight),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              PopupMenuButton<SubmissionAction>(
                tooltip: 'More',
                position: PopupMenuPosition.over,
                useRootNavigator: true,
                icon: Icon(
                  Icons.more_horiz,
                  color: theme.colorScheme.onSurface,
                ),
                onSelected: (action) => switch (action) {
                  SubmissionAction.copy => _copy(context),
                  SubmissionAction.browser => hand(link),
                },
                itemBuilder: (context) => [
                  if (platformShares)
                    const PopupMenuItem<SubmissionAction>(
                      value: SubmissionAction.copy,
                      child: ListTile(
                        leading: Icon(Icons.link),
                        title: Text('Copy link'),
                      ),
                    ),
                  const PopupMenuItem<SubmissionAction>(
                    value: SubmissionAction.browser,
                    child: ListTile(
                      leading: Icon(Icons.open_in_browser),
                      title: Text('Open in browser'),
                    ),
                  ),
                ],
              ),
              IconButton(
                tooltip: platformShares ? 'Share' : 'Copy link',
                onPressed: () => _share(context),
                icon: Icon(platformShares ? Icons.share_outlined : Icons.link),
              ),
              IconButton(
                tooltip: 'Download',
                onPressed: file == null || _downloading || !platformDownloads
                    ? null
                    : () => _download(file),
                icon: _downloading
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.download_outlined),
              ),
            ].forHand(handedness),
          ),
        ),
      ),
      if (authenticated) ...[
        const SizedBox(width: Space.snug),
        FloatingActionButton(
          heroTag: null,
          tooltip: favourited ? 'Remove from favourites' : 'Favourite',
          elevation: floatingElevation(theme),
          backgroundColor: theme.colorScheme.surfaceContainerLowest,
          foregroundColor: favourited
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurfaceVariant,
          onPressed: favouriteLink == null ? null : _toggle,
          child: Icon(favourited ? Icons.favorite : Icons.favorite_border),
        ),
      ],
    ];
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(gutter, 0, gutter, Space.snug),
        child: Row(
          mainAxisAlignment: switch (handedness) {
            Hand.left => MainAxisAlignment.start,
            Hand.right => MainAxisAlignment.end,
          },
          children: toolbar.forHand(handedness),
        ),
      ),
    );
  }
}
