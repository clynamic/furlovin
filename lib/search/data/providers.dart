import 'package:furlovin/search/search.dart';
import 'package:furlovin/submission/submission.dart';

final SubmissionListing<SearchQuery, List<SubmissionPreview>> searchListing =
    SubmissionListing(
      name: 'search',
      fetch: (client, query, page) =>
          client.search(query.parameters(page: page)),
      items: (page) => page,
      next: (page, key) => page.isEmpty ? null : key + 1,
    );
