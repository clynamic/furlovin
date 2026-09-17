import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/app/app.dart';
import 'package:furlovin/routing/routing.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  late StreamController<Uri> links;
  late List<String> handed;
  late GoRouter router;

  Future<void> pump(WidgetTester tester) async {
    links = StreamController<Uri>();
    addTearDown(links.close);
    handed = [];
    final GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();
    Widget page(GoRouterState state) => Text(state.uri.path);
    router = GoRouter(
      navigatorKey: navigator,
      initialLocation: browsePath,
      routes: [
        GoRoute(
          path: browsePath,
          builder: (context, state) => page(state),
          routes: [
            for (final String path in [
              'view/:id',
              'user/:name',
              'gallery/:name',
              'gallery/:name/folder/:id/:slug',
              'favorites/:name',
            ])
              GoRoute(path: path, builder: (context, state) => page(state)),
          ],
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
        builder: (context, child) => LinkListener(
          links: links.stream,
          navigator: navigator,
          elsewhere: (url) async => handed.add(url),
          child: child!,
        ),
      ),
    );
  }

  Future<String> send(WidgetTester tester, String url) async {
    links.add(Uri.parse(url));
    await tester.pumpAndSettle();
    return tester.widget<Text>(find.byType(Text)).data!;
  }

  testWidgets('opens FA pages on top of the current branch', (tester) async {
    await pump(tester);
    expect(
      await send(tester, 'https://www.furaffinity.net/gallery/fennel/'),
      '/browse/gallery/fennel',
    );
    expect(
      await send(tester, 'https://furaffinity.net/view/66339591/'),
      '/browse/view/66339591',
    );
  });

  testWidgets('drops the page part of a listing link', (tester) async {
    await pump(tester);
    expect(
      await send(
        tester,
        'https://www.furaffinity.net/gallery/fennel/folder/540995/Elder-Clover/2/',
      ),
      '/browse/gallery/fennel/folder/540995/Elder-Clover',
    );
    expect(
      await send(
        tester,
        'https://www.furaffinity.net/favorites/elder54/1732255726/next',
      ),
      '/browse/favorites/elder54',
    );
  });

  testWidgets('hands pages the app has no screen for elsewhere', (
    tester,
  ) async {
    await pump(tester);
    expect(
      await send(tester, 'https://www.furaffinity.net/journal/123/'),
      browsePath,
    );
    expect(handed, ['https://www.furaffinity.net/journal/123/']);
  });
}
