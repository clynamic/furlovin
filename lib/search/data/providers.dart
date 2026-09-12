import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:furlovin/search/search.dart';
import 'package:furlovin/submission/submission.dart';

final ProviderFamily<SubmissionPaging, SearchQuery> searchProvider =
    Provider.family<SubmissionPaging, SearchQuery>(
      (ref, query) => submissionPaging(
        ref,
        (client, page) => client.search(query.parameters(page: page)),
      ),
    );
