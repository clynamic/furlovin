import 'package:html/parser.dart' as html;

String stripMarkup(String markup) {
  final String text = html.parseFragment(markup).text ?? '';
  return text.replaceAll(RegExp(r'\n{3,}'), '\n\n').trim();
}
