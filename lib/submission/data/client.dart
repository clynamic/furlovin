import 'package:furlovin/client/client.dart';
import 'package:furlovin/logs/logs.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:furlovin/submission/submission.dart';

const int inboxPageSize = 48;

class SubmissionClient {
  SubmissionClient({required this.client, required this.rules});

  final FaClient client;
  final RuleSet rules;

  final Logger logger = Logger('SubmissionClient');

  Future<List<SubmissionPreview>> browse({int page = 1}) async =>
      (await client.page(
        rules,
        BrowseDocument.ruleType,
        '/browse/$page/',
        (outcome, errors) =>
            BrowseDocument.fromOutcome(outcome, errors: errors),
      )).submissions;

  Future<List<SubmissionPreview>> inbox({int after = 0}) async =>
      (await client.page(
        rules,
        InboxDocument.ruleType,
        after == 0
            ? '/msg/submissions/'
            : '/msg/submissions/new~$after@$inboxPageSize/',
        (outcome, errors) => InboxDocument.fromOutcome(outcome, errors: errors),
      )).submissions;

  Future<GalleryPage> gallery(GallerySource source, {int page = 1}) async {
    final GalleryDocument document = await client.page(
      rules,
      GalleryDocument.ruleType,
      source.path(page),
      (outcome, errors) => GalleryDocument.fromOutcome(outcome, errors: errors),
    );
    return GalleryPage(
      submissions: document.submissions,
      folders: [
        for (final FolderRow row in document.folders) ?row.within(source),
      ],
    );
  }

  Future<List<Favorite>> favorites(String user, {int after = 0}) async =>
      (await client.page(
        rules,
        FavoritesDocument.ruleType,
        after == 0 ? '/favorites/$user/' : '/favorites/$user/$after/next',
        (outcome, errors) =>
            FavoritesDocument.fromOutcome(outcome, errors: errors),
      )).favorites;

  Future<List<SubmissionPreview>> search(
    Map<String, String> parameters,
  ) async => (await client.page(
    rules,
    SearchDocument.ruleType,
    Uri(path: '/search/', queryParameters: parameters).toString(),
    (outcome, errors) => SearchDocument.fromOutcome(outcome, errors: errors),
  )).submissions;

  Future<SubmissionDocument> submission(int id) => client.page(
    rules,
    SubmissionDocument.ruleType,
    '/view/$id/',
    (outcome, errors) =>
        SubmissionDocument.fromOutcome(outcome, errors: errors),
  );

  Future<SubmissionDocument> favourite(String link) => client.page(
    rules,
    SubmissionDocument.ruleType,
    link,
    (outcome, errors) =>
        SubmissionDocument.fromOutcome(outcome, errors: errors),
  );
}
