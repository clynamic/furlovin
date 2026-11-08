import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

const String inboxPath = '/inbox';
const String browsePath = '/browse';
const String mePath = '/me';
const List<String> branchRoots = [browsePath, searchPath, inboxPath, mePath];

const String submissionPath = '/view';
const String userPath = '/user';
const String galleryPath = '/gallery';
const String scrapsPath = '/scraps';
const String folderSegment = 'folder';
const String favoritesPath = '/favorites';
const String searchPath = '/search';
const String loginPath = '/login';
const String challengePath = '/challenge';
const String settingsPath = '/settings';
const String reportPath = '/report';
const String searchTextKey = 'q';
const String searchEditKey = 'edit';
const String challengeUrlKey = 'url';
const String reportLinkKey = 'link';

String? _branchOf(String where) {
  for (final String root in branchRoots) {
    if (where == root || where.startsWith('$root/')) return root;
  }
  return null;
}

bool _coversTabs(GoRouter router) =>
    _branchOf(
      router.routerDelegate.currentConfiguration.last.matchedLocation,
    ) ==
    null;

extension AppRouting on BuildContext {
  String get branch =>
      _branchOf(
        GoRouter.of(this).routerDelegate.currentConfiguration.uri.path,
      ) ??
      browsePath;

  String _surface() {
    final GoRouter router = GoRouter.of(this);
    while (_coversTabs(router) && router.canPop()) {
      router.pop();
    }
    return branch;
  }

  void openSubmission(int id, {Object? extra}) =>
      GoRouter.of(this).push('${_surface()}$submissionPath/$id', extra: extra);

  void openUser(String name) =>
      GoRouter.of(this).push('${_surface()}$userPath/$name');

  void openGallery(String name, {bool replace = false}) =>
      _open('${_surface()}$galleryPath/$name', replace: replace);

  void openScraps(String name, {bool replace = false}) =>
      _open('${_surface()}$scrapsPath/$name', replace: replace);

  void openFolder(String name, int id, String slug, {bool replace = false}) =>
      _open(
        '${_surface()}$galleryPath/$name/$folderSegment/$id/$slug',
        replace: replace,
      );

  void _open(String location, {required bool replace}) {
    if (replace) {
      GoRouter.of(this).replace(location);
      return;
    }
    GoRouter.of(this).push(location);
  }

  void openFavorites(String name) =>
      GoRouter.of(this).push('${_surface()}$favoritesPath/$name');

  void openLogin() => GoRouter.of(this).push(loginPath);

  Future<bool?> openChallenge(String url) => GoRouter.of(this).push<bool>(
    Uri(
      path: challengePath,
      queryParameters: {challengeUrlKey: url},
    ).toString(),
  );

  void openSettings() => GoRouter.of(this).push('${_surface()}$settingsPath');

  void openReport(String link) => GoRouter.of(this).push(
    Uri(
      path: '${_surface()}$reportPath',
      queryParameters: {reportLinkKey: link},
    ).toString(),
  );

  void openSearch() => GoRouter.of(this).push('$branch$searchPath');

  void openSearchText(String text) =>
      goSearch({if (text.isNotEmpty) searchTextKey: text});

  void goSearch(Map<String, String> location, {bool replace = false}) {
    final String here = branch;
    final String target = Uri(
      path: here == searchPath ? searchPath : '$here$searchPath',
      queryParameters: location.isEmpty ? null : location,
    ).toString();
    if (replace) {
      GoRouter.of(this).pushReplacement(target);
      return;
    }
    GoRouter.of(this).push(target);
  }
}
