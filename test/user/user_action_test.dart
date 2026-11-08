import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:furlovin/user/user.dart';
import 'package:html/parser.dart' as html;

import '../_support/documents.dart';

const String _loggedOut = 'href="/watch/fennel-v0578/?key="';

String _profile(String href) =>
    fixture('user_full').replaceFirst(_loggedOut, 'href="$href"');

String _withBlock(
  String href, {
  String watch = '/watch/fennel-v0578/?key=w1',
}) => _profile(watch).replaceFirst(
  '</userpage-nav-interface-buttons>',
  '<a class="button" id="block-button" href="$href">Block</a></userpage-nav-interface-buttons>',
);

class _Site implements HttpClientAdapter {
  _Site({required this.page, required this.answer});

  final String page;
  final Future<String> Function() answer;
  final List<Map<String, String>> posted = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (options.method == 'POST') {
      final String body = options.data is Map
          ? Uri(queryParameters: (options.data as Map).cast<String, String>())
                .query
          : utf8.decode(
              await (requestStream ?? const Stream<Uint8List>.empty())
                  .expand((e) => e)
                  .toList(),
            );
      posted.add(Uri.splitQueryString(body));
      return ResponseBody.fromString(await answer(), 200);
    }
    return ResponseBody.fromString(page, 200);
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late RuleSet rules;

  setUpAll(() => rules = loadRules());

  User read(String page) => UserDocument.fromOutcome(
    rules.parsePage(
      UserDocument.ruleType,
      html.parse(page),
      base: Uri.parse(faOrigin),
    ),
  )!.user;

  test(
    'reads whether the viewer watches the user and the key to change it',
    () {
      final User watching = read(_profile('/unwatch/fennel-v0578/?key=abc123'));
      expect(watching.watched, isTrue);
      expect(watching.watchKey, 'abc123');

      final User not = read(_profile('/watch/fennel-v0578/?key=def456'));
      expect(not.watched, isFalse);
      expect(not.watchKey, 'def456');
    },
  );

  test('a logged out profile offers no key', () {
    final User user = read(fixture('user_full'));
    expect(user.watched, isFalse);
    expect(user.watchKey, isNull);
  });

  test(
    'reads whether the viewer blocked the user and the key to change it',
    () {
      final User blocked = read(
        _withBlock('/unblock/fennel-v0578/?key=abc123'),
      );
      expect(blocked.blocked, isTrue);
      expect(blocked.blockKey, 'abc123');

      final User not = read(_withBlock('/block/fennel-v0578/?key=def456'));
      expect(not.blocked, isFalse);
      expect(not.blockKey, 'def456');
    },
  );

  test('reads the block button of a signed-in profile', () {
    final User member = read(fixture('user_member'));
    expect(member.blocked, isFalse);
    expect(member.blockKey, isNotEmpty);
    expect(member.watchKey, isNot(member.blockKey));
  });

  test('reads the answer to a user action', () {
    final UserActionAnswer watched = UserActionAnswer.parse(
      '{"success":true,"is_watched":true,"new_nonce":"n2"}',
      UserAction.watch,
    );
    expect(watched.active, isTrue);
    expect(watched.key, 'n2');

    final UserActionAnswer unblocked = UserActionAnswer.parse(
      '{"success":true,"is_blocked":false,"new_nonce":"n3"}',
      UserAction.block,
    );
    expect(unblocked.active, isFalse);
    expect(unblocked.key, 'n3');

    expect(
      () => UserActionAnswer.parse(
        '{"success":true,"is_watched":true,"new_nonce":"n2"}',
        UserAction.block,
      ),
      throwsFormatException,
    );
    expect(
      () => UserActionAnswer.parse(
        '{"success":false,"error":"Invalid key"}',
        UserAction.watch,
      ),
      throwsA(isA<ActionRejected>()),
    );
    expect(
      () => UserActionAnswer.parse('<html></html>', UserAction.watch),
      throwsFormatException,
    );
    expect(
      () =>
          UserActionAnswer.parse('{"error":"Rate limited"}', UserAction.block),
      throwsA(isA<RateLimited>()),
    );
  });

  group('watching from a profile', () {
    late _Site site;
    late ProviderContainer container;
    late Completer<String> answer;

    Future<void> host() async {
      answer = Completer<String>();
      site = _Site(
        page: _profile('/watch/fennel-v0578/?key=first'),
        answer: () => answer.future,
      );
      final FaClient client = FaClient()..dio.httpClientAdapter = site;
      container = ProviderContainer.test(
        overrides: [
          sessionKeyProvider.overrideWithValue('member'),
          userClientProvider.overrideWith(
            (ref) => UserClient(client: client, rules: rules),
          ),
        ],
      );
      container.listen(userProvider('fennel-v0578'), (previous, next) {});
      await container.read(userProvider('fennel-v0578').future);
    }

    User shown() => container.read(userProvider('fennel-v0578')).value!.user;

    test('shows the watch at once and keeps the answer', () async {
      await host();
      final int watchers = shown().watchedBy!;

      final Future<void> watching = container
          .read(userProvider('fennel-v0578').notifier)
          .setWatched(true);
      expect(shown().watched, isTrue);
      expect(shown().watchedBy, watchers + 1);

      answer.complete(
        '{"success":true,"is_watched":true,"new_nonce":"second"}',
      );
      await watching;

      expect(site.posted.single, {
        'action': 'watch',
        'key': 'first',
        'format': 'json',
      });
      expect(shown().watched, isTrue);
      expect(shown().watchKey, 'second');
      expect(shown().watchedBy, watchers + 1);
    });

    test('a refused watch rolls the profile back', () async {
      await host();
      final int watchers = shown().watchedBy!;

      final Future<void> watching = container
          .read(userProvider('fennel-v0578').notifier)
          .setWatched(true);
      answer.complete('{"success":false,"error":"Invalid key"}');

      await expectLater(watching, throwsA(isA<ActionRejected>()));
      expect(shown().watched, isFalse);
      expect(shown().watchedBy, watchers);
    });
  });

  group('blocking from a profile', () {
    late _Site site;
    late ProviderContainer container;
    late int viewerLoads;
    late int settingsLoads;

    Future<void> host(String href, String reply) async {
      viewerLoads = 0;
      settingsLoads = 0;
      site = _Site(page: _withBlock(href), answer: () async => reply);
      final FaClient client = FaClient()..dio.httpClientAdapter = site;
      container = ProviderContainer.test(
        overrides: [
          sessionKeyProvider.overrideWithValue('member'),
          userClientProvider.overrideWith(
            (ref) => UserClient(client: client, rules: rules),
          ),
          viewerProvider.overrideWith((ref) async {
            viewerLoads++;
            return const Viewer(name: 'mossbadger');
          }),
          profileSettingsProvider.overrideWith((ref) async {
            settingsLoads++;
            return const ProfileSettingsDocument(blockedUsers: '');
          }),
        ],
      );
      container.listen(userProvider('fennel-v0578'), (previous, next) {});
      container
        ..listen(viewerProvider, (previous, next) {})
        ..listen(profileSettingsProvider, (previous, next) {});
      await container.read(profileSettingsProvider.future);
      await container.read(userProvider('fennel-v0578').future);
      await container.read(viewerProvider.future);
    }

    UserDetail detail() =>
        container.read(userProvider('fennel-v0578').notifier);

    User shown() => container.read(userProvider('fennel-v0578')).value!.user;

    test(
      'sends the block, keeps the new key and reloads the blocklist',
      () async {
        await host(
          '/block/fennel-v0578/?key=first',
          '{"success":true,"is_blocked":true,"new_nonce":"second"}',
        );
        await detail().setBlocked(true);

        expect(site.posted.single, {
          'action': 'block',
          'key': 'first',
          'format': 'json',
        });
        expect(shown().blocked, isTrue);
        expect(shown().blockKey, 'second');
        await container.read(viewerProvider.future);
        expect(viewerLoads, 2);
        await container.read(profileSettingsProvider.future);
        expect(settingsLoads, 2);
      },
    );

    test('unblocking sends the unblock action', () async {
      await host(
        '/unblock/fennel-v0578/?key=first',
        '{"success":true,"is_blocked":false,"new_nonce":"second"}',
      );
      await detail().setBlocked(false);

      expect(site.posted.single['action'], 'unblock');
      expect(shown().blocked, isFalse);
    });

    test(
      'a refused block keeps the profile and reloads the blocklist',
      () async {
        await host(
          '/block/fennel-v0578/?key=first',
          '{"success":false,"error":"Invalid key"}',
        );
        await expectLater(
          detail().setBlocked(true),
          throwsA(isA<ActionRejected>()),
        );

        expect(shown().blocked, isFalse);
        expect(shown().blockKey, 'first');
        await container.read(viewerProvider.future);
        expect(viewerLoads, 2);
      },
    );
  });
}
