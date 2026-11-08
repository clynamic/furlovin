import 'dart:convert';
import 'dart:io';

import 'package:furlovin/parser/data/document.dart';

const String rulesPath = 'assets/rules/v1.yaml';

const String origin = 'https://www.furaffinity.net';

const String agent =
    'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 '
    '(KHTML, like Gecko) Chrome/140.0 Safari/537.36';

typedef Reference = ({String where, String script, List<String> mentions});

List<Reference> referencesIn(Map<String, Object?> rules) => [
  for (final MapEntry<String, Object?> type
      in ((rules['types'] as Map<String, Object?>?) ?? const {}).entries)
    for (final MapEntry<String, Object?> field
        in (((type.value! as Map<String, Object?>)['fields']
                    as Map<String, Object?>?) ??
                const {})
            .entries)
      if ((field.value! as Map<String, Object?>)['source'] case {
        'script': final String script,
        'mentions': final List<Object?> mentions,
      })
        (
          where: '${type.key}.${field.key}',
          script: script,
          mentions: mentions.cast<String>(),
        ),
];

List<String> missingFrom(String source, Reference reference) => [
  for (final String mention in reference.mentions)
    if (!source.contains(mention)) mention,
];

Future<String?> fetch(String script) async {
  final HttpClient client = HttpClient()..userAgent = agent;
  try {
    final HttpClientResponse response = await (await client.getUrl(
      Uri.parse('$origin$script'),
    )).close();
    if (response.statusCode != 200) {
      stderr.writeln('$script answered ${response.statusCode}');
      return null;
    }
    return await response.transform(utf8.decoder).join();
  } on IOException catch (error) {
    stderr.writeln('$script could not be fetched: $error');
    return null;
  } finally {
    client.close();
  }
}

Future<void> main() async {
  final List<Reference> references = referencesIn(
    decodeRules(File(rulesPath).readAsStringSync()),
  );
  final Map<String, String?> scripts = {};
  int drifted = 0;
  for (final Reference reference in references) {
    final String? source = scripts.containsKey(reference.script)
        ? scripts[reference.script]
        : scripts[reference.script] = await fetch(reference.script);
    if (source == null) {
      drifted++;
      stdout.writeln('unread  ${reference.where}  ${reference.script}');
      continue;
    }
    final List<String> missing = missingFrom(source, reference);
    if (missing.isEmpty) {
      stdout.writeln('holds   ${reference.where}  ${reference.script}');
      continue;
    }
    drifted++;
    stdout.writeln('drifted ${reference.where}  ${reference.script}');
    for (final String mention in missing) {
      stdout.writeln('        lost: $mention');
    }
  }
  stdout.writeln(
    '${references.length - drifted} of ${references.length} references hold',
  );
  exit(drifted == 0 ? 0 : 1);
}
