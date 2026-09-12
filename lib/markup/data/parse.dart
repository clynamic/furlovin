import 'package:furlovin/client/client.dart';
import 'package:furlovin/markup/markup.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html;
import 'package:material_ui/material_ui.dart' show Color;

final RegExp _spaces = RegExp(r'\s+');
final RegExp _colour = RegExp(r'color\s*:\s*([^;]+)', caseSensitive: false);
final RegExp _hex = RegExp(
  r'^#([0-9a-f]{3}|[0-9a-f]{6})$',
  caseSensitive: false,
);
final RegExp _rgb = RegExp(r'^rgba?\(([^)]*)\)$', caseSensitive: false);

List<MarkupBlock> parseMarkup(String markup) {
  final MarkupReader reader = MarkupReader();
  reader.children(html.parseFragment(markup), const MarkupStyle());
  return reader.finish();
}

Color? readColour(String? declaration) {
  if (declaration == null) return null;
  final RegExpMatch? found = _colour.firstMatch(declaration);
  if (found == null) return null;
  final String value = found.group(1)!.trim().toLowerCase();
  if (_hex.firstMatch(value) case final RegExpMatch match) {
    String digits = match.group(1)!;
    if (digits.length == 3) {
      digits = digits.split('').map((e) => '$e$e').join();
    }
    return Color(int.parse('ff$digits', radix: 16));
  }
  if (_rgb.firstMatch(value) case final RegExpMatch match) {
    final List<int> parts = match
        .group(1)!
        .split(',')
        .map((e) => int.tryParse(e.trim()) ?? -1)
        .toList();
    if (parts.length < 3 || parts.any((e) => e < 0 || e > 255)) return null;
    return Color.fromARGB(255, parts[0], parts[1], parts[2]);
  }
  return null;
}

class MarkupReader {
  final List<MarkupBlock> _blocks = [];
  List<MarkupSpan> _spans = [];
  MarkupAlign _align = MarkupAlign.start;

  List<MarkupBlock> finish() {
    _flush();
    return _blocks;
  }

  void children(dom.Node parent, MarkupStyle style) {
    for (final dom.Node node in parent.nodes) {
      visit(node, style);
    }
  }

  void visit(dom.Node node, MarkupStyle style) {
    if (node is dom.Text) return _text(node, style);
    if (node is! dom.Element) return;
    switch (roleOf(node)) {
      case BreakRole():
        _add(const MarkupBreak());
      case RuleRole():
        _flush();
        _blocks.add(const MarkupRule());
      case EmoteRole(:final String name):
        _add(MarkupEmote(name));
      case TextRole(:final String text):
        _add(MarkupText(text, style: style));
      case SkipRole():
        break;
      case MentionRole(
        :final String name,
        :final String? display,
        :final String? avatar,
      ):
        _add(
          MarkupMention(
            name: name,
            display: display,
            avatar: avatar == null
                ? null
                : Uri.parse(faOrigin).resolve(avatar).toString(),
          ),
        );
      case LinkRole(:final String href):
        _link(node, href, style);
      case ContentRole(:final bool block, :final MarkupAlign? align):
        if (block) _flush();
        if (align != null) _align = align;
        children(node, styleOf(node, style));
        if (block) _flush();
    }
  }

  void _text(dom.Text node, MarkupStyle style) {
    final String value = node.text.replaceAll(_spaces, ' ');
    if (value.trim().isEmpty && _spans.isEmpty) return;
    _add(MarkupText(value, style: style));
  }

  void _link(dom.Element node, String href, MarkupStyle style) {
    final MarkupReader inner = MarkupReader()..children(node, style);
    if (inner._spans.isEmpty) return;
    _add(MarkupLink(href: href, spans: inner._spans));
  }

  void _add(MarkupSpan span) {
    if (span is MarkupText && span.text.isEmpty) return;
    if (span is MarkupBreak && _spans.isEmpty) return;
    _spans.add(span);
  }

  void _flush() {
    while (_spans.isNotEmpty && _spans.last is MarkupBreak) {
      _spans.removeLast();
    }
    if (_spans.isNotEmpty) _blocks.add(MarkupParagraph(_spans, align: _align));
    _spans = [];
    _align = MarkupAlign.start;
  }
}
