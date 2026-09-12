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
}
