import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/search/search.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  late List<SearchTerm> terms;
  late int submitted;

  Future<void> pump(WidgetTester tester) async {
    terms = [];
    submitted = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => TermField(
              terms: terms,
              onChanged: (next) => setState(() => terms = next),
              onSubmitted: () => submitted++,
            ),
          ),
        ),
      ),
    );
  }

  Finder input() => find.descendant(
    of: find.byType(TermField),
    matching: find.byType(TextField),
  );

  String field(WidgetTester tester) =>
      tester.widget<TextField>(input()).controller!.text;

  Future<void> type(WidgetTester tester, String text) async {
    for (final String char in text.split('')) {
      await tester.enterText(input(), '${field(tester)}$char');
      await tester.pump();
    }
  }

  Future<void> backspace(WidgetTester tester) async {
    final String now = field(tester);
    await tester.enterText(input(), now.substring(0, now.length - 1));
    await tester.pump();
  }

  group('sentence', () {
    String said(SearchTerm term) =>
        termSentence(term).map((e) => e.text).join();

    test('reads a scoped term as a phrase', () {
      expect(
        said(const SearchTerm(['moth'], scope: TermScope.tags)),
        'posts with moth in their tags',
      );
      expect(
        said(const SearchTerm(['binaryfloof'], scope: TermScope.uploader)),
        'posts by uploader binaryfloof',
      );
    });

    test('reads exclusion and alternatives', () {
      expect(
        said(const SearchTerm(['moth', 'fennel114', 'fox'], excluded: true)),
        'posts not mentioning moth, fennel114 or fox',
      );
    });
  });

  testWidgets('a word becomes a chip once a space follows it', (tester) async {
    await pump(tester);
    await type(tester, 'fennel114');
    expect(terms, isEmpty);
    await type(tester, ' ');
    expect(terms, const [
      SearchTerm(['fennel114']),
    ]);
    expect(field(tester), termAnchor);
  });

  testWidgets('a space inside quotes does not end the term', (tester) async {
    await pump(tester);
    await type(tester, '"red panda" ');
    expect(terms, const [
      SearchTerm(['red panda']),
    ]);
  });

  testWidgets('a leading minus makes an excluded chip', (tester) async {
    await pump(tester);
    await type(tester, '-fox ');
    expect(terms, const [
      SearchTerm(['fox'], excluded: true),
    ]);
  });

  testWidgets('a scope key makes a scoped chip', (tester) async {
    await pump(tester);
    await type(tester, 'by:someone ');
    expect(terms, const [
      SearchTerm(['someone'], scope: TermScope.uploader),
    ]);
  });

  testWidgets('a field operator waits for the term it scopes', (tester) async {
    await pump(tester);
    await type(tester, '@keywords ');
    expect(terms, isEmpty);
    expect(field(tester), '$termAnchor@keywords ');
    await type(tester, 'moth ');
    expect(terms, const [
      SearchTerm(['moth'], scope: TermScope.tags),
    ]);
  });

  testWidgets('a bare key waits for its word without suggestions', (
    tester,
  ) async {
    await pump(tester);
    await type(tester, '-by: ');
    await tester.pumpAndSettle();
    expect(terms, isEmpty);
    expect(find.byType(TermSuggestion), findsNothing);
    await backspace(tester);
    await type(tester, 'someone ');
    expect(terms, const [
      SearchTerm(['someone'], scope: TermScope.uploader, excluded: true),
    ]);
  });

  testWidgets('or joins the next word into the last chip', (tester) async {
    await pump(tester);
    await type(tester, 'moth | ');
    expect(terms, const [
      SearchTerm(['moth']),
    ]);
    await type(tester, 'butterfly ');
    expect(terms, const [
      SearchTerm(['moth', 'butterfly']),
    ]);
  });

  testWidgets('suggests where to look for a typed word', (tester) async {
    await pump(tester);
    await type(tester, 'moth');
    await tester.pumpAndSettle();
    expect(find.byType(TermSuggestion), findsNWidgets(TermScope.values.length));
    await tester.tap(find.text(' in tags'));
    await tester.pump();
    expect(terms, const [
      SearchTerm(['moth'], scope: TermScope.tags),
    ]);
    expect(field(tester), termAnchor);
    expect(find.byType(TermSuggestion), findsNothing);
  });

  testWidgets('backspace on an empty field removes the last chip', (
    tester,
  ) async {
    await pump(tester);
    await type(tester, 'fennel114 fox ');
    expect(terms, hasLength(2));
    await backspace(tester);
    expect(terms, const [
      SearchTerm(['fennel114']),
    ]);
    expect(field(tester), termAnchor);
  });

  testWidgets('backspace with text left only edits the text', (tester) async {
    await pump(tester);
    await type(tester, 'fennel114 fo');
    await backspace(tester);
    expect(terms, const [
      SearchTerm(['fennel114']),
    ]);
    expect(field(tester), '${termAnchor}f');
  });

  testWidgets('the close button removes a chip', (tester) async {
    await pump(tester);
    await type(tester, 'fennel114 fox ');
    await tester.tap(find.byTooltip('Remove').first);
    await tester.pump();
    expect(terms, const [
      SearchTerm(['fox']),
    ]);
  });

  testWidgets('editing a chip excludes, scopes and adds alternatives', (
    tester,
  ) async {
    await pump(tester);
    await type(tester, 'moth ');
    await tester.tap(find.byType(TermChip));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Exclude'));
    await tester.tap(find.text('Tags'));
    await tester.enterText(
      find.widgetWithText(TextField, 'Add alternative'),
      'butterfly',
    );
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    expect(terms, const [
      SearchTerm(['moth', 'butterfly'], scope: TermScope.tags, excluded: true),
    ]);
  });

  testWidgets('cancelling the editor keeps the chip and the field', (
    tester,
  ) async {
    await pump(tester);
    await type(tester, 'moth ');
    await tester.tap(find.byType(TermChip));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Exclude'));
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(terms, const [
      SearchTerm(['moth']),
    ]);
    await type(tester, 'fennel114 ');
    expect(terms, const [
      SearchTerm(['moth']),
      SearchTerm(['fennel114']),
    ]);
  });

  testWidgets('the editor can remove the whole term', (tester) async {
    await pump(tester);
    await type(tester, 'moth fennel114 ');
    await tester.tap(find.byType(TermChip).first);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Remove term'));
    await tester.pumpAndSettle();
    expect(terms, const [
      SearchTerm(['fennel114']),
    ]);
  });

  testWidgets('clicking chips and suggestions keeps the keyboard up', (
    tester,
  ) async {
    await pump(tester);
    await type(tester, 'moth fox fennel114');
    await tester.pumpAndSettle();
    final FocusNode node = tester.widget<TextField>(input()).focusNode!;
    final List<bool> seen = [];
    node.addListener(() => seen.add(node.hasFocus));

    await tester.tap(
      find.byTooltip('Remove').first,
      kind: PointerDeviceKind.mouse,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text(' in tags'), kind: PointerDeviceKind.mouse);
    await tester.pumpAndSettle();

    expect(seen, isNot(contains(false)));
    expect(terms, const [
      SearchTerm(['fox']),
      SearchTerm(['fennel114'], scope: TermScope.tags),
    ]);
  });

  testWidgets('suggestions keep their space while empty', (tester) async {
    await pump(tester);
    final double empty = tester.getSize(find.byType(TermField)).height;
    await type(tester, 'moth');
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(TermField)).height, empty);
  });

  testWidgets('submitting keeps half typed text and then submits', (
    tester,
  ) async {
    await pump(tester);
    await type(tester, 'fennel114 fox');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();
    expect(terms, const [
      SearchTerm(['fennel114']),
      SearchTerm(['fox']),
    ]);
    expect(submitted, 1);
  });
}
