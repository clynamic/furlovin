import 'dart:io';

import 'package:dio/dio.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as html;

import '../test/_support/documents.dart';

const String captureDir = 'test/_captures';

const String fixtureDir = 'test/_fixtures';

const int minBytes = 160;

const List<String> keepSelectors = ['#submission-options'];

final Uri base = Uri.parse(faOrigin);

String sourceFor(String name) {
  final File capture = File('$captureDir/$name.html');
  if (capture.existsSync()) return capture.readAsStringSync();
  return File('$fixtureDir/$name.html').readAsStringSync();
}

Object? Function() oracleFor(RuleSet rules, String? type, Document document) {
  if (type != null) {
    return () => rules.parsePage(type, document, base: base);
  }
  return () => classify(
    Response<Object?>(
      requestOptions: RequestOptions(path: '/'),
      statusCode: 200,
      data: document.outerHtml,
    ),
  ).runtimeType.toString();
}

class Reducer {
  Reducer({required this.document, required this.snapshot})
    : baseline = snapshot();

  final Document document;
  final Object? Function() snapshot;
  final Object? baseline;

  int trials = 0;
  int dropped = 0;

  bool holds() {
    trials++;
    return snapshot() == baseline;
  }

  void run() => _descend(document.documentElement!);

  late final Set<Element> _protected = _protect();

  Set<Element> _protect() {
    final Set<Element> out = {};
    for (final String selector in keepSelectors) {
      for (final Element match in document.querySelectorAll(selector)) {
        Element? at = match;
        while (at != null) {
          out.add(at);
          at = at.parent;
        }
      }
    }
    return out;
  }

  bool _guarded(Node node) => node is Element && _protected.contains(node);

  void _descend(Element node) {
    for (final Node child in List<Node>.from(node.nodes)) {
      final Node? parent = child.parent;
      if (parent == null) continue;
      if (_guarded(child)) {
        if (child is Element) _descend(child);
        continue;
      }
      final int index = parent.nodes.indexOf(child);
      child.remove();
      if (holds()) {
        dropped++;
        continue;
      }
      parent.nodes.insert(index, child);
      if (child is! Element) continue;
      if (child.outerHtml.length < minBytes) continue;
      _descend(child);
    }
  }
}

({int before, int after, int trials, int dropped}) reduceFixture(
  RuleSet rules,
  String name,
) {
  final String? type = fixturePages[name];
  final String source = sourceFor(name);
  final Document document = html.parse(source);
  final Reducer reducer = Reducer(
    document: document,
    snapshot: oracleFor(rules, type, document),
  )..run();

  final String output = document.outerHtml;
  final Document round = html.parse(output);
  final Object? again = oracleFor(rules, type, round)();
  if (again != reducer.baseline) {
    throw StateError('$name changed its parse after a round trip');
  }

  Directory(captureDir).createSync(recursive: true);
  File('$captureDir/$name.reduced.html').writeAsStringSync(output);
  return (
    before: source.length,
    after: output.length,
    trials: reducer.trials,
    dropped: reducer.dropped,
  );
}

void main() {
  final String only = Platform.environment['FIXTURE'] ?? 'all';
  final List<String> names = only == 'all'
      ? fixturePages.keys.toList()
      : only.split(',');

  final RuleSet rules = loadRules();
  for (final String name in names) {
    final Stopwatch watch = Stopwatch()..start();
    final ({int before, int after, int trials, int dropped}) result =
        reduceFixture(rules, name);
    watch.stop();
    final String pct = (100 * result.after / result.before).toStringAsFixed(1);
    stdout.writeln(
      '$name ${result.before} -> ${result.after} bytes ($pct%), '
      'dropped ${result.dropped} of ${result.trials} trials, '
      '${watch.elapsed.inSeconds}s',
    );
  }
}
