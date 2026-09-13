import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

const String inboxPath = '/inbox';
const String browsePath = '/browse';
const String mePath = '/me';
const List<String> branchRoots = [browsePath, searchPath, inboxPath, mePath];

const String submissionPath = '/view';
const String userPath = '/user';
const String galleryPath = '/gallery';
const String favoritesPath = '/favorites';
const String searchPath = '/search';
const String loginPath = '/login';
const String settingsPath = '/settings';
const String searchTextKey = 'q';
const String searchEditKey = 'edit';

extension AppRouting on BuildContext {
  String get branch {
    final String where = GoRouter.of(this)
        .routerDelegate
        .currentConfiguration
        .uri
        .path;
    for (final String root in branchRoots) {
      if (where == root || where.startsWith('$root/')) return root;
    }
    return browsePath;
  }

  void openSubmission(int id, {Object? preview}) =>
      GoRouter.of(this).push('$branch$submissionPath/$id', extra: preview);

  void openUser(String name) =>
      GoRouter.of(this).push('$branch$userPath/$name');

  void openGallery(String name) =>
      GoRouter.of(this).push('$branch$galleryPath/$name');

  void openFavorites(String name) =>
      GoRouter.of(this).push('$branch$favoritesPath/$name');

  void openLogin() => GoRouter.of(this).push(loginPath);

  void openSettings() => GoRouter.of(this).push(settingsPath);

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
