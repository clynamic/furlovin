import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/submission/submission.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  Future<void> show(WidgetTester tester, {String? key}) => tester.pumpWidget(
    ProviderScope(
      overrides: [
        viewerProvider.overrideWith(
          (ref) async => Viewer(
            name: 'mossbadger',
            tagBlocklist: 'feet',
            blocklistKey: key,
          ),
        ),
      ],
      child: const MaterialApp(
        home: Scaffold(body: SubmissionTags(tags: ['feet', 'dragon'])),
      ),
    ),
  );

  Finder chip(String tag) =>
      find.ancestor(of: find.text(tag), matching: find.byType(TagChip));

  testWidgets('marks the tags the blocklist holds', (tester) async {
    await show(tester, key: 'ab12');
    await tester.pumpAndSettle();
    expect(
      find.descendant(of: chip('feet'), matching: find.byIcon(Icons.block)),
      findsOneWidget,
    );
    expect(
      find.descendant(of: chip('dragon'), matching: find.byIcon(Icons.block)),
      findsNothing,
    );
  });

  testWidgets('a menu titled with the tag offers to unblock or block it', (
    tester,
  ) async {
    await show(tester, key: 'ab12');
    await tester.pumpAndSettle();
    await tester.longPress(find.text('feet'));
    await tester.pumpAndSettle();
    expect(find.text('Unblock tag'), findsOneWidget);
    expect(find.text('feet'), findsNWidgets(2));
    await tester.tapAt(Offset.zero);
    await tester.pumpAndSettle();
    await tester.longPress(find.text('dragon'));
    await tester.pumpAndSettle();
    expect(find.text('Block tag'), findsOneWidget);
  });

  testWidgets('without the blocklist key, tags stay marked but not editable', (
    tester,
  ) async {
    await show(tester);
    await tester.pumpAndSettle();
    expect(tester.widget<TagChip>(chip('dragon')).onSetBlocked, isNull);
    expect(
      find.descendant(of: chip('feet'), matching: find.byIcon(Icons.block)),
      findsOneWidget,
    );
  });
}
