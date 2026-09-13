import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  Widget box(String label, double width) => SizedBox(
    key: ValueKey(label),
    width: width,
    height: 32,
    child: Text(label),
  );

  Future<void> pump(
    WidgetTester tester, {
    required double width,
    required List<Widget> children,
    Set<int> pinned = const {},
  }) => tester.pumpWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: width,
          child: PriorityRow(
            spacing: 10,
            pinned: pinned,
            overflow: box('more', 50),
            children: children,
          ),
        ),
      ),
    ),
  );

  bool shown(WidgetTester tester, String label) =>
      find.text(label).hitTestable().evaluate().isNotEmpty;

  testWidgets('shows everything and no overflow when it all fits', (
    tester,
  ) async {
    await pump(
      tester,
      width: 400,
      children: [box('a', 100), box('b', 100), box('c', 100)],
    );
    expect(
      shown(tester, 'a') && shown(tester, 'b') && shown(tester, 'c'),
      isTrue,
    );
    expect(shown(tester, 'more'), isFalse);
  });

  testWidgets('fills in order and ends with the overflow', (tester) async {
    await pump(
      tester,
      width: 280,
      children: [box('a', 100), box('b', 100), box('c', 100)],
    );
    expect(shown(tester, 'a'), isTrue);
    expect(shown(tester, 'b'), isTrue);
    expect(shown(tester, 'c'), isFalse);
    expect(shown(tester, 'more'), isTrue);
    expect(tester.getTopLeft(find.byKey(const ValueKey('more'))).dx, 220);
  });

  testWidgets('keeps a pinned child even when earlier ones would fit', (
    tester,
  ) async {
    await pump(
      tester,
      width: 280,
      pinned: {2},
      children: [box('a', 100), box('b', 100), box('c', 100)],
    );
    expect(shown(tester, 'a'), isTrue);
    expect(shown(tester, 'b'), isFalse);
    expect(shown(tester, 'c'), isTrue);
    expect(tester.getTopLeft(find.byKey(const ValueKey('c'))).dx, 110);
  });

  testWidgets('a hidden child cannot be tapped', (tester) async {
    int taps = 0;
    await pump(
      tester,
      width: 170,
      children: [
        box('a', 100),
        GestureDetector(onTap: () => taps++, child: box('b', 100)),
      ],
    );
    await tester.tapAt(const Offset(160, 16));
    expect(taps, 0);
  });

  testWidgets('squeezes a pinned child that cannot fit beside the overflow', (
    tester,
  ) async {
    await pump(
      tester,
      width: 120,
      pinned: {0},
      children: [box('a', 100), box('b', 100)],
    );
    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byKey(const ValueKey('a'))).width, 60);
    expect(tester.getTopLeft(find.byKey(const ValueKey('more'))).dx, 70);
    expect(tester.getSize(find.byType(PriorityRow)).width, 120);
  });
}
