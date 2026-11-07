import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/markup/markup.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:furlovin/submission/submission.dart';
import 'package:material_ui/material_ui.dart';

const double noticeHeaderHeight = 380;
const double noticeThumbnailExtent = 160;

class SubmissionNotice extends ConsumerStatefulWidget {
  const SubmissionNotice({
    super.key,
    required this.id,
    required this.type,
    required this.rungs,
    required this.session,
    this.submission,
  });

  final int id;
  final SubmissionType? type;
  final List<ImageRung> rungs;
  final Session session;
  final Submission? submission;

  @override
  ConsumerState<SubmissionNotice> createState() => _SubmissionNoticeState();
}

class _SubmissionNoticeState extends ConsumerState<SubmissionNotice>
    with SubmissionDownloader {
  final ImageLoadController load = ImageLoadController();

  Submission? get submission => widget.submission;

  @override
  void dispose() {
    load.dispose();
    super.dispose();
  }

  String get _message => switch (widget.type) {
    SubmissionType.text => 'Stories open in your browser',
    SubmissionType.audio => 'Music plays in your browser',
    _ => 'Flash opens in your browser',
  };

  IconData get _icon => switch (widget.type) {
    SubmissionType.text => Icons.auto_stories_outlined,
    SubmissionType.audio => Icons.music_note_outlined,
    _ => Icons.animation,
  };

  List<String> get _format => [
    ?submission?.extension?.toUpperCase(),
    ?submission?.fileSize,
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String? file = submission?.file;
    final Widget icon = Icon(
      _icon,
      size: 64,
      color: theme.colorScheme.onSurfaceVariant,
    );
    return Stack(
      fit: StackFit.expand,
      children: [
        DismissFade(
          child: ColoredBox(color: theme.colorScheme.surfaceContainer),
        ),
        DismissFade(
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                Space.page,
                kToolbarHeight,
                Space.page,
                Space.page,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox.square(
                    dimension: noticeThumbnailExtent,
                    child: widget.rungs.isEmpty
                        ? icon
                        : ValueListenableBuilder<ImageLoad>(
                            valueListenable: load,
                            builder: (context, value, child) => Stack(
                              alignment: Alignment.center,
                              children: [
                                if (value is! ImageLoaded) icon,
                                ?child,
                              ],
                            ),
                            child: ProgressiveImage(
                              rungs: widget.rungs,
                              headers: widget.session.headersFor,
                              discriminator: widget.session.discriminator,
                              fit: BoxFit.scaleDown,
                              background: Colors.transparent,
                              load: load,
                            ),
                          ),
                  ),
                  const SizedBox(height: Space.medium),
                  Text(
                    _message,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium,
                  ),
                  if (_format.isNotEmpty)
                    Text(
                      _format.join(' · '),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  const SizedBox(height: Space.medium),
                  OverflowBar(
                    alignment: MainAxisAlignment.center,
                    spacing: Space.small,
                    overflowSpacing: Space.small,
                    overflowAlignment: OverflowBarAlignment.center,
                    children: [
                      if (platformDownloads)
                        FilledButton.tonalIcon(
                          onPressed: file == null || downloading
                              ? null
                              : () => download(file),
                          icon: const Icon(Icons.download_outlined),
                          label: const Text('Download'),
                        ),
                      FilledButton.tonalIcon(
                        onPressed: () => hand(submissionLink(widget.id)),
                        icon: const Icon(Icons.open_in_browser),
                        label: const Text('Open in browser'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
