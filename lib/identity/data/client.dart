import 'package:furlovin/client/client.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/parser/parser.dart';

const String controlsPath = '/controls/';

class ViewerClient {
  ViewerClient({required this.client, required this.rules});

  final FaClient client;
  final RuleSet rules;

  Future<Viewer?> viewer() async => (await client.page(
    rules,
    ControlsDocument.ruleType,
    controlsPath,
    (outcome, errors) => ControlsDocument.fromOutcome(outcome, errors: errors),
  )).viewer;
}
