import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:html/parser.dart' as html;

import '../_support/documents.dart';

class _Account extends ViewerClient {
  _Account() : super(client: FaClient(), rules: loadRules());

  int loads = 0;

  @override
  Future<ProfileSettingsDocument> profileSettings() async {
    loads++;
    return const ProfileSettingsDocument(blockedUsers: 'pinemarten');
  }
}

void main() {
  late RuleSet rules;

  setUpAll(() => rules = loadRules());

  ProfileSettingsDocument read(String page) =>
      ProfileSettingsDocument.fromOutcome(
        rules.parsePage(
          ProfileSettingsDocument.ruleType,
          html.parse(page),
          base: Uri.parse(faOrigin),
        ),
      )!;

  test('reads every blocked user from the settings page', () {
    final ProfileSettingsDocument settings = read(fixture('profile_settings'));
    expect(blockedNames(settings), ['juniper0tansy', 'vervain']);
    expect(settings.hideBlockedContent, isFalse);
  });

  test('reads that FA hides blocked users\' posts when set to', () {
    final ProfileSettingsDocument settings = read('''
<html><body><form action="/controls/profile/">
  <select name="hide_blocked_user_content">
    <option value="0">Show Blocked User Content</option>
    <option value="1" selected>Hide Blocked User Content</option>
  </select>
  <textarea name="blocklist"></textarea>
</form></body></html>''');
    expect(settings.hideBlockedContent, isTrue);
    expect(blockedNames(settings), isEmpty);

    final ProfileSettingsDocument showing = read('''
<html><body><form action="/controls/profile/">
  <select name="hide_blocked_user_content">
    <option value="0" selected>Show Blocked User Content</option>
    <option value="1">Hide Blocked User Content</option>
  </select>
  <textarea name="blocklist"></textarea>
</form></body></html>''');
    expect(showing.hideBlockedContent, isFalse);
  });

  test('loads the blocked users once per session', () async {
    final _Account account = _Account();
    final ProviderContainer container = ProviderContainer.test(
      overrides: [
        sessionKeyProvider.overrideWithValue('member'),
        viewerClientProvider.overrideWith((ref) async => account),
      ],
    );
    container.listen(settledSessionProvider, (previous, next) {});
    await container.read(profileSettingsProvider.future);
    await Future<void>.delayed(Duration.zero);
    await container.read(profileSettingsProvider.future);
    expect(account.loads, 1);

    container.updateOverrides([
      sessionKeyProvider.overrideWithValue('someone else'),
      viewerClientProvider.overrideWith((ref) async => account),
    ]);
    await Future<void>.delayed(Duration.zero);
    await container.read(profileSettingsProvider.future);
    expect(account.loads, 2);
  });
}
