import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('a held image under a page is drawn at once by a hero flight '
      'back after the app was hidden through memory pressure', (tester) async {
    final Uint8List png = (await tester.runAsync(() async {
      final ui.PictureRecorder recorder = ui.PictureRecorder();
      Canvas(recorder).drawRect(
        const Rect.fromLTWH(0, 0, 4, 4),
        Paint()..color = const Color(0xFFFF0000),
      );
      final ui.Image image = await recorder.endRecording().toImage(4, 4);
      final ByteData? data = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      return data!.buffer.asUint8List();
    }))!;
    final MemoryImage full = MemoryImage(png);
    final ImageProvider tile = ResizeImage(full, width: 2);
    final ValueNotifier<bool> hidden = ValueNotifier(false);
    addTearDown(hidden.dispose);
    final GlobalKey<NavigatorState> navigator = GlobalKey();

    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: navigator,
        builder: (context, child) => ValueListenableBuilder<bool>(
          valueListenable: hidden,
          builder: (context, hidden, _) =>
              Visibility(visible: !hidden, maintainState: true, child: child!),
        ),
        home: Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: SizedBox.square(
              dimension: 100,
              child: Hero(
                tag: 'post',
                child: HeldImage(
                  image: tile,
                  child: Image(image: tile),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.runAsync(
      () => precacheImage(tile, tester.element(find.byType(HeldImage))),
    );
    await tester.pumpAndSettle();
    navigator.currentState!.push(
      MaterialPageRoute<void>(
        builder: (context) => Scaffold(
          body: Center(
            child: SizedBox.square(
              dimension: 300,
              child: Hero(
                tag: 'post',
                child: Image(image: full),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    hidden.value = true;
    await tester.pump();
    tester.binding.handleMemoryPressure();
    hidden.value = false;
    await tester.pump();
    navigator.currentState!.pop();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 16));

    final RawImage flight = tester.widget<RawImage>(
      find
          .descendant(
            of: find.byType(HeldImage),
            matching: find.byType(RawImage),
          )
          .first,
    );
    expect(flight.image, isNotNull);
    await tester.pumpAndSettle();
  });
}
