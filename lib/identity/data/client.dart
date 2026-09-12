import 'package:furlovin/client/client.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/logs/logs.dart';
import 'package:furlovin/parser/parser.dart';

const String controlsPath = '/controls/';

class ViewerClient {
  ViewerClient({required this.client, required this.rules});

  final FaClient client;
  final RuleSet rules;

  final Logger logger = Logger('ViewerClient');

  Future<Viewer?> viewer() async {
    final String body = await client.get(controlsPath);
    final PageOutcome outcome = await parseAway(
      ParseRequest(
        document: body,
        rules: rules.json,
        page: ControlsSlots.viewer.page,
        base: faOrigin,
      ),
    );
    return outcome.read(ControlsSlots.viewer, logger: logger);
  }
}
