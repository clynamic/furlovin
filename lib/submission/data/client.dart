import 'package:furlovin/client/client.dart';
import 'package:furlovin/logs/logs.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:furlovin/submission/submission.dart';

class SubmissionClient {
  SubmissionClient({required this.client, required this.rules});

  final FaClient client;
  final RuleSet rules;

  final Logger logger = Logger('SubmissionClient');

  Future<List<SubmissionPreview>> browse({int page = 1}) =>
      _listing(BrowseSlots.submissions, '/browse/$page/');

  Future<List<SubmissionPreview>> gallery(String user, {int page = 1}) =>
      _listing(GallerySlots.submissions, '/gallery/$user/$page/');

  Future<List<SubmissionPreview>> search(Map<String, String> parameters) =>
      _listing(
        SearchSlots.submissions,
        Uri(path: '/search/', queryParameters: parameters).toString(),
      );

  Future<SubmissionDetail> submission(int id) async {
    final PageOutcome outcome = await _fetch(
      SubmissionSlots.submission.page,
      '/view/$id/',
    );
    final Logger scope = logger.child({'id': id});
    final Submission? parsed = outcome.read(
      SubmissionSlots.submission,
      logger: scope,
    );
    if (parsed == null) {
      throw ParseFailure(
        SubmissionSlots.submission.name,
        outcome.single[SubmissionSlots.submission.name]?.failed ?? const {},
      );
    }
    return SubmissionDetail(
      submission: parsed,
      comments: outcome.readAll(SubmissionSlots.comments, logger: scope),
      related: outcome.readAll(SubmissionSlots.related, logger: scope),
    );
  }

  Future<void> favourite(String link) async {
    logger.debug('Following {link}', {'link': link});
    await client.get(link);
  }

  Future<PageOutcome> _fetch(String page, String path) async {
    final String body = await client.get(path);
    return parseAway(
      ParseRequest(
        document: body,
        rules: rules.json,
        page: page,
        base: faOrigin,
      ),
    );
  }

  Future<List<T>> _listing<T>(ListSlot<T> slot, String path) async {
    final PageOutcome outcome = await _fetch(slot.page, path);
    return outcome.readAll(
      slot,
      logger: logger.child({'page': slot.page, 'path': path}),
    );
  }
}
