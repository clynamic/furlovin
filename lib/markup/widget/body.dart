import 'package:furlovin/logs/logs.dart';
import 'package:furlovin/markup/markup.dart';
import 'package:furlovin/routing/routing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class MarkupBody extends StatefulWidget {
  const MarkupBody({super.key, required this.markup, this.style});

  final String markup;
  final TextStyle? style;

  @override
  State<MarkupBody> createState() => _MarkupBodyState();
}

class _MarkupBodyState extends State<MarkupBody> {
  late List<MarkupBlock> _blocks = parseMarkup(widget.markup);

  @override
  void didUpdateWidget(MarkupBody old) {
    super.didUpdateWidget(old);
    if (old.markup != widget.markup) _blocks = parseMarkup(widget.markup);
  }

  @override
  Widget build(BuildContext context) => Markup(
    blocks: _blocks,
    style: widget.style,
    onOpen: (href) => openTarget(context, readTarget(href)),
  );
}

final Logger markupLogger = Logger('Markup');

Future<void> openTarget(
  BuildContext context,
  MarkupTarget target, {
  Future<void> Function(String url) elsewhere = hand,
}) async {
  switch (target) {
    case SubmissionTarget(:final int id):
      markupLogger.debug('Opening submission {id}', {'id': id});
      context.openSubmission(id);
    case SearchTarget(:final String text):
      context.openSearchText(text);
    case UserTarget(:final String name):
      context.openUser(name);
    case GalleryTarget(:final String name):
      context.openGallery(name);
    case ScrapsTarget(:final String name):
      context.openScraps(name);
    case FolderTarget(:final String name, :final int id, :final String slug):
      context.openFolder(name, id, slug);
    case FavoritesTarget(:final String name):
      context.openFavorites(name);
    case ElsewhereTarget(:final String url):
      await elsewhere(url);
  }
}

Future<void> hand(String url) async {
  final Logger scope = markupLogger.child({'url': url});
  scope.debug('Handing {url} to the system');
  try {
    final bool opened = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (!opened) scope.warn('The system refused {url}');
  } on Object catch (error) {
    scope.error('Could not open {url}', const {}, error);
  }
}
