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
    path: 'gallery/:name/folder/:id/:slug',
    pageBuilder: (context, state) => DismissPage<void>(
      key: state.pageKey,
      child: UserGalleryPage(
        source: GallerySource.folder(
          state.pathParameters['name']!,
          int.parse(state.pathParameters['id']!),
          state.pathParameters['slug']!,
        ),
      ),
    ),
  ),
  GoRoute(
    path: 'gallery/:name',
    pageBuilder: (context, state) => DismissPage<void>(
      key: state.pageKey,
      child: UserGalleryPage(
        source: GallerySource.main(state.pathParameters['name']!),
      ),
    ),
  ),
  GoRoute(
    path: 'scraps/:name',
    pageBuilder: (context, state) => DismissPage<void>(
      key: state.pageKey,
      child: UserGalleryPage(
        source: GallerySource.scraps(state.pathParameters['name']!),
      ),
    ),
  ),
  GoRoute(
    path: 'favorites/:name',
    pageBuilder: (context, state) => DismissPage<void>(
      key: state.pageKey,
      child: UserFavoritesPage(name: state.pathParameters['name']!),
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

final Map<String, Widget Function(GoRouterState state)> _roots = {
  browsePath: (state) => const BrowsePage(),
  searchPath: (state) => SearchPage(
    query: SearchQuery.fromLocation(state.uri.queryParameters),
    editing: state.uri.queryParameters[searchEditKey] == '1',
  ),
  inboxPath: (state) => const InboxPage(),
  mePath: (state) => const MePage(),
};

StatefulShellBranch _branch(ShellDestination destination) {
  final int at = shellDestinations.indexOf(destination);
  return StatefulShellBranch(
    routes: [
      GoRoute(
        path: destination.path,
        pageBuilder: (context, state) => DismissPage<void>(
          key: state.pageKey,
          child: BranchScroll(
            branch: at,
            child: _roots[destination.path]!(state),
          ),
        ),
        routes: _reachable(),
      ),
    ],
  );
}

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
        for (final ShellDestination at in shellDestinations) _branch(at),
      ],
    ),
    _entry('$submissionPath/:id'),
    _entry('$galleryPath/:name/$folderSegment/:id/:slug'),
    _entry('$galleryPath/:name'),
    _entry('$scrapsPath/:name'),
    _entry('$favoritesPath/:name'),
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
