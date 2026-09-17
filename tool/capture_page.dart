import 'dart:convert';
import 'dart:io';

const String captureDir = 'test/_captures';

const String agent =
    'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 '
    '(KHTML, like Gecko) Chrome/140.0 Safari/537.36';

const List<String> loggedIn = ['Log Out', 'logout-link', 'my-username'];

Never fail(String message) {
  stderr.writeln(message);
  exit(1);
}

Future<String> fetch(Uri url, Map<String, String> cookies) async {
  final HttpClient client = HttpClient()..userAgent = agent;
  try {
    final HttpClientRequest request = await client.getUrl(url);
    if (cookies.isNotEmpty) {
      request.headers.set(
        HttpHeaders.cookieHeader,
        cookies.entries.map((e) => '${e.key}=${e.value}').join('; '),
      );
    }
    final HttpClientResponse response = await request.close();
    if (response.statusCode != 200) {
      fail('$url answered ${response.statusCode}');
    }
    return await response.transform(utf8.decoder).join();
  } finally {
    client.close();
  }
}

Future<void> main(List<String> args) async {
  final List<String> positional = [];
  final Map<String, String> cookies = {};
  for (int i = 0; i < args.length; i++) {
    if (args[i] == '--cookie' && i + 1 < args.length) {
      final List<String> pair = args[++i].split('=');
      if (pair.length != 2) fail('a cookie reads as name=value');
      cookies[pair.first] = pair.last;
      continue;
    }
    positional.add(args[i]);
  }

  if (positional.length != 2) {
    fail('usage: capture_page.dart <url> <name> [--cookie name=value]');
  }

  final Uri url = Uri.parse(positional.first);
  final String name = positional.last;
  final String body = await fetch(url, cookies);

  for (final String marker in loggedIn) {
    if (body.contains(marker)) {
      fail(
        'the page came back signed in, which would capture a live session. '
        'Fetch it signed out.',
      );
    }
  }

  Directory(captureDir).createSync(recursive: true);
  final File target = File('$captureDir/$name.html');
  target.writeAsStringSync(body);
  stdout.writeln('${target.path} ${body.length} bytes');
}
