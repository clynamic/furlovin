import 'package:flutter_test/flutter_test.dart';

import '../tool/capture_page.dart' as capture;
import '../tool/sanitize_page.dart' as sanitize;

void main() {
  test('notes the session, the page keys and the viewer names as secrets', () {
    const String page = '''
<html><body data-tag-blocklist-nonce="nonce5150">
  <a id="my-username" href="/user/mossbadger/">  Moss Badger <span>~</span></a>
  <img class="loggedin_user_avatar" alt="mossbadger" src="/a.png">
  <a id="watch-button" href="/watch/fennel/?key=watchkey77">Watch</a>
  <form><input type="hidden" name="key" value="formkey88"></form>
</body></html>''';
    expect(capture.secretsOf(page, {'a': 'cookie-a-value', 'b': 'bb'}), {
      'cookie-a-value',
      'nonce5150',
      'Moss Badger',
      'mossbadger',
      'watchkey77',
      'formkey88',
    });
  });

  test('finds a secret that survives in any letter case', () {
    expect(
      sanitize.leakedSecrets('<p>Moss MOSSBADGER</p>', [
        'mossbadger',
        'formkey88',
      ]),
      ['mossbadger'],
    );
  });
}
