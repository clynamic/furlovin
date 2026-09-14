import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:furlovin/submission/submission.dart';
import 'package:material_ui/material_ui.dart';

class SubmissionViewer extends ConsumerStatefulWidget {
  const SubmissionViewer({
    super.key,
    required this.id,
    required this.tag,
    this.preview,
    this.aspectRatio,
  });

  final int id;
  final SubmissionPreview? preview;
  final Object tag;
  final double? aspectRatio;

  static Route<void> route({
    required int id,
    required Object tag,
    SubmissionPreview? preview,
    double? aspectRatio,
  }) => DismissRoute<void>(
    barrier: Colors.black,
    transition: DismissTransition.fade,
    builder: (context) => SubmissionViewer(
      id: id,
      tag: tag,
      preview: preview,
      aspectRatio: aspectRatio,
    ),
  );

  @override
  ConsumerState<SubmissionViewer> createState() => _SubmissionViewerState();
}

class _SubmissionViewerState extends ConsumerState<SubmissionViewer>
    with BottomClaimant {
  late final DismissController dismiss = DismissController(
    DismissRoute.of(context),
  );
  final ZoomController zoom = ZoomController();
  final ImageLoadController load = ImageLoadController();
  late double? _ratio = widget.aspectRatio;

  void _onRatio(double ratio) {
    if (_ratio == ratio) return;
    _ratio = ratio;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    zoom.dispose();
    load.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Session session = ref
        .watch(sessionProvider)
        .maybeWhen(data: (e) => e, orElse: () => const Session());
    final List<ImageRung> rungs = submissionRungs(
      context,
      preview: widget.preview,
      loaded: ref.watch(submissionProvider(widget.id)).asData?.value.submission,
      thumbnails: ref.watch(thumbnailCacheProvider),
      artwork: ref.watch(artworkCacheProvider),
    );

    return ClaimedBottom(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned.fill(
              child: DismissTransform(
                controller: dismiss,
                child: Zoomable(
                  controller: zoom,
                  aspectRatio: _ratio,
                  onTap: () => Navigator.of(context).maybePop(),
                  onSpare: (spare) => dismiss.push(spare.dy),
                  onSpareEnd: (velocity) {
                    if (dismiss.release(velocity.pixelsPerSecond.dy)) {
                      Navigator.of(context).maybePop();
                    }
                  },
                  child: ContentHero(
                    tag: widget.tag,
                    content: FittedContent(
                      fit: BoxFit.contain,
                      aspectRatio: _ratio,
                    ),
                    child: ProgressiveImage(
                      rungs: rungs,
                      headers: session.headersFor,
                      discriminator: session.discriminator,
                      onRatio: _onRatio,
                      load: load,
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: DismissFade(
                controller: dismiss,
                child: ImageLoadOverlay(
                  load: load,
                  moves: zoom.transformation,
                  locate: (size) => switch (containedRect(_ratio, size)) {
                    final Rect content => MatrixUtils.transformRect(
                      zoom.transformation.value,
                      content,
                    ),
                    null => null,
                  },
                ),
              ),
            ),
            DismissFade(
              controller: dismiss,
              child: SafeArea(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: IconButton(
                      tooltip: MaterialLocalizations.of(context)
                          .closeButtonTooltip,
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        shadows: [Shadow(color: scrimShadow, blurRadius: 10)],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void openViewer(
  BuildContext context, {
  required int id,
  required Object tag,
  SubmissionPreview? preview,
  double? aspectRatio,
}) => Navigator.of(context).push(
  SubmissionViewer.route(
    id: id,
    tag: tag,
    preview: preview,
    aspectRatio: aspectRatio,
  ),
);
