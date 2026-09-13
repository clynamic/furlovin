import 'package:furlovin/client/client.dart';
import 'package:furlovin/logs/logs.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:furlovin/user/user.dart';

class UserClient {
  UserClient({required this.client, required this.rules});

  final FaClient client;
  final RuleSet rules;

  final Logger logger = Logger('UserClient');

  Future<UserDetail> user(String name) async {
    final String body = await client.get('/user/$name/');
    final PageOutcome outcome = await parseAway(
      ParseRequest(
        document: body,
        rules: rules.json,
        page: UserSlots.profile.page,
        base: faOrigin,
      ),
    );
    final Logger scope = logger.child({'user': name});
    final ReadReport report = ReadReport();
    final User? parsed = outcome.read(
      UserSlots.profile,
      logger: scope,
      report: report,
    );
    if (parsed == null) {
      throw ParseFailure(
        UserSlots.profile.name,
        outcome.single[UserSlots.profile.name]?.failed ?? const {},
      );
    }
    return UserDetail(
      user: parsed,
      contacts: outcome.readAll(
        UserSlots.contacts,
        logger: scope,
        report: report,
      ),
      facts: outcome.readAll(UserSlots.facts, logger: scope, report: report),
      shouts: outcome.readAll(UserSlots.shouts, logger: scope, report: report),
      gallery: outcome.readAll(
        UserSlots.gallery,
        logger: scope,
        report: report,
      ),
      favorites: outcome.readAll(
        UserSlots.favorites,
        logger: scope,
        report: report,
      ),
      report: report,
    );
  }
}
