import 'dart:convert';
import 'dart:io';

import 'package:html/dom.dart';
import 'package:html/parser.dart' as html;

const String captureDir = 'test/_captures';

const String agent =
    'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 '
    '(KHTML, like Gecko) Chrome/140.0 Safari/537.36';

const List<String> loggedIn = ['Log Out', 'logout-link', 'my-username'];

const List<String> withheld = ['sz', 'cf_clearance'];

const int shortestSecret = 4;

String get sessionDatabase =>
    '${Platform.environment['HOME']}/Documents/furlovin.sqlite';

typedef StoredSession = ({Map<String, String> cookies, String? userAgent});

Never fail(String message) {
  stderr.writeln(message);
  exit(1);
}

Map<String, Object?>? latestRow(String database, String table) {
  const String order = 'order by updated_at desc, id desc limit 1';
  final ProcessResult result = Process.runSync('sqlite3', [
    '-json',
    database,
    'select cookies, user_agent from $table $order',
  ]);
  if (result.exitCode != 0) {
    fail('sqlite3 could not read $database: ${result.stderr}');
  }
  final String rows = (result.stdout as String).trim();
  if (rows.isEmpty) return null;
  return (jsonDecode(rows) as List<Object?>).cast<Map<String, Object?>>().first;
}

Map<String, String> cookiesOf(Map<String, Object?> row) =>
    (jsonDecode(row['cookies']! as String) as Map<String, Object?>)
        .cast<String, String>();

StoredSession storedSession(String database) {
  final Map<String, Object?> identity =
      latestRow(database, 'identities') ??
      fail('$database holds no session, so log in through the app first');
  final Map<String, Object?>? clearance = latestRow(database, 'clearances');
  return (
    cookies: {
      for (final MapEntry<String, String> cookie in cookiesOf(identity).entries)
        if (!withheld.contains(cookie.key)) cookie.key: cookie.value,
      if (clearance != null) ...cookiesOf(clearance),
    },
    userAgent: (clearance?['user_agent'] ?? identity['user_agent']) as String?,
  );
}

Set<String> secretsOf(String body, Map<String, String> cookies) {
  final Document document = html.parse(body);
  return {
    ...cookies.values,
    for (final RegExpMatch match in RegExp(r'key=(\w+)').allMatches(body))
      match.group(1)!,
    for (final Element input in document.querySelectorAll('input[name="key"]'))
      ?input.attributes['value'],
    for (final Element element in document.querySelectorAll('*'))
      for (final MapEntry<Object, String> attribute
          in element.attributes.entries)
        if (attribute.key.toString().endsWith('nonce')) attribute.value,
    ?document
        .querySelector('img.loggedin_user_avatar')
        ?.attributes['alt']
        ?.trim(),
    ?document
        .querySelector('a#my-username')
        ?.nodes
        .whereType<Text>()
        .map((e) => e.text)
        .join()
        .trim(),
  }.where((e) => e.length >= shortestSecret).toSet();
}

Future<String> fetch(
  Uri url,
  Map<String, String> cookies, {
  String? userAgent,
}) async {
  final HttpClient client = HttpClient()..userAgent = userAgent ?? agent;
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
  bool session = false;
  for (int i = 0; i < args.length; i++) {
    if (args[i] == '--cookie' && i + 1 < args.length) {
      final List<String> pair = args[++i].split('=');
      if (pair.length != 2) fail('a cookie reads as name=value');
      cookies[pair.first] = pair.last;
      continue;
    }
    if (args[i] == '--session') {
      session = true;
      continue;
    }
    positional.add(args[i]);
  }

  if (positional.length != 2) {
    fail(
      'usage: capture_page.dart <url> <name> '
      '[--cookie name=value] [--session]',
    );
  }

  final StoredSession? stored = session ? storedSession(sessionDatabase) : null;
  final Map<String, String> sent = {...?stored?.cookies, ...cookies};
  final Uri url = Uri.parse(positional.first);
  final String name = positional.last;
  final String body = await fetch(url, sent, userAgent: stored?.userAgent);

  final bool signedIn = loggedIn.any(body.contains);
  if (session && !signedIn) {
    fail('the page came back signed out, so the app session has lapsed');
  }
  if (!session && signedIn) {
    fail(
      'the page came back signed in, which would capture a live session. '
      'Fetch it signed out, or pass --session to capture it signed in.',
    );
  }

  Directory(captureDir).createSync(recursive: true);
  final File target = File('$captureDir/$name.html');
  target.writeAsStringSync(body);
  final File secretsFile = File('$captureDir/$name.secrets.json');
  if (session) {
    final Set<String> secrets = secretsOf(body, sent);
    secretsFile.writeAsStringSync(jsonEncode(secrets.toList()));
    stdout.writeln('${secrets.length} secrets noted for the sanitizer');
  } else if (secretsFile.existsSync()) {
    secretsFile.deleteSync();
  }
  stdout.writeln('${target.path} ${body.length} bytes');
}
