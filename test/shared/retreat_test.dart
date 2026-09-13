import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  late RetreatController retreat;
  late ScrollController scroll;
  late BottomClaim claim;

  Future<void> pump(WidgetTester tester, {int items = 80}) async {
    retreat = RetreatController();
    scroll = ScrollController();
    claim = BottomClaim();
    addTearDown(retreat.dispose);
    addTearDown(scroll.dispose);
    addTearDown(claim.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ScrollRetreat(
            controller: retreat,
            claim: claim,
            child: ListView.builder(
              controller: scroll,
              itemCount: items,
              itemBuilder: (context, index) =>
                  SizedBox(height: 60, child: Text('$index')),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> move(WidgetTester tester, double by) async {
    scroll.jumpTo(
      (scroll.offset + by).clamp(0, scroll.position.maxScrollExtent),
    );
    await tester.pump();
  }

  testWidgets('starts shown', (tester) async {
    await pump(tester);
    expect(retreat.shown, isTrue);
  });

  testWidgets('ignores a scroll shorter than the threshold', (tester) async {
    await pump(tester);
    await move(tester, retreatThreshold - 10);
    expect(retreat.shown, isTrue);
  });

  testWidgets('retreats once the threshold is passed', (tester) async {
    await pump(tester);
    await move(tester, retreatThreshold + 40);
    expect(retreat.shown, isFalse);
  });

  testWidgets('a small scroll back does not bring it out again', (
    tester,
  ) async {
    await pump(tester);
    await move(tester, retreatThreshold + 40);
    await move(tester, -10);
    expect(retreat.shown, isFalse);
  });

  testWidgets('a deliberate scroll back brings it out', (tester) async {
    await pump(tester);
    await move(tester, retreatThreshold + 200);
    expect(retreat.shown, isFalse);
    await move(tester, -(retreatThreshold + 10));
    expect(retreat.shown, isTrue);
  });

  testWidgets('reversing direction restarts the count', (tester) async {
    await pump(tester);
    await move(tester, retreatThreshold - 10);
    await move(tester, -(retreatThreshold - 10));
    await move(tester, retreatThreshold - 10);
    expect(retreat.shown, isTrue);
  });

  testWidgets('returning to the top brings it out', (tester) async {
    await pump(tester);
    await move(tester, retreatThreshold + 200);
    expect(retreat.shown, isFalse);
    scroll.jumpTo(0);
    await tester.pump();
    expect(retreat.shown, isTrue);
  });

  testWidgets('content that cannot scroll keeps it out', (tester) async {
    await pump(tester, items: 2);
    expect(retreat.shown, isTrue);
  });

  testWidgets('a claimed bottom leaves it as it was', (tester) async {
    await pump(tester);
    await move(tester, retreatThreshold + 200);
    claim.cover(#detail, 1);
    scroll.jumpTo(0);
    await tester.pump();
    claim.cover(#detail, 0);
    expect(retreat.shown, isFalse);
  });
}
