import 'package:furlovin/client/client.dart';
import 'package:meta/meta.dart';

@immutable
class Session {
  const Session({this.cookies = const {}, this.userAgent});

  static const List<String> required = ['a', 'b'];

  static const List<String> withheld = ['sz'];

  final Map<String, String> cookies;
  final String? userAgent;

  bool get isAuthenticated =>
      required.every((name) => (cookies[name] ?? '').isNotEmpty);

  List<String> get missing =>
      required.where((name) => (cookies[name] ?? '').isEmpty).toList();

  String? get cookieHeader {
    final List<String> sent = [
      for (final MapEntry<String, String> cookie in cookies.entries)
        if (!withheld.contains(cookie.key)) '${cookie.key}=${cookie.value}',
    ];
    return sent.isEmpty ? null : sent.join('; ');
  }

  String get discriminator {
    if (cookies.isEmpty) return 'anonymous';
    return Object.hashAll([for (final String name in required) cookies[name]])
        .toRadixString(16);
  }

  Map<String, String> headersFor(String url) {
    final Uri? target = Uri.tryParse(url);
    if (target == null || !isFaHost(target.host)) return const {};
    return {
      if (cookieHeader case final String value) 'cookie': value,
      if (userAgent case final String value) 'user-agent': value,
    };
  }
}
