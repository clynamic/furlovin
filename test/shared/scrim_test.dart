import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('spans the width it is aligned inside of', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Stack(
            children: [
              Align(alignment: Alignment.topCenter, child: TopScrim()),
            ],
          ),
        ),
      ),
    );

    final Size size = tester.getSize(find.byType(TopScrim));
    expect(size.height, 110);
    expect(
      size.width,
      tester.view.physicalSize.width / tester.view.devicePixelRatio,
    );
  });
}
