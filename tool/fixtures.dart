import 'dart:io';

const String usage = '''
usage: dart run tool/fixtures.dart <command> [names]

  capture <url> <name> [--cookie name=value]   fetch a page into test/_captures
  reduce [names]                               cut to what the rules reach
  sanitize [names]                             replace every real value
  rebuild [names]                              reduce, then sanitize
  check                                        run the fixture gate

Names are comma separated and default to every fixture. Set FLUTTER to pick
the flutter binary when the one on PATH is the wrong environment.''';

String get flutter => Platform.environment['FLUTTER'] ?? 'flutter';

Never fail(String message) {
  stderr.writeln(message);
  exit(1);
}

int run(String executable, List<String> args, {Map<String, String>? env}) {
  stdout.writeln('> $executable ${args.join(' ')}');
  final ProcessResult result = Process.runSync(
    executable,
    args,
    environment: env,
  );
  stdout.write(result.stdout);
  stderr.write(result.stderr);
  return result.exitCode;
}

int harness(String tool, String? names) =>
    run(flutter, ['test', 'tool/$tool.dart'], env: {'FIXTURE': ?names});

void main(List<String> args) {
  if (args.isEmpty) fail(usage);
  final String command = args.first;
  final List<String> rest = args.skip(1).toList();
  final String? names = rest.isEmpty || rest.first.startsWith('-')
      ? null
      : rest.first;

  switch (command) {
    case 'capture':
      if (rest.length < 2) fail(usage);
      exit(run('dart', ['run', 'tool/capture_page.dart', ...rest]));
    case 'reduce':
      exit(harness('reduce_page', names));
    case 'sanitize':
      exit(harness('sanitize_page', names));
    case 'rebuild':
      final int reduced = harness('reduce_page', names);
      if (reduced != 0) exit(reduced);
      exit(harness('sanitize_page', names));
    case 'check':
      exit(run(flutter, ['test', 'test/fixtures_gate_test.dart']));
    default:
      fail(usage);
  }
}
