import 'dart:isolate';

import 'package:furlovin/parser/parser.dart';
import 'package:html/parser.dart' as html;

class ParseRequest {
  const ParseRequest({
    required this.document,
    required this.rules,
    required this.page,
    required this.base,
  });

  final String document;
  final Map<String, Object?> rules;
  final String page;
  final String base;

  ParseOutcome run() =>
      RuleSet.fromJson(rules)
          .parsePage(page, html.parse(document), base: Uri.parse(base));
}

Future<ParseOutcome> parseAway(ParseRequest request) =>
    Isolate.run(request.run);

class ParseFailure implements Exception {
  const ParseFailure(this.entity, this.failed);

  final String entity;
  final Map<String, ParseException> failed;

  @override
  String toString() => 'Could not read $entity: ${failed.keys.join(', ')}';
}
