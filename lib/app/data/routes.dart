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

GoRoute _covering(String path, GoRouterPageBuilder pageBuilder) => GoRoute(
  path: path,
  parentNavigatorKey: rootNavigator,
  pageBuilder: pageBuilder,
);

GoRouter buildRouter(IdentityStore store) => GoRouter(
  navigatorKey: rootNavigator,
  initialLocation: browsePath,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => HomeShell(shell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: inboxPath,
              builder: (context, state) => const InboxPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: browsePath,
              builder: (context, state) => const BrowsePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: mePath, builder: (context, state) => const MePage()),
          ],
        ),
      ],
    ),
    _covering(
      '$submissionPath/:id',
      (context, state) => DismissPage<void>(
        key: state.pageKey,
        child: SubmissionPage(
          id: int.parse(state.pathParameters['id']!),
          preview: state.extra is SubmissionPreview
              ? state.extra! as SubmissionPreview
              : null,
        ),
      ),
    ),
    _covering(
      searchPath,
      (context, state) => DismissPage<void>(
        key: state.pageKey,
        child: SearchPage(
          query: SearchQuery.fromLocation(state.uri.queryParameters),
          editing: state.uri.queryParameters[searchEditKey] == '1',
        ),
      ),
    ),
    _covering(
      '$galleryPath/:name',
      (context, state) => DismissPage<void>(
        key: state.pageKey,
        child: UserGalleryPage(name: state.pathParameters['name']!),
      ),
    ),
    _covering(
      '$userPath/:name',
      (context, state) => DismissPage<void>(
        key: state.pageKey,
        child: UserPage(name: state.pathParameters['name']!),
      ),
    ),
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
