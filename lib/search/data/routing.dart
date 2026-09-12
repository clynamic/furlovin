import 'package:furlovin/routing/routing.dart';
import 'package:furlovin/search/search.dart';
import 'package:material_ui/material_ui.dart';

extension SearchRouting on BuildContext {
  void openQuery(SearchQuery query) => goSearch(query.location);

  void runSearch(SearchQuery query) => goSearch(query.location, replace: true);

  void editSearch(SearchQuery query) =>
      goSearch({searchEditKey: '1', ...query.location});
}
