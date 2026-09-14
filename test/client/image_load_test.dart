import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  late ImageLoadController load;

  Future<void> show(WidgetTester tester, Rect image) async {
    load = ImageLoadController();
    addTearDown(load.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: SizedBox(
            width: 400,
            height: 400,
            child: ImageLoadOverlay(load: load, locate: (size) => image),
          ),
        ),
      ),
    );
  }

  Rect bar(WidgetTester tester) =>
      tester.getRect(find.byType(LinearProgressIndicator));

  Offset origin(WidgetTester tester) =>
      tester.getTopLeft(find.byType(ImageLoadOverlay));

  testWidgets('a load that finishes quickly shows no bar', (tester) async {
    await show(tester, const Rect.fromLTWH(100, 50, 200, 300));
    load.value = const ImageLoaded();
    await tester.pump(imageLoadPatience * 2);
    expect(find.byType(LinearProgressIndicator), findsNothing);
  });

  testWidgets('the bar is at the bottom edge of the image', (tester) async {
    await show(tester, const Rect.fromLTWH(100, 50, 200, 300));
    load.value = const ImageLoading(0.5);
    await tester.pump(imageLoadPatience * 2);

    final Rect placed = bar(tester).shift(-origin(tester));
    expect(placed.left, 100);
    expect(placed.width, 200);
    expect(placed.bottom, 350);
  });

  testWidgets('a zoomed image keeps the bar on screen', (tester) async {
    await show(tester, const Rect.fromLTWH(-200, -300, 800, 1200));
    load.value = const ImageLoading(0.5);
    await tester.pump(imageLoadPatience * 2);

    final Rect placed = bar(tester).shift(-origin(tester));
    expect(placed.left, 0);
    expect(placed.width, 400);
    expect(placed.bottom, 400);
  });

  testWidgets('a failed load offers a retry that loads again', (tester) async {
    await show(tester, const Rect.fromLTWH(0, 0, 400, 400));
    load.value = const ImageFailed('broken');
    await tester.pump();

    await tester.tap(find.text('Retry full image'));
    await tester.pump();

    expect(load.attempt, 1);
    expect(load.value, const ImageLoading());
  });

  testWidgets('a load held by the cooldown waits before offering a retry', (
    tester,
  ) async {
    await show(tester, const Rect.fromLTWH(0, 0, 400, 400));
    load.value = const ImageFailed(RateLimited(Duration(seconds: 3)));
    await tester.pump();

    expect(find.textContaining('Waiting for Fur Affinity'), findsOneWidget);
    await tester.tap(find.textContaining('Waiting for Fur Affinity'));
    expect(load.attempt, 0);
  });

  testWidgets('a finished image stays finished when progress arrives late', (
    tester,
  ) async {
    await show(tester, const Rect.fromLTWH(0, 0, 400, 400));
    load.report('full.png', const ImageLoaded());
    load.report('full.png', const ImageLoading());
    await tester.pump();

    expect(load.value, const ImageLoaded());
  });

  testWidgets('a sharper image reports progress after a softer one loaded', (
    tester,
  ) async {
    await show(tester, const Rect.fromLTWH(0, 0, 400, 400));
    load.report('preview.jpg', const ImageLoaded());
    await tester.pump();
    load.report('full.png', const ImageLoading(0.2));
    await tester.pump();

    expect(load.value, const ImageLoading(0.2));
  });
}
