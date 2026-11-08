import 'package:furlovin/client/client.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/logs/logs.dart';
import 'package:furlovin/parser/parser.dart';

const String controlsPath = '/controls/';
const String logoutPath = '/logout/';
const String tagBlockingPath = '/route/tag_blocking';
const String ticketsPath = '/controls/troubletickets/';
const String profileSettingsPath = '/controls/profile/';

class ViewerClient {
  ViewerClient({required this.client, required this.rules});

  final FaClient client;
  final RuleSet rules;

  final Logger logger = Logger('ViewerClient');

  Future<Viewer?> viewer() async => (await client.page(
    rules,
    ControlsDocument.ruleType,
    controlsPath,
    (outcome, errors) => ControlsDocument.fromOutcome(outcome, errors: errors),
  )).viewer;

  Future<void> logOut(String key) => client.post(logoutPath, {'key': key});

  Future<ProfileSettingsDocument> profileSettings() => client.page(
    rules,
    ProfileSettingsDocument.ruleType,
    profileSettingsPath,
    (outcome, errors) =>
        ProfileSettingsDocument.fromOutcome(outcome, errors: errors),
  );

  Future<TicketDocument> ticket(String link) => client.page(
    rules,
    TicketDocument.ruleType,
    link,
    (outcome, errors) => TicketDocument.fromOutcome(outcome, errors: errors),
  );

  Future<void> fileTicket(FormRequest form) async {
    final FormAnswer answer = await client.submit(form);
    logger.debug('Ticket answered {status}', {
      'status': answer.status,
      'location': answer.location,
      'answer': excerpt(answer.body),
    });
  }

  Future<List<String>> setTagBlocked(
    String tag, {
    required bool blocked,
    required String key,
  }) async {
    final String body = await client.post(tagBlockingPath, {
      'action': blocked ? 'add-tag' : 'remove-tag',
      'key': key,
      'tag_name': tag,
    });
    logger.debug('Tag block answered {answer}', {'answer': body});
    return parseTagBlockAnswer(body, tag: tag);
  }
}
