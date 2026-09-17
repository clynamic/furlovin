import 'dart:io';

import 'package:dio/dio.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as html;

import '../test/_support/documents.dart';

const String captureDir = 'test/_captures';

const String fixtureDir = 'test/_fixtures';

const Set<String> skipAttributes = {'style', 'width', 'height'};

bool linksSomewhere(String key) =>
    key == 'href' ||
    key == 'src' ||
    key == 'srcset' ||
    key == 'action' ||
    key.endsWith('-src') ||
    key.endsWith('-url');

const Set<String> structuralAttributes = {
  'class',
  'id',
  'rel',
  'type',
  'name',
  'method',
  'action',
  'target',
};

const List<String> nameWords = [
  'alder',
  'birch',
  'cedar',
  'dahlia',
  'elder',
  'fennel',
  'ginkgo',
  'hazel',
  'indigo',
  'juniper',
  'kelp',
  'larch',
  'mallow',
  'nettle',
  'olive',
  'poplar',
  'quince',
  'rowan',
  'sorrel',
  'tansy',
  'umber',
  'vervain',
  'willow',
  'yarrow',
  'amber',
  'bramble',
  'clover',
  'damson',
  'ember',
  'fallow',
  'gorse',
  'heath',
];

final Uri base = Uri.parse(faOrigin);

final RegExp _token = RegExp(r'%[0-9A-Fa-f]{2}|&[a-z]+;|[A-Za-z]{2,}|\d+');

const Set<String> urlVocabulary = {
  'https',
  'http',
  'www',
  'furaffinity',
  'net',
  'com',
  'org',
  'facdn',
  'static',
  'html',
  'php',
  'jpg',
  'jpeg',
  'png',
  'gif',
  'webp',
  'css',
  'js',
  'art',
  'music',
  'stories',
  'poetry',
  'journals',
  'commissions',
  'mailto',
  'themes',
  'beta',
  'img',
  'banners',
  'logo',
  'avatars',
  'data',
  'full',
  'mb',
  'kb',
  'gb',
  'px',
};

const Set<String> numberVocabulary = {
  '50',
  '75',
  '100',
  '120',
  '150',
  '160',
  '200',
  '300',
  '400',
  '600',
  '800',
  '1024',
  '1280',
  '1600',
};

const Set<String> selectorVocabulary = {
  'table',
  'row',
  'cell',
  'folders',
  'minigallery',
  'stats',
  'top',
  'userpage',
  'contact',
  'item',
  'section',
  'right',
  'left',
  'grouped',
  'loose',
  'empty',
  'profile',
};

const Set<String> serviceVocabulary = {
  'website',
  'email',
  'telegram',
  'discord',
  'steam',
  'youtube',
  'twitter',
  'tumblr',
  'facebook',
  'patreon',
  'picarto',
  'deviantart',
  'secondlife',
  'weasyl',
  'inkbunny',
  'sofurry',
  'furrynetwork',
  'twitch',
  'skype',
  'reddit',
  'mastodon',
  'bluesky',
  'artstation',
  'kofi',
  'itaku',
};

const Set<String> typeVocabulary = {
  ...serviceVocabulary,
  'png',
  'jpg',
  'jpeg',
  'gif',
  'webp',
  'swf',
  'mp3',
  'wav',
  'pdf',
  'txt',
  'rtf',
  'odt',
  'docx',
  'doc',
  'image',
  'audio',
  'text',
  'flash',
  'video',
  'general',
  'mature',
  'adult',
  'octet',
  'stream',
};

const Set<String> noticeVocabulary = {
  'pageid',
  'mature',
  'content',
  'error',
  'redirect',
  'message',
  'please',
  'log',
  'in',
};

const String roleSource = 'lib/markup/data/role.dart';

Set<String> literalVocabulary(String dartSource) => {
  for (final RegExpMatch m in RegExp("'([^']*)'").allMatches(dartSource))
    for (final RegExpMatch t in RegExp(r'[A-Za-z]{2,}').allMatches(m.group(1)!))
      t.group(0)!.toLowerCase(),
};

Set<String> structuralVocabulary(String rulesSource) => {
  ...urlVocabulary,
  ...noticeVocabulary,
  ...serviceVocabulary,
  ...selectorVocabulary,
  for (final RegExpMatch m in RegExp(r'[A-Za-z]{2,}').allMatches(rulesSource))
    m.group(0)!.toLowerCase(),
};

typedef Segment = ({String text, bool token, bool digits});

List<Segment> segment(String source) {
  final List<Segment> out = [];
  int at = 0;
  for (final RegExpMatch match in _token.allMatches(source)) {
    if (match.start > at) {
      out.add((
        text: source.substring(at, match.start),
        token: false,
        digits: false,
      ));
    }
    final String text = match.group(0)!;
    final bool escape = text.startsWith('%') || text.startsWith('&');
    out.add((
      text: text,
      token: !escape,
      digits: !escape && RegExp(r'^\d+$').hasMatch(text),
    ));
    at = match.end;
  }
  if (at < source.length) {
    out.add((text: source.substring(at), token: false, digits: false));
  }
  return out;
}

class Pseudonyms {
  final Map<String, String> _words = {};
  final Map<String, String> _numbers = {};
  final Set<String> _taken = {};

  String word(String source) => _words.putIfAbsent(source, () {
    final int seed = source.toLowerCase().hashCode.abs();
    for (int attempt = 0; ; attempt++) {
      final String pick = nameWords[(seed + attempt) % nameWords.length];
      final int round = attempt ~/ nameWords.length;
      final String candidate = round == 0 ? pick : '$pick$round';
      if (_taken.add(candidate)) return _match(source, candidate);
    }
  });

  String number(String source) => _numbers.putIfAbsent(source, () {
    final int seed = source.hashCode.abs();
    final StringBuffer out = StringBuffer()..write(source[0]);
    for (int i = 1; i < source.length; i++) {
      out.write(((seed >> (i * 3)) + i * 7) % 10);
    }
    return out.toString();
  });

  String of(Segment part) => part.digits ? number(part.text) : word(part.text);

  String _match(String source, String candidate) {
    if (source.length > 1 && source == source.toUpperCase()) {
      return candidate.toUpperCase();
    }
    if (source[0] == source[0].toUpperCase()) {
      return candidate[0].toUpperCase() + candidate.substring(1);
    }
    return candidate;
  }
}

Object? shapeOf(Object? value) => switch (value) {
  null => null,
  final bool flag => flag,
  final Enum symbol => symbol.name,
  final List<Object?> items => [
    for (final Object? item in items) shapeOf(item),
  ],
  final ParseOutcome outcome => {
    'values': {
      for (final MapEntry<String, Object?> e in outcome.values.entries)
        e.key: shapeOf(e.value),
    },
    'failed': outcome.failed.keys.toList()..sort(),
  },
  _ => value.runtimeType.toString(),
};

bool same(Object? a, Object? b) {
  if (a is Map && b is Map) {
    if (a.length != b.length) return false;
    for (final Object? key in a.keys) {
      if (!b.containsKey(key)) return false;
      if (!same(a[key], b[key])) return false;
    }
    return true;
  }
  if (a is List && b is List) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (!same(a[i], b[i])) return false;
    }
    return true;
  }
  return a == b;
}

Object? Function() oracleFor(RuleSet rules, String? type, Document document) {
  if (type != null) {
    return () => shapeOf(rules.parsePage(type, document, base: base));
  }
  return () => classify(
    Response<Object?>(
      requestOptions: RequestOptions(path: '/'),
      statusCode: 200,
      data: document.outerHtml,
    ),
  ).runtimeType.toString();
}

class Sanitizer {
  Sanitizer({
    required this.document,
    required this.vocabulary,
    required this.snapshot,
  }) : baseline = snapshot();

  final Document document;
  final Set<String> vocabulary;
  final Object? Function() snapshot;
  final Object? baseline;
  final Pseudonyms names = Pseudonyms();
  final Set<String> kept = {};

  int replaced = 0;
  int trials = 0;

  bool holds() {
    trials++;
    return same(snapshot(), baseline);
  }

  void run() {
    for (final Node node in _walk(document)) {
      if (node is Text) {
        if (node.text.trim().isEmpty) continue;
        _refine(node.text, false, const {}, (value) => node.text = value);
      } else if (node is Element) {
        for (final String key in List<String>.from(
          node.attributes.keys.cast<String>(),
        )) {
          if (skipAttributes.contains(key)) continue;
          final String value = node.attributes[key]!;
          if (value.isEmpty) continue;
          final bool wide =
              linksSomewhere(key) || structuralAttributes.contains(key);
          _refine(
            value,
            false,
            wide ? vocabulary : typeVocabulary,
            (next) => node.attributes[key] = next,
          );
        }
      }
    }
  }

  Iterable<Node> _walk(Node node) sync* {
    for (final Node child in List<Node>.from(node.nodes)) {
      yield child;
      yield* _walk(child);
    }
  }

  void _refine(
    String source,
    bool digitsOnly,
    Set<String> allowed,
    void Function(String) write,
  ) {
    final List<Segment> parts = segment(source);
    final List<bool> accepted = List<bool>.filled(parts.length, false);

    String build() {
      final StringBuffer out = StringBuffer();
      for (int i = 0; i < parts.length; i++) {
        out.write(accepted[i] ? names.of(parts[i]) : parts[i].text);
      }
      return out.toString();
    }

    for (int i = 0; i < parts.length; i++) {
      if (!parts[i].token) continue;
      if (digitsOnly && !parts[i].digits) continue;
      if (!parts[i].digits && allowed.contains(parts[i].text.toLowerCase())) {
        continue;
      }
      if (parts[i].digits && numberVocabulary.contains(parts[i].text)) continue;
      accepted[i] = true;
      write(build());
      if (holds()) {
        replaced++;
        continue;
      }
      accepted[i] = false;
      write(build());
      kept.add(parts[i].text);
    }
  }
}

void main() {
  final String only = Platform.environment['FIXTURE'] ?? 'all';
  final List<String> names = only == 'all'
      ? fixturePages.keys.toList()
      : only.split(',');

  final RuleSet rules = loadRules();
  final Set<String> vocabulary = {
    ...structuralVocabulary(File('assets/rules/v1.yaml').readAsStringSync()),
    ...literalVocabulary(File(roleSource).readAsStringSync()),
  };
  for (final String name in names) {
    final String? type = fixturePages[name];
    final File reduced = File('$captureDir/$name.reduced.html');
    if (!reduced.existsSync()) throw StateError('$name has no reduced source');

    final Stopwatch watch = Stopwatch()..start();
    final Document document = html.parse(reduced.readAsStringSync());
    final Sanitizer sanitizer = Sanitizer(
      document: document,
      vocabulary: vocabulary,
      snapshot: oracleFor(rules, type, document),
    )..run();
    watch.stop();

    final String output = document.outerHtml;
    final Object? again = oracleFor(rules, type, html.parse(output))();
    if (!same(again, sanitizer.baseline)) {
      throw StateError('$name changed its shape after a round trip');
    }

    File('$fixtureDir/$name.html').writeAsStringSync(output);
    final File allowed = File('$fixtureDir/$name.allowed.txt');
    if (sanitizer.kept.isEmpty) {
      if (allowed.existsSync()) allowed.deleteSync();
    } else {
      allowed.writeAsStringSync(
        '${(sanitizer.kept.toList()..sort()).join('\n')}\n',
      );
    }
    stdout.writeln(
      '$name replaced ${sanitizer.replaced}, kept ${sanitizer.kept.length} '
      'of ${sanitizer.trials} trials, ${watch.elapsed.inSeconds}s',
    );
  }
}
