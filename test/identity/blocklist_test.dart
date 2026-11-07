import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:html/parser.dart' as html;

import '../_support/documents.dart';

void main() {
  late RuleSet rules;

  setUpAll(() => rules = loadRules());

  Viewer? read(String attributes) => ControlsDocument.fromOutcome(
    rules.parsePage(
      ControlsDocument.ruleType,
      html.parse(
        '<html><body $attributes><img class="loggedin_user_avatar" '
        'alt="mossbadger" src="/a.gif"></body></html>',
      ),
      base: Uri.parse(faOrigin),
    ),
  )?.viewer;

  test('reads the lists and the key from the page body', () {
    final Blocklist blocklist = Blocklist.of(
      read(
        'data-tag-blocklist="feet  toes" data-user-blocklist="Pine.Marten" '
        'data-tag-blocklist-hide-tagless="1" data-tag-blocklist-nonce="ab12"',
      )!,
    );
    expect(blocklist.tags, {'feet', 'toes'});
    expect(blocklist.users, {'u_pine_marten'});
    expect(blocklist.hideTagless, isTrue);
    expect(blocklist.editable, isTrue);
  });

  test('names each blocked keyword a submission carries', () {
    const Blocklist blocklist = Blocklist(tags: {'feet', 'toes'});
    expect(
      blocklist.reasonsFor('u_otter c_all t_all s_otter feet dragon toes'),
      [const BlockedTag('feet'), const BlockedTag('toes')],
    );
    expect(blocklist.reasonsFor('u_otter c_all t_all s_otter dragon'), isEmpty);
  });

  test('blocks every submission of a blocked uploader', () {
    final Blocklist blocklist = Blocklist(users: {userTag('Pine..Marten_')});
    expect(blocklist.reasonsFor('u_pine_marten c_all t_all s_otter dragon'), [
      const BlockedUser(),
    ]);
    expect(blocklist.reasonsFor('u_otter c_all t_all s_otter dragon'), isEmpty);
  });

  test('with hide tagless, blocks submissions carrying only meta tags', () {
    const Blocklist blocklist = Blocklist(hideTagless: true);
    expect(blocklist.reasonsFor('u_otter c_all t_all s_otter'), [
      const BlockedTagless(),
    ]);
    expect(blocklist.reasonsFor('u_otter c_all t_all s_otter dragon'), isEmpty);
  });

  test('reads the stored tag from a tag blocking answer', () {
    expect(
      parseTagBlockAnswer('{"success":true,"result":["feet"]}', tag: 'Feet'),
      ['feet'],
    );
    expect(parseTagBlockAnswer('{"success":1,"result":"feet"}', tag: 'Feet'), [
      'feet',
    ]);
    expect(parseTagBlockAnswer('{"success":"1"}', tag: 'feet'), ['feet']);
    expect(
      () => parseTagBlockAnswer(
        '{"error":"rate-limited","time-left":1.5}',
        tag: 'feet',
      ),
      throwsA(
        isA<RateLimited>().having(
          (e) => e.retryAfter,
          'retryAfter',
          const Duration(milliseconds: 1500),
        ),
      ),
    );
    expect(
      () => parseTagBlockAnswer('{"error":"invalid-tag"}', tag: 'feet'),
      throwsA(isA<ActionRejected>()),
    );
    expect(
      () => parseTagBlockAnswer(
        '{"success":false,"result":"Keyword already exists"}',
        tag: 'feet',
      ),
      throwsA(
        isA<ActionRejected>().having(
          (e) => e.reason,
          'reason',
          'Keyword already exists',
        ),
      ),
    );
  });
}
