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

  test('reads the answer to a watch request', () {
    final WatchAnswer answer = WatchAnswer.parse(
      '{"success":true,"is_watched":true,"new_nonce":"n2"}',
    );
    expect(answer.watched, isTrue);
    expect(answer.key, 'n2');

    expect(
      () => WatchAnswer.parse('{"success":false,"error":"Invalid key"}'),
      throwsA(isA<ActionRejected>()),
    );
    expect(() => WatchAnswer.parse('<html></html>'), throwsFormatException);
    expect(
      () => WatchAnswer.parse('{"error":"Rate limited"}'),
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
      container = ProviderContainer(
        overrides: [
          sessionKeyProvider.overrideWithValue('member'),
          userClientProvider.overrideWith(
            (ref) => UserClient(client: client, rules: rules),
          ),
        ],
      );
      addTearDown(container.dispose);
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
}
