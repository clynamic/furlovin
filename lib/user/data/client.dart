import 'package:furlovin/client/client.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:furlovin/user/user.dart';

class UserClient {
  UserClient({required this.client, required this.rules});

  final FaClient client;
  final RuleSet rules;

  Future<UserDocument> user(String name) => client.page(
    rules,
    UserDocument.ruleType,
    '/user/$name/',
    (outcome, report) => UserDocument.fromOutcome(outcome, report: report),
  );
}
