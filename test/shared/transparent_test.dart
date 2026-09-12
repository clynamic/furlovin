import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  late DismissController top;

  Future<DismissRoute<void>> stack(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        onGenerateRoute: (settings) => DismissRoute<void>(
          builder: (context) =>
              const Scaffold(body: Center(child: Text('below'))),
          settings: settings,
        ),
      ),
    );
    await tester.pumpAndSettle();

    final DismissRoute<void> route = DismissRoute<void>(
      barrier: Colors.black,
      transition: DismissTransition.fade,
      builder: (context) {
        top = DismissController(DismissRoute.of(context));
        return const Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(child: Text('above')),
        );
      },
    );
    final NavigatorState navigator = tester.state(find.byType(Navigator));
    navigator.push(route);
    await tester.pumpAndSettle();
    return route;
  }

  double scrim(WidgetTester tester) => tester
      .widgetList<ColoredBox>(
        find.descendant(
          of: find.byType(IgnorePointer),
          matching: find.byType(ColoredBox),
        ),
      )
      .last
      .color
      .a;

  testWidgets('the route beneath is painted once a drag starts', (
    tester,
  ) async {
    final DismissRoute<void> route = await stack(tester);

    expect(route.overlayEntries.first.opaque, isTrue);
    expect(find.text('below'), findsNothing);

    top.push(60);
    await tester.pump();

    expect(route.overlayEntries.first.opaque, isFalse);
    expect(find.text('below'), findsOneWidget);
  });

  testWidgets('the scrim clears over the reach of the drag', (tester) async {
    await stack(tester);

    expect(scrim(tester), 1);

    top.push(dismissReach / 2);
    await tester.pump();
    expect(scrim(tester), closeTo(0.5, 0.01));

    top.push(dismissReach / 2);
    await tester.pump();
    expect(scrim(tester), closeTo(0, 0.01));
  });

  testWidgets('the scrim returns when a drag is released short', (
    tester,
  ) async {
    await stack(tester);

    top.push(60);
    await tester.pump();
    expect(scrim(tester), lessThan(1));

    expect(top.release(0), isFalse);
    await tester.pumpAndSettle();
    expect(scrim(tester), 1);
  });

  testWidgets('a covered page never recedes behind a drag', (tester) async {
    final _SecondarySpy spy = _SecondarySpy();
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              for (final TargetPlatform platform in TargetPlatform.values)
                platform: spy,
            },
          ),
        ),
        onGenerateRoute: (settings) => DismissRoute<void>(
          builder: (context) =>
              const Scaffold(body: Center(child: Text('below'))),
          settings: settings,
        ),
      ),
    );
    await tester.pumpAndSettle();

    final NavigatorState navigator = tester.state(find.byType(Navigator));
    navigator.push(
      DismissRoute<void>(
        builder: (context) =>
            const Scaffold(body: Center(child: Text('above'))),
      ),
    );
    await tester.pumpAndSettle();

    expect(spy.largestSecondary, 0);
  });
}

class _SecondarySpy extends PageTransitionsBuilder {
  double largestSecondary = 0;

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (secondaryAnimation.value > largestSecondary) {
      largestSecondary = secondaryAnimation.value;
    }
    return child;
  }
}
