import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:material_ui/material_ui.dart';

class HiddenBoundaries extends ChangeNotifier {
  final Set<String> _names = {};
  final Set<String> _paths = {};

  bool hides(String name) => _names.contains(name);

  void hide(String name) {
    if (_names.add(name)) notifyListeners();
  }

  String _key(DocumentErrors errors, FieldError issue) =>
      '${errors.type}:${issue.path}';

  bool covers(DocumentErrors errors, FieldError issue) =>
      _paths.contains(_key(errors, issue));

  List<FieldError> visible(DocumentErrors errors) => [
    for (final FieldError issue in errors.all)
      if (!covers(errors, issue)) issue,
  ];

  void hideAll(DocumentErrors errors, Iterable<FieldError> issues) {
    final int before = _paths.length;
    _paths.addAll([for (final FieldError issue in issues) _key(errors, issue)]);
    if (_paths.length != before) notifyListeners();
  }
}

final Provider<HiddenBoundaries> hiddenBoundariesProvider =
    Provider<HiddenBoundaries>((ref) {
      final HiddenBoundaries hidden = HiddenBoundaries();
      ref.onDispose(hidden.dispose);
      return hidden;
    });

@immutable
class Breakage {
  const Breakage({
    required this.name,
    required this.errors,
    required this.issues,
  });

  final String name;
  final DocumentErrors errors;
  final List<FieldError> issues;

  Breakage? at(String path) {
    final List<FieldError> only = [
      for (final FieldError issue in issues)
        if (issue.within(path)) issue,
    ];
    return only.isEmpty
        ? null
        : Breakage(name: name, errors: errors, issues: only);
  }

  FieldError get worst =>
      issues.reduce((a, b) => a.kind.index <= b.kind.index ? a : b);

  Future<void> show(BuildContext context) => showDocumentErrors(
    context,
    errors,
    issues: issues,
    onHide: (hidden) => hidden.hide(name),
  );
}

class ErrorBoundary extends ConsumerWidget {
  const ErrorBoundary({
    super.key,
    required this.errors,
    required this.name,
    required this.paths,
    required this.builder,
  });

  final DocumentErrors? errors;
  final String name;
  final List<String> paths;
  final Widget Function(BuildContext context, Breakage? broken) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final HiddenBoundaries hidden = ref.watch(hiddenBoundariesProvider);
    return ListenableBuilder(
      listenable: hidden,
      builder: (context, _) {
        final DocumentErrors? known = errors;
        final List<FieldError> issues = known == null || hidden.hides(name)
            ? const []
            : [
                for (final FieldError issue in hidden.visible(known))
                  if (paths.any(issue.within)) issue,
              ];
        return builder(
          context,
          issues.isEmpty
              ? null
              : Breakage(name: name, errors: known!, issues: issues),
        );
      },
    );
  }
}

class BreakageCard extends StatelessWidget {
  const BreakageCard({super.key, required this.broken, required this.name});

  final Breakage broken;
  final String name;

  String get _message => switch (broken.worst) {
    FieldError(kind: FieldErrorKind.unreadable) => "Couldn't read $name",
    FieldError(kind: FieldErrorKind.dropped, :final count, :final of?) =>
      "Couldn't read $count of $of $name",
    _ => "Parts of $name couldn't be read",
  };

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(
        Space.snug,
        Space.small,
        Space.tight,
        Space.small,
      ),
      decoration: BoxDecoration(
        borderRadius: Corner.cards,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        spacing: Space.snug,
        children: [
          Icon(broken.worst.icon, size: 20, color: theme.colorScheme.error),
          Expanded(child: Text(_message, style: theme.textTheme.bodyMedium)),
          TextButton(
            onPressed: () => broken.show(context),
            child: const Text('Details'),
          ),
        ],
      ),
    );
  }
}

class BreakageSliver extends StatelessWidget {
  const BreakageSliver({
    super.key,
    required this.broken,
    required this.name,
    required this.sliver,
  });

  final Breakage? broken;
  final String name;
  final Widget sliver;

  @override
  Widget build(BuildContext context) => switch (broken) {
    null => sliver,
    final Breakage known => SliverMainAxisGroup(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.only(bottom: Space.medium),
          sliver: SliverToBoxAdapter(
            child: BreakageCard(broken: known, name: name),
          ),
        ),
        sliver,
      ],
    ),
  };
}

class BreakageMark extends StatelessWidget {
  const BreakageMark({super.key, required this.broken, required this.child});

  final Breakage broken;
  final Widget child;

  @override
  Widget build(BuildContext context) => Material(
    type: MaterialType.transparency,
    child: InkWell(
      borderRadius: Corner.panels,
      onTap: () => broken.show(context),
      child: child,
    ),
  );
}
