import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/markup/markup.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:furlovin/submission/submission.dart';
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

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool authenticated = ref.watch(authenticatedProvider);
    final double gutter = Layout.gutterOf(context);
    final bool wide = MediaQuery.sizeOf(context).width >= Layout.compact;
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(gutter, 0, gutter, Space.snug),
        child: Row(
          mainAxisAlignment: wide
              ? MainAxisAlignment.end
              : MainAxisAlignment.center,
          children: [
            Material(
              color: theme.colorScheme.surfaceContainerLowest,
              elevation: 3,
              shadowColor: Colors.black,
              borderRadius: Corner.toolbar,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Space.tight),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                      icon: Icon(
                        platformShares ? Icons.share_outlined : Icons.link,
                      ),
                    ),
                    const IconButton(
                      tooltip: 'Download',
                      onPressed: null,
                      icon: Icon(Icons.download_outlined),
                    ),
                  ],
                ),
              ),
            ),
            if (authenticated) ...[
              const SizedBox(width: Space.snug),
              FloatingActionButton(
                heroTag: null,
                tooltip: favourited ? 'Remove from favourites' : 'Favourite',
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                foregroundColor: favourited
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
                onPressed: favouriteLink == null ? null : _toggle,
                child: Icon(
                  favourited ? Icons.favorite : Icons.favorite_border,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
