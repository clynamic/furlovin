import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:html/parser.dart' as html;

import '../_support/documents.dart';

void main() {
  late RuleSet rules;

  setUpAll(() => rules = loadRules());

  Viewer? read(String body) => ControlsDocument.fromOutcome(
    rules.parsePage(
      ControlsDocument.ruleType,
      html.parse('<html><body>$body</body></html>'),
      base: Uri.parse(faOrigin),
    ),
  )?.viewer;

  test('reads the key the site logs out with', () {
    final Viewer? viewer = read(
      '<img class="loggedin_user_avatar" alt="binaryfloof" src="/a.gif"><form class="yarrow80-umber13 logout-link" willow65="yarrow80" ginkgo="/logout/"><button type="ember100">Log Out</button><input type="hidden" name="key" value="3fae"/></form>',
    );
    expect(viewer?.name, 'binaryfloof');
    expect(viewer?.logoutKey, '3fae');
  });

  test('a page without the log out form offers no key', () {
    final Viewer? viewer = read(
      '<img class="loggedin_user_avatar" alt="binaryfloof" src="/a.gif">',
    );
    expect(viewer?.logoutKey, isNull);
  });
}
