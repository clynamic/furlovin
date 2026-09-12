import 'dart:convert';

import 'package:html/dom.dart';

const String submissionDataId = 'js-submissionData';

final RegExp _sid = RegExp(r'sid[-_](\d+)');

void hydrate(Document document) {
  final Element? blob = document.querySelector('script#$submissionDataId');
  if (blob == null) return;
  final Map<String, Object?> known;
  try {
    final Object? decoded = jsonDecode(blob.text);
    if (decoded is! Map<String, Object?>) return;
    known = decoded;
  } on FormatException {
    return;
  }
  for (final Element figure in document.querySelectorAll('figure[id]')) {
    final RegExpMatch? id = _sid.firstMatch(figure.id);
    if (id == null) continue;
    final Object? entry = known[id.group(1)];
    if (entry is! Map<String, Object?>) continue;
    final Element? image = figure.querySelector('img');
    if (image == null) continue;
    if (entry['title'] case final String title when title.isNotEmpty) {
      image.attributes.putIfAbsent('title', () => title);
    }
    if (entry['username'] case final String username when username.isNotEmpty) {
      image.attributes.putIfAbsent('data-username', () => username);
    }
  }
}
