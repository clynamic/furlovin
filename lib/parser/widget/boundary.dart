import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:material_ui/material_ui.dart';

@immutable
class HiddenBoundaries {
  const HiddenBoundaries({this.names = const {}, this.paths = const {}});

  final Set<String> names;
  final Set<String> paths;

  bool hides(String name) => names.contains(name);

  static String _key(DocumentErrors errors, FieldError issue) =>
      '${errors.type}:${issue.path}';

  bool covers(DocumentErrors errors, FieldError issue) =>
      paths.contains(_key(errors, issue));

  List<FieldError> visible(DocumentErrors errors) => [
    for (final FieldError issue in errors.all)
      if (!covers(errors, issue)) issue,
  ];

  HiddenBoundaries hide(String name) => hides(name)
      ? this
      : HiddenBoundaries(names: {...names, name}, paths: paths);

  HiddenBoundaries hideAll(DocumentErrors errors, Iterable<FieldError> issues) {
    final Set<String> more = {
      ...paths,
      for (final FieldError issue in issues) _key(errors, issue),
    };
    return more.length == paths.length
        ? this
        : HiddenBoundaries(names: names, paths: more);
  }
}

final NotifierProvider<BoundaryHiding, HiddenBoundaries>
hiddenBoundariesProvider = NotifierProvider<BoundaryHiding, HiddenBoundaries>(
  BoundaryHiding.new,
);

class BoundaryHiding extends Notifier<HiddenBoundaries> {
  @override
  HiddenBoundaries build() => const HiddenBoundaries();

  void hide(String name) => state = state.hide(name);

  void hideAll(DocumentErrors errors, Iterable<FieldError> issues) =>
      state = state.hideAll(errors, issues);
}

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
    onHide: (hiding) => hiding.hide(name),
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
