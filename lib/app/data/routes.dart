import 'package:furlovin/app/app.dart';
import 'package:furlovin/cookie_probe.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/routing/routing.dart';
import 'package:furlovin/search/search.dart';
import 'package:furlovin/settings/settings.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:furlovin/submission/submission.dart';
import 'package:furlovin/user/user.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

final GlobalKey<NavigatorState> rootNavigator = GlobalKey<NavigatorState>();

List<RouteBase> _reachable() => [
  GoRoute(
    path: 'view/:id',
    pageBuilder: (context, state) => DismissPage<void>(
      key: state.pageKey,
      child: SubmissionPage(
        id: int.parse(state.pathParameters['id']!),
        preview: state.extra is SubmissionPreview
            ? state.extra! as SubmissionPreview
            : null,
      ),
    ),
  ),
  GoRoute(
    path: 'search',
    pageBuilder: (context, state) => DismissPage<void>(
      key: state.pageKey,
      child: SearchPage(
        query: SearchQuery.fromLocation(state.uri.queryParameters),
        editing: state.uri.queryParameters[searchEditKey] == '1',
      ),
    ),
  ),
  GoRoute(
    path: 'gallery/:name',
    pageBuilder: (context, state) => DismissPage<void>(
      key: state.pageKey,
      child: UserGalleryPage(name: state.pathParameters['name']!),
    ),
  ),
  GoRoute(
    path: 'user/:name',
    pageBuilder: (context, state) => DismissPage<void>(
      key: state.pageKey,
      child: UserPage(name: state.pathParameters['name']!),
    ),
  ),
];

StatefulShellBranch _branch(String root, Widget Function() page) =>
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: root,
          builder: (context, state) => page(),
          routes: _reachable(),
        ),
      ],
    );

GoRoute _entry(String path) => GoRoute(
  path: path,
  redirect: (context, state) =>
      '$browsePath${state.uri.path}'
      '${state.uri.hasQuery ? '?${state.uri.query}' : ''}',
);

GoRouter buildRouter(IdentityStore store) => GoRouter(
  navigatorKey: rootNavigator,
  initialLocation: browsePath,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => HomeShell(shell: shell),
      branches: [
        _branch(inboxPath, () => const InboxPage()),
        _branch(browsePath, () => const BrowsePage()),
        _branch(mePath, () => const MePage()),
      ],
    ),
    _entry('$submissionPath/:id'),
    _entry(searchPath),
    _entry('$galleryPath/:name'),
    _entry('$userPath/:name'),
    GoRoute(
      path: loginPath,
      parentNavigatorKey: rootNavigator,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: settingsPath,
      parentNavigatorKey: rootNavigator,
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: '/session',
      parentNavigatorKey: rootNavigator,
      builder: (context, state) => CookieProbePage(store: store),
    ),
  ],
);
