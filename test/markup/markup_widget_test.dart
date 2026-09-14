import 'package:flutter/rendering.dart' show SemanticsNode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/markup/markup.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  Future<void> show(
    WidgetTester tester,
    String markup,
    void Function(String href) onOpen,
  ) => tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          body: Markup(blocks: parseMarkup(markup), onOpen: onOpen),
        ),
      ),
    ),
  );

  testWidgets('a tap on link text reports the href', (tester) async {
    final List<String> opened = [];
    await show(
      tester,
      'see <a class="auto_link" href="/view/123/">this one</a> now',
      opened.add,
    );

    await tester.tapOnText(find.textRange.ofSubstring('this one'));
    await tester.pump();

    expect(opened, ['/view/123/']);
  });

  testWidgets('a tap outside the link reports nothing', (tester) async {
    final List<String> opened = [];
    await show(
      tester,
      'see <a class="auto_link" href="/view/123/">this one</a> now',
      opened.add,
    );

    await tester.tapOnText(find.textRange.ofSubstring('see '));
    await tester.pump();

    expect(opened, isEmpty);
  });

  testWidgets('links survive a rebuild', (tester) async {
    final List<String> opened = [];
    await show(tester, '<a href="/view/7/">go</a>', opened.add);
    await tester.pump();
    await show(tester, '<a href="/view/7/">go</a>', opened.add);

    await tester.tapOnText(find.textRange.ofSubstring('go'));
    await tester.pump();

    expect(opened, ['/view/7/']);
  });

  testWidgets('a heading is larger than the text after it', (tester) async {
    await show(
      tester,
      '<h1 class="bbcode bbcode_h1">Title</h1>body',
      (href) {},
    );

    double sizeOf(String text) {
      final RichText rich = tester.widget(
        find.byWidgetPredicate(
          (e) => e is RichText && e.text.toPlainText() == text,
        ),
      );
      double? size;
      rich.text.visitChildren((span) {
        if (span is TextSpan && span.text == text) {
          size = span.style?.fontSize;
          return false;
        }
        return true;
      });
      return size!;
    }

    expect(sizeOf('Title'), greaterThan(sizeOf('body')));
  });

  testWidgets('a quote shows who wrote it', (tester) async {
    await show(
      tester,
      '<span class="bbcode bbcode_quote"><span class="bbcode_quote_name">Fender wrote:</span>Example text.</span>',
      (href) {},
    );

    expect(find.text('Fender'), findsOneWidget);
    expect(find.textContaining('Example text.', findRichText: true), findsOne);
  });

  TextStyle? styleOf(WidgetTester tester, String text) {
    TextStyle? found;
    for (final RichText rich in tester.widgetList<RichText>(
      find.byType(RichText),
    )) {
      rich.text.visitChildren((span) {
        if (span is TextSpan && span.text == text) {
          found = span.style;
          return false;
        }
        return true;
      });
    }
    return found;
  }

  testWidgets('a spoiler hides its text until tapped', (tester) async {
    await show(
      tester,
      '<span class="bbcode bbcode_spoiler">they win</span>',
      (href) {},
    );
    expect(styleOf(tester, 'they win')?.color, Colors.transparent);

    await tester.tapAt(
      tester.getTopLeft(find.byType(RichText)) + const Offset(8, 8),
    );
    await tester.pump();

    expect(styleOf(tester, 'they win')?.color, isNot(Colors.transparent));
  });

  testWidgets('tapping a revealed spoiler hides it again', (tester) async {
    await show(
      tester,
      '<span class="bbcode bbcode_spoiler">they win</span>',
      (href) {},
    );
    final Offset text =
        tester.getTopLeft(find.byType(RichText)) + const Offset(8, 8);

    await tester.tapAt(text);
    await tester.pump();
    expect(styleOf(tester, 'they win')?.color, isNot(Colors.transparent));

    await tester.tapAt(text);
    await tester.pump();
    expect(styleOf(tester, 'they win')?.color, Colors.transparent);
  });

  testWidgets('a link in a hidden spoiler reveals before it opens', (
    tester,
  ) async {
    final List<String> opened = [];
    await show(
      tester,
      '<span class="bbcode bbcode_spoiler"><a href="/view/9/">twist</a></span>',
      opened.add,
    );

    await tester.tapAt(
      tester.getTopLeft(find.byType(RichText)) + const Offset(8, 8),
    );
    await tester.pump();
    expect(opened, isEmpty);

    await tester.tapAt(
      tester.getTopLeft(find.byType(RichText)) + const Offset(8, 8),
    );
    await tester.pump();
    expect(opened, ['/view/9/']);

    await tester.tapAt(
      tester.getTopLeft(find.byType(RichText)) + const Offset(8, 8),
    );
    await tester.pump();
    expect(opened, ['/view/9/', '/view/9/']);
  });

  testWidgets('a hidden spoiler is announced rather than read out', (
    tester,
  ) async {
    final SemanticsHandle semantics = tester.ensureSemantics();
    await show(
      tester,
      'ending: <span class="bbcode bbcode_spoiler">they win</span> ok',
      (href) {},
    );

    final List<String> labels = [];
    void collect(SemanticsNode node) {
      labels.add(node.label);
      node.visitChildren((child) {
        collect(child);
        return true;
      });
    }

    collect(tester.getSemantics(find.byType(Markup)));
    expect(labels, contains('Spoiler, tap to reveal'));
    expect(labels.join(' '), isNot(contains('they win')));
    semantics.dispose();
  });

  testWidgets('a coloured link keeps its colour and is underlined', (
    tester,
  ) async {
    await show(
      tester,
      '<span class="bbcode" style="color:#FF0000;">buy this: <a class="auto_link" href="/view/64721500/">the ych</a></span> <a href="/view/1/">plain</a>',
      (href) {},
    );
    final ThemeData theme = Theme.of(tester.element(find.byType(Markup)));

    final TextStyle? coloured = styleOf(tester, 'the ych');
    expect(coloured?.color, isNot(theme.colorScheme.primary));
    expect(coloured?.decoration, TextDecoration.underline);
    expect(coloured?.decorationColor, coloured?.color);

    final TextStyle? plain = styleOf(tester, 'plain');
    expect(plain?.color, theme.colorScheme.primary);
    expect(plain?.decoration, TextDecoration.underline);
    expect(plain?.decorationColor, theme.colorScheme.primary);

    expect(
      styleOf(tester, 'buy this: ')?.decoration,
      isNot(TextDecoration.underline),
    );
  });
}
