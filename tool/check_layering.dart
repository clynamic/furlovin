import 'dart:io';

const Set<String> leafFeatures = {'logs', 'routing', 'shared'};

const String compositionRoot = 'app';

const String entrypoint = 'lib/main.dart';

const List<Set<String>> knownTangles = [
  {'client', 'database', 'identity', 'settings'},
  {'comment', 'search', 'submission', 'user'},
];

final RegExp _internalImport = RegExp(r"^import 'package:furlovin/(\w+)/");
final RegExp _generated = RegExp(r'\.(g|freezed|rules)\.dart$');

typedef Graph = Map<String, Set<String>>;

Iterable<File> sources() sync* {
  for (final FileSystemEntity entity in Directory(
    'lib',
  ).listSync(recursive: true)) {
    if (entity is! File) continue;
    if (!entity.path.endsWith('.dart')) continue;
    if (_generated.hasMatch(entity.path)) continue;
    yield entity;
  }
}

String featureOf(String path) => path.split(Platform.pathSeparator)[1];

Graph buildGraph() {
  final Graph graph = {};
  for (final File file in sources()) {
    final List<String> parts = file.path.split(Platform.pathSeparator);
    if (parts.length < 3) continue;
    final String feature = parts[1];
    final Set<String> out = graph.putIfAbsent(feature, () => <String>{});
    for (final String line in file.readAsLinesSync()) {
      final RegExpMatch? match = _internalImport.firstMatch(line);
      if (match == null) continue;
      if (match.group(1) != feature) out.add(match.group(1)!);
    }
  }
  return graph;
}

List<Set<String>> tanglesIn(Graph graph) {
  final Map<String, int> index = {};
  final Map<String, int> low = {};
  final List<String> stack = [];
  final Set<String> onStack = {};
  final List<Set<String>> found = [];
  int counter = 0;

  void visit(String node) {
    index[node] = low[node] = counter++;
    stack.add(node);
    onStack.add(node);
    for (final String next in graph[node] ?? const <String>{}) {
      if (!index.containsKey(next)) {
        visit(next);
        low[node] = low[node]! < low[next]! ? low[node]! : low[next]!;
      } else if (onStack.contains(next)) {
        low[node] = low[node]! < index[next]! ? low[node]! : index[next]!;
      }
    }
    if (low[node] != index[node]) return;
    final Set<String> group = {};
    while (true) {
      final String popped = stack.removeLast();
      onStack.remove(popped);
      group.add(popped);
      if (popped == node) break;
    }
    if (group.length > 1) found.add(group);
  }

  for (final String node in graph.keys.toList()..sort()) {
    if (!index.containsKey(node)) visit(node);
  }
  return found;
}

Map<int, List<Set<String>>> strata(Graph graph) {
  final List<Set<String>> groups = [
    ...tanglesIn(graph),
    for (final String node in graph.keys)
      if (!tanglesIn(graph).any((t) => t.contains(node))) {node},
  ];
  final Map<String, Set<String>> owner = {
    for (final Set<String> group in groups)
      for (final String node in group) node: group,
  };
  final Map<Set<String>, Set<Set<String>>> above = {
    for (final Set<String> group in groups)
      group: {
        for (final String node in group)
          for (final String out in graph[node] ?? const <String>{})
            if (owner[out] != null && owner[out] != group) owner[out]!,
      },
  };
  final Map<Set<String>, int> depth = {};
  int rank(Set<String> group) {
    if (depth.containsKey(group)) return depth[group]!;
    depth[group] = 0;
    final Set<Set<String>> outs = above[group] ?? {};
    depth[group] = outs.isEmpty
        ? 0
        : 1 + outs.map(rank).reduce((a, b) => a > b ? a : b);
    return depth[group]!;
  }

  final Map<int, List<Set<String>>> byLevel = {};
  for (final Set<String> group in groups) {
    byLevel.putIfAbsent(rank(group), () => []).add(group);
  }
  return byLevel;
}

void main() {
  final Graph graph = buildGraph();
  final List<String> problems = [];

  for (final String leaf in leafFeatures) {
    final Set<String> out = graph[leaf] ?? const {};
    if (out.isNotEmpty) {
      problems.add('$leaf must stay a leaf, but imports ${out.join(', ')}');
    }
  }

  for (final MapEntry<String, Set<String>> entry in graph.entries) {
    if (entry.key == compositionRoot) continue;
    if (entry.value.contains(compositionRoot)) {
      problems.add('${entry.key} imports $compositionRoot, which is the top');
    }
  }

  final List<String> climbers = [
    for (final File file in sources())
      if (featureOf(file.path) != compositionRoot &&
          file.path.replaceAll(Platform.pathSeparator, '/') != entrypoint &&
          file.readAsStringSync().contains(
            "import 'package:furlovin/$compositionRoot/",
          ))
        file.path,
  ];
  for (final String climber in climbers) {
    problems.add(
      '$climber reaches into $compositionRoot; only $entrypoint may',
    );
  }

  for (final Set<String> tangle in tanglesIn(graph)) {
    if (knownTangles.any((known) => known.containsAll(tangle))) continue;
    problems.add(
      'new dependency cycle between ${tangle.join(', ')}; '
      'break it or widen knownTangles deliberately',
    );
  }

  if (problems.isNotEmpty) {
    stderr.writeln('Feature layering broke:');
    for (final String problem in problems) {
      stderr.writeln('  $problem');
    }
    exitCode = 1;
    return;
  }

  final Map<int, List<Set<String>>> byLevel = strata(graph);
  stdout.writeln('Feature layering holds:');
  for (final int level in byLevel.keys.toList()..sort((a, b) => b - a)) {
    for (final Set<String> group in byLevel[level]!) {
      final List<String> sorted = group.toList()..sort();
      final String tangle = group.length > 1 ? '  (mutually dependent)' : '';
      stdout.writeln('  $level  ${sorted.join(', ')}$tangle');
    }
  }
}
