import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/routing/routing.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('a page opened over the tabs hands its links to the tab below', (
    tester,
  ) async {
    final GlobalKey<NavigatorState> root = GlobalKey<NavigatorState>();
    final GoRouter router = GoRouter(
      navigatorKey: root,
      initialLocation: mePath,
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, shell) => Scaffold(body: shell),
          branches: [
            for (final String path in [browsePath, mePath])
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: path,
                    builder: (context, state) => Text('tab $path'),
                    routes: [
                      GoRoute(
                        path: 'user/:name',
                        builder: (context, state) => Text(
                          '${state.uri.path} '
                          'profile ${state.pathParameters['name']}',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
        GoRoute(
          path: loginPath,
          parentNavigatorKey: root,
          builder: (context, state) => Scaffold(
            body: TextButton(
              onPressed: () => context.openUser('pinemarten'),
              child: const Text('link'),
            ),
          ),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    unawaited(router.push(loginPath));
    await tester.pumpAndSettle();
    await tester.tap(find.text('link'));
    await tester.pumpAndSettle();
    expect(find.text('/me/user/pinemarten profile pinemarten'), findsOneWidget);
    expect(find.text('link'), findsNothing);
  });

  testWidgets('settings and reports open in the current tab', (tester) async {
    final GoRouter router = GoRouter(
      initialLocation: mePath,
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, shell) => Scaffold(body: shell),
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: mePath,
                  builder: (context, state) => Column(
                    children: [
                      TextButton(
                        onPressed: context.openSettings,
                        child: const Text('settings'),
                      ),
                      TextButton(
                        onPressed: () => context.openReport('/tickets/'),
                        child: const Text('report'),
                      ),
                    ],
                  ),
                  routes: [
                    for (final String page in ['settings', 'report'])
                      GoRoute(
                        path: page,
                        builder: (context, state) =>
                            Text('at ${state.uri.path}'),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.tap(find.text('settings'));
    await tester.pumpAndSettle();
    expect(find.text('at /me/settings'), findsOneWidget);

    router.pop();
    await tester.pumpAndSettle();
    await tester.tap(find.text('report'));
    await tester.pumpAndSettle();
    expect(find.text('at /me/report'), findsOneWidget);
  });
}
