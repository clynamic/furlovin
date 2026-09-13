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

  Future<List<SubmissionPreview>> browse({int page = 1}) =>
      _listing(BrowseSlots.submissions, '/browse/$page/');

  Future<List<SubmissionPreview>> inbox({int after = 0}) => _listing(
    SubmissionsSlots.submissions,
    after == 0
        ? '/msg/submissions/'
        : '/msg/submissions/new~$after@$inboxPageSize/',
  );

  Future<GalleryPage> gallery(GallerySource source, {int page = 1}) async {
    final String path = source.path(page);
    final (:PageOutcome outcome, :ReadReport report) = await _fetch(
      GallerySlots.submissions.page,
      path,
    );
    final Logger scope = logger.child({'page': 'gallery', 'path': path});
    return GalleryPage(
      submissions: outcome.readAll(GallerySlots.submissions, logger: scope),
      folders: [
        for (final FolderEntry entry in outcome.readAll(
          GallerySlots.folders,
          logger: scope,
        ))
          ?entry.within(source),
      ],
    );
  }

  Future<List<SubmissionPreview>> favorites(String user, {int after = 0}) =>
      _listing(
        FavoritesSlots.submissions,
        after == 0 ? '/favorites/$user/' : '/favorites/$user/$after/next',
      );

  Future<List<SubmissionPreview>> search(Map<String, String> parameters) =>
      _listing(
        SearchSlots.submissions,
        Uri(path: '/search/', queryParameters: parameters).toString(),
      );

  Future<SubmissionDetail> submission(int id) async {
    final (:PageOutcome outcome, :ReadReport report) = await _fetch(
      SubmissionSlots.submission.page,
      '/view/$id/',
    );
    final Logger scope = logger.child({'id': id});
    final Submission? parsed = outcome.read(
      SubmissionSlots.submission,
      logger: scope,
      report: report,
    );
    if (parsed == null) {
      throw ParseFailure(
        SubmissionSlots.submission.name,
        outcome.single[SubmissionSlots.submission.name]?.failed ?? const {},
      );
    }
    return SubmissionDetail(
      submission: parsed,
      comments: outcome.readAll(
        SubmissionSlots.comments,
        logger: scope,
        report: report,
      ),
      miniGallery: outcome.read(
        SubmissionSlots.miniGallery,
        logger: scope,
        report: report,
      ),
      newer: outcome.readAll(
        SubmissionSlots.newer,
        logger: scope,
        report: report,
      ),
      older: outcome.readAll(
        SubmissionSlots.older,
        logger: scope,
        report: report,
      ),
      folders: outcome.readAll(
        SubmissionSlots.folders,
        logger: scope,
        report: report,
      ),
      report: report,
    );
  }

  Future<void> favourite(String link) async {
    logger.debug('Following {link}', {'link': link});
    await client.get(link);
  }

  Future<({PageOutcome outcome, ReadReport report})> _fetch(
    String page,
    String path,
  ) async {
    final String body = await client.get(path);
    final PageOutcome outcome = await parseAway(
      ParseRequest(
        document: body,
        rules: rules.json,
        page: page,
        base: faOrigin,
      ),
    );
    return (
      outcome: outcome,
      report: ReadReport.forPage(
        url: Uri.parse(faOrigin).resolve(path).toString(),
        body: body,
        ruleSet: rules,
      ),
    );
  }

  Future<List<T>> _listing<T>(ListSlot<T> slot, String path) async {
    final (:PageOutcome outcome, :ReadReport report) = await _fetch(
      slot.page,
      path,
    );
    return outcome.readAll(
      report: report,
      slot,
      logger: logger.child({'page': slot.page, 'path': path}),
    );
  }
}
