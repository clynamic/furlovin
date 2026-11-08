import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/settings/settings.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  Override settingsOf({String users = 'Pine.Marten\n', bool hide = false}) =>
      profileSettingsProvider.overrideWith(
        (ref) async => ProfileSettingsDocument(
          blockedUsers: users,
          hideBlockedContent: hide,
        ),
      );

  Future<void> show(
    WidgetTester tester, {
    String? key,
    bool hide = false,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          viewerProvider.overrideWith(
            (ref) async => Viewer(
              name: 'mossbadger',
              tagBlocklist: 'toes feet',
              blocklistKey: key,
            ),
          ),
          settingsOf(hide: hide),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: BlocklistSettings()),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('lists the blocked tags and users of the account', (
    tester,
  ) async {
    await show(tester, key: 'ab12');
    expect(find.widgetWithText(InputChip, 'feet'), findsOneWidget);
    expect(find.widgetWithText(InputChip, 'toes'), findsOneWidget);
    expect(find.widgetWithText(ActionChip, 'Pine.Marten'), findsOneWidget);
  });

  testWidgets('the caption under blocked users follows the hide setting', (
    tester,
  ) async {
    Future<Set<String>> texts({required bool hide}) async {
      await tester.pumpWidget(const SizedBox());
      await show(tester, hide: hide);
      return {
        for (final Element text in find.byType(Text).evaluate())
          (text.widget as Text).data ?? '',
      };
    }

    final Set<String> shown = await texts(hide: false);
    final Set<String> hidden = await texts(hide: true);
    expect(shown.difference(hidden), hasLength(1));
    expect(hidden.difference(shown), hasLength(1));
  });

  testWidgets('the add button opens a row with the field and a confirm', (
    tester,
  ) async {
    await show(tester, key: 'ab12');
    expect(find.byType(TextField), findsNothing);
    await tester.tap(find.text('Block a tag'));
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byIcon(Icons.check), findsOneWidget);
    expect(find.text('Block a tag'), findsNothing);
  });

  testWidgets('confirming an empty row closes it', (tester) async {
    await show(tester, key: 'ab12');
    await tester.tap(find.text('Block a tag'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.check));
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsNothing);
    expect(find.text('Block a tag'), findsOneWidget);
  });

  testWidgets('without the blocklist key, tags show but cannot change', (
    tester,
  ) async {
    await show(tester);
    expect(
      tester
          .widget<InputChip>(find.widgetWithText(InputChip, 'feet'))
          .onDeleted,
      isNull,
    );
    expect(find.text('Block a tag'), findsNothing);
  });

  testWidgets('a full shelf shows one row and expands on request', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 320,
            child: ChipShelf(
              empty: 'No blocked tags',
              chips: [
                for (int at = 0; at < 12; at++) Chip(label: Text('tag$at')),
              ],
            ),
          ),
        ),
      ),
    );
    expect(find.text('tag11').hitTestable(), findsNothing);
    await tester.tap(find.text('Show all 12'));
    await tester.pumpAndSettle();
    expect(find.text('tag11').hitTestable(), findsOneWidget);
    expect(find.text('Show fewer'), findsOneWidget);
  });

  testWidgets('a shelf keeps one row of height while loading or empty', (
    tester,
  ) async {
    Future<double> heightOf(ChipShelf shelf) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: SizedBox(width: 320, child: shelf)),
        ),
      );
      return tester.getSize(find.byType(ChipShelf)).height;
    }

    final double filled = await heightOf(
      const ChipShelf(
        empty: 'none',
        chips: [Chip(label: Text('feet'))],
      ),
    );
    expect(await heightOf(const ChipShelf(empty: 'none', chips: [])), filled);
    expect(
      await heightOf(const ChipShelf(empty: 'none', chips: [], loading: true)),
      filled,
    );
  });
}
