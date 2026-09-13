import 'package:furlovin/client/client.dart';
import 'package:furlovin/logs/logs.dart';
import 'package:furlovin/parser/parser.dart';

extension FaClientPages on FaClient {
  Future<T> page<T>(
    RuleSet rules,
    String type,
    String path,
    T? Function(ParseOutcome outcome, ReadReport report) build,
  ) async {
    final String body = await get(path);
    final ParseOutcome outcome = await parseAway(
      ParseRequest(
        document: body,
        rules: rules.json,
        page: type,
        base: faOrigin,
      ),
    );
    final ReadReport report = ReadReport.forPage(
      url: Uri.parse(faOrigin).resolve(path).toString(),
      body: body,
      ruleSet: rules,
    )..collect(outcome, type, rules);
    final Logger scope = logger.child({'page': type, 'path': path});
    for (final ReadIssue issue in report.issues) {
      scope.warn('Read {slot} with an issue', {
        'slot': issue.slot,
        'issue': '$issue',
      });
    }
    final T? built = build(outcome, report);
    if (built == null) throw ParseFailure(type, outcome.failed);
    scope.debug('Read {page}');
    return built;
  }
}
