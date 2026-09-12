import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:material_ui/material_ui.dart';

class SubmissionViewer extends ConsumerStatefulWidget {
  const SubmissionViewer({super.key, required this.rungs, required this.tag});

  final List<ImageRung> rungs;
  final Object tag;

  static Route<void> route({
    required List<ImageRung> rungs,
    required Object tag,
  }) => DismissRoute<void>(
    barrier: Colors.black,
    transition: DismissTransition.fade,
    builder: (context) => SubmissionViewer(rungs: rungs, tag: tag),
  );

  @override
  ConsumerState<SubmissionViewer> createState() => _SubmissionViewerState();
}

class _SubmissionViewerState extends ConsumerState<SubmissionViewer> {
  late final DismissController dismiss = DismissController(
    DismissRoute.of(context),
  );
  final ZoomController zoom = ZoomController();
  double? _ratio;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Session session = ref
        .watch(sessionProvider)
        .maybeWhen(data: (e) => e, orElse: () => const Session());

    return Scaffold(
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
                child: Hero(
                  tag: widget.tag,
                  child: ProgressiveImage(
                    rungs: widget.rungs,
                    headers: session.headersFor,
                    discriminator: session.discriminator,
                    onRatio: _onRatio,
                  ),
                ),
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
    );
  }
}

void openViewer(
  BuildContext context, {
  required List<ImageRung> rungs,
  required Object tag,
}) {
  if (rungs.isEmpty) return;
  Navigator.of(context).push(SubmissionViewer.route(rungs: rungs, tag: tag));
}
