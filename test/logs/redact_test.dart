import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/logs/logs.dart';

void main() {
  const LogRedactor redactor = LogRedactor();

  group('isSecret', () {
    test('matches whole secret tokens', () {
      expect(redactor.isSecret('cookie'), isTrue);
      expect(redactor.isSecret('key'), isTrue);
      expect(redactor.isSecret('password'), isTrue);
      expect(redactor.isSecret('session'), isTrue);
      expect(redactor.isSecret('authorization'), isTrue);
    });

    test('splits separators and camel case', () {
      expect(redactor.isSecret('auth_token'), isTrue);
      expect(redactor.isSecret('cookieHeader'), isTrue);
      expect(redactor.isSecret('apiKey'), isTrue);
      expect(redactor.isSecret('user-password'), isTrue);
      expect(redactor.isSecret('Set-Cookie'), isTrue);
    });

    test('matches simple plurals', () {
      expect(redactor.isSecret('cookies'), isTrue);
      expect(redactor.isSecret('tokens'), isTrue);
    });

    test('does not match words that merely start with a secret', () {
      expect(redactor.isSecret('author'), isFalse);
      expect(redactor.isSecret('authorName'), isFalse);
      expect(redactor.isSecret('authed'), isFalse);
      expect(redactor.isSecret('authority'), isFalse);
      expect(redactor.isSecret('keyboard'), isFalse);
      expect(redactor.isSecret('keywords'), isFalse);
      expect(redactor.isSecret('sessionless'), isFalse);
    });
  });

  group('redactUrl', () {
    test('scrubs secret query parameters', () {
      expect(
        redactor.redactUrl('https://www.furaffinity.net/watch/name/?key=abc'),
        contains('key=%5Bredacted%5D'),
      );
    });

    test('leaves other parameters alone', () {
      expect(
        redactor.redactUrl('https://www.furaffinity.net/search/?q=fox'),
        'https://www.furaffinity.net/search/?q=fox',
      );
    });
  });

  group('apply', () {
    test('redacts secret attributes and keeps the rest', () {
      final LogEntry entry = LogEntry(
        time: DateTime(2026),
        level: LogLevel.info,
        source: 'Test',
        event: 'Fetched',
        attributes: const {
          'cookie': 'a=1; b=2',
          'author': 'psycho-static',
          'authed': true,
          'nested': {'token': 'xyz', 'count': 3},
        },
      );
      final LogEntry redacted = redactor.apply(entry);
      expect(redacted.attributes['cookie'], '[redacted]');
      expect(redacted.attributes['author'], 'psycho-static');
      expect(redacted.attributes['authed'], isTrue);
      expect((redacted.attributes['nested']! as Map)['token'], '[redacted]');
      expect((redacted.attributes['nested']! as Map)['count'], 3);
    });
  });
}
