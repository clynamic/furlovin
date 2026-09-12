import 'package:furlovin/cookie_probe.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/search/search.dart';
import 'package:furlovin/settings/settings.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:furlovin/submission/submission.dart';
import 'package:furlovin/user/user.dart';
import 'package:go_router/go_router.dart';

GoRouter buildRouter(IdentityStore store) => GoRouter(
  initialLocation: '/browse',
  routes: [
    GoRoute(path: '/', redirect: (context, state) => '/browse'),
    GoRoute(
      path: '/browse',
      builder: (context, state) => const BrowsePage(),
      routes: [
        GoRoute(
          path: '/:page',
          builder: (context, state) => const BrowsePage(),
        ),
      ],
    ),
    GoRoute(
      path: '/view/:id',
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
      path: '/search',
      pageBuilder: (context, state) => DismissPage<void>(
        key: state.pageKey,
        child: SearchPage(
          query: SearchQuery.fromLocation(state.uri.queryParameters),
          editing: state.uri.queryParameters['edit'] == '1',
        ),
      ),
    ),
    GoRoute(
      path: '/gallery/:name',
      pageBuilder: (context, state) => DismissPage<void>(
        key: state.pageKey,
        child: UserGalleryPage(name: state.pathParameters['name']!),
      ),
    ),
    GoRoute(
      path: '/user/:name',
      pageBuilder: (context, state) => DismissPage<void>(
        key: state.pageKey,
        child: UserPage(name: state.pathParameters['name']!),
      ),
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: '/session',
      builder: (context, state) => CookieProbePage(store: store),
    ),
  ],
);
