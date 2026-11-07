import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/settings/settings.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  Future<void> show(WidgetTester tester, {String? key}) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          viewerProvider.overrideWith(
            (ref) async => Viewer(
              name: 'mossbadger',
              tagBlocklist: 'toes feet',
              userBlocklist: 'Pine.Marten',
              blocklistKey: key,
            ),
          ),
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
    expect(find.widgetWithText(Chip, 'Pine.Marten'), findsOneWidget);
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
}
