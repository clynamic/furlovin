import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  Future<double> bottomOf(
    WidgetTester tester,
    Widget Function(Widget probe) page,
  ) async {
    late double bottom;
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(padding: EdgeInsets.only(bottom: 100)),
        child: BottomReserve(
          space: 80,
          child: page(
            Builder(
              builder: (context) {
                bottom = MediaQuery.paddingOf(context).bottom;
                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
    return bottom;
  }

  testWidgets('a claiming page lays out without the reserved space', (
    tester,
  ) async {
    expect(await bottomOf(tester, (probe) => ClaimedBottom(child: probe)), 20);
  });

  testWidgets('other pages keep the reserved space', (tester) async {
    expect(await bottomOf(tester, (probe) => probe), 100);
  });
}
