import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/parser/data/document.dart';

import '../tool/check_references.dart';

void main() {
  test('collects the script references the rules cite', () {
    final Map<String, Object?> rules = decodeRules('''
types:
  member:
    fields:
      name:
        read: [[{op: text}]]
      followKey:
        source:
          script: /js/follow.js
          mentions: ["post('/follow')", "body['nonce']"]
        read: [[{op: attr, name: href}]]
''');
    final Reference reference = referencesIn(rules).single;
    expect(reference.where, 'member.followKey');
    expect(reference.script, '/js/follow.js');
    expect(reference.mentions, ["post('/follow')", "body['nonce']"]);
  });

  test('names the mentions a script no longer carries', () {
    const Reference reference = (
      where: 'member.followKey',
      script: '/js/follow.js',
      mentions: ["post('/follow')", "body['nonce']"],
    );
    expect(missingFrom("fetch(x).then(() => post('/follow'))", reference), [
      "body['nonce']",
    ]);
  });
}
