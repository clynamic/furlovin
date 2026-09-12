import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  late ZoomController zoom;
  late List<Offset> spare;
  late Velocity? ended;

  Future<void> pump(WidgetTester tester, {double? ratio}) async {
    zoom = ZoomController();
    addTearDown(zoom.dispose);
    spare = [];
    ended = null;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Zoomable(
            controller: zoom,
            aspectRatio: ratio,
            onSpare: spare.add,
            onSpareEnd: (velocity) => ended = velocity,
            child: Container(color: Colors.red),
          ),
        ),
      ),
    );
  }

  double vertical() => spare.fold<double>(0, (sum, e) => sum + e.dy);

  testWidgets('hands the whole drag over at rest scale', (tester) async {
    await pump(tester);

    await tester.drag(find.byType(Zoomable), const Offset(0, 120));
    await tester.pumpAndSettle();

    expect(vertical(), closeTo(100, 2));
    expect(ended, isNotNull);
  });

  testWidgets('a drag that begins away from an edge stays a pan', (
    tester,
  ) async {
    await pump(tester);
    zoom.transformation.value = Matrix4.identity()
      ..scaleByDouble(2, 2, 1, 1)
      ..translateByDouble(-200, -150, 0, 1);
    await tester.pump();

    await tester.drag(find.byType(Zoomable), const Offset(0, 600));
    await tester.pumpAndSettle();

    expect(vertical(), 0);
  });

  testWidgets('a drag that begins at the edge hands over', (tester) async {
    await pump(tester);
    zoom.transformation.value = Matrix4.identity()..scaleByDouble(2, 2, 1, 1);
    await tester.pump();

    await tester.drag(find.byType(Zoomable), const Offset(0, 300));
    await tester.pumpAndSettle();

    expect(vertical(), greaterThan(0));
  });

  testWidgets('a scroll wheel never reaches dismiss', (tester) async {
    await pump(tester);
    final Offset centre = tester.getCenter(find.byType(Zoomable));
    final TestPointer mouse = TestPointer(1, PointerDeviceKind.mouse);
    mouse.hover(centre);
    for (int turn = 0; turn < 5; turn++) {
      await tester.sendEventToBinding(mouse.scroll(const Offset(0, -120)));
      await tester.pump();
    }

    expect(vertical(), 0);
  });

  testWidgets('a residual zoom still reaches dismiss', (tester) async {
    await pump(tester);
    zoom.transformation.value = Matrix4.identity()
      ..scaleByDouble(1.09, 1.09, 1, 1);
    await tester.pump();
    expect(zoom.isZoomed, isTrue, reason: 'the old gate would refuse here');

    await tester.drag(find.byType(Zoomable), const Offset(0, 400));
    await tester.pumpAndSettle();

    expect(vertical(), greaterThan(0));
  });

  Future<void> doubleTap(WidgetTester tester, Offset at) async {
    await tester.tapAt(at);
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tapAt(at);
    await tester.pumpAndSettle();
  }

  Offset under(Offset point) => MatrixUtils.transformPoint(
    Matrix4.inverted(zoom.transformation.value),
    point,
  );

  testWidgets('a double tap on the image holds that point still', (
    tester,
  ) async {
    await pump(tester, ratio: 2);

    await doubleTap(tester, const Offset(400, 200));

    expect(zoom.scale, zoomStep);
    expect(under(const Offset(400, 200)).dy, closeTo(200, 1));
  });

  testWidgets('a double tap on the letterbox zooms the image centre', (
    tester,
  ) async {
    await pump(tester, ratio: 2);

    await doubleTap(tester, const Offset(400, 40));

    expect(zoom.scale, zoomStep);
    expect(under(const Offset(400, 300)), const Offset(400, 300));
  });

  testWidgets('without an aspect ratio it stays focal on the tap', (
    tester,
  ) async {
    await pump(tester);

    await doubleTap(tester, const Offset(400, 40));

    expect(under(const Offset(400, 40)).dy, closeTo(40, 1));
  });
}
