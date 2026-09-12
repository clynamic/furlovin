import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  WidgetBuilder probe(void Function(DismissController) found) =>
      (BuildContext context) {
        final DismissController controller = DismissController(
          DismissRoute.of(context),
        );
        found(controller);
        return ListenableBuilder(
          listenable: controller,
          builder: (context, child) => Scaffold(
            body: Center(child: Text('${controller.offset.round()}')),
          ),
        );
      };

  testWidgets('refuses to drag when nothing is behind it', (tester) async {
    late DismissController only;
    await tester.pumpWidget(
      MaterialApp(
        onGenerateRoute: (settings) => DismissRoute<void>(
          builder: probe((e) => only = e),
          settings: settings,
        ),
      ),
    );
    await tester.pumpAndSettle();

    only.push(200);
    await tester.pump();

    expect(only.offset, 0);
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('drags once a route is beneath', (tester) async {
    late DismissController bottom;
    late DismissController top;
    await tester.pumpWidget(
      MaterialApp(
        onGenerateRoute: (settings) => DismissRoute<void>(
          builder: probe((e) => bottom = e),
          settings: settings,
        ),
      ),
    );
    await tester.pumpAndSettle();

    final NavigatorState navigator = tester.state(find.byType(Navigator));
    navigator.push(DismissRoute<void>(builder: probe((e) => top = e)));
    await tester.pumpAndSettle();

    expect(bottom.route.dismissible, isFalse);

    top.push(200);
    await tester.pump();

    expect(top.offset, closeTo(200, 0.001));
    expect(top.exceeds(0), isTrue);
  });

  testWidgets('settles a drag that was never released', (tester) async {
    late DismissController top;
    await tester.pumpWidget(
      MaterialApp(
        onGenerateRoute: (settings) =>
            DismissRoute<void>(builder: probe((e) {}), settings: settings),
      ),
    );
    await tester.pumpAndSettle();

    final NavigatorState navigator = tester.state(find.byType(Navigator));
    navigator.push(DismissRoute<void>(builder: probe((e) => top = e)));
    await tester.pumpAndSettle();

    top.push(60);
    await tester.pump();
    expect(top.isDragging, isTrue);

    top.settle();
    await tester.pumpAndSettle();

    expect(top.isDragging, isFalse);
    expect(top.offset, 0);
    expect(top.route.dragging.value, isFalse);
  });

  testWidgets('a stale drag does not swallow the next one', (tester) async {
    late DismissController top;
    await tester.pumpWidget(
      MaterialApp(
        onGenerateRoute: (settings) =>
            DismissRoute<void>(builder: probe((e) {}), settings: settings),
      ),
    );
    await tester.pumpAndSettle();

    final NavigatorState navigator = tester.state(find.byType(Navigator));
    navigator.push(DismissRoute<void>(builder: probe((e) => top = e)));
    await tester.pumpAndSettle();

    top.push(60);
    await tester.pump();
    top.route.driver.value = 1;
    await tester.pump();

    top.push(-40);
    await tester.pump();

    expect(top.route.direction, -1);
    expect(top.offset, closeTo(-40, 0.001));
  });
}
