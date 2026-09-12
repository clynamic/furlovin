import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/client/client.dart';

void main() {
  group('isFaHost', () {
    test('accepts the apex and any subdomain', () {
      expect(isFaHost('furaffinity.net'), isTrue);
      expect(isFaHost('www.furaffinity.net'), isTrue);
      expect(isFaHost('d.furaffinity.net'), isTrue);
      expect(isFaHost('sfw.furaffinity.net'), isTrue);
      expect(isFaHost('anything.new.furaffinity.net'), isTrue);
    });

    test('is case insensitive', () {
      expect(isFaHost('WWW.FurAffinity.NET'), isTrue);
    });

    test('rejects lookalikes', () {
      expect(isFaHost('evilfuraffinity.net'), isFalse);
      expect(isFaHost('furaffinity.net.evil.com'), isFalse);
      expect(isFaHost('furaffinity.com'), isFalse);
      expect(isFaHost('notfuraffinity.net'), isFalse);
      expect(isFaHost(null), isFalse);
      expect(isFaHost(''), isFalse);
    });
  });

  group('Session', () {
    test('needs both session cookies', () {
      expect(const Session().isAuthenticated, isFalse);
      expect(const Session(cookies: {'a': 'x'}).isAuthenticated, isFalse);
      expect(
        const Session(cookies: {'a': 'x', 'b': 'y'}).isAuthenticated,
        isTrue,
      );
      expect(
        const Session(cookies: {'a': '', 'b': 'y'}).isAuthenticated,
        isFalse,
      );
    });

    test('reports what is missing', () {
      expect(const Session(cookies: {'a': 'x'}).missing, ['b']);
      expect(const Session().missing, ['a', 'b']);
    });

    test('renders a cookie header', () {
      expect(
        const Session(cookies: {'a': 'x', 'b': 'y'}).cookieHeader,
        'a=x; b=y',
      );
      expect(const Session().cookieHeader, isNull);
    });
  });
}
