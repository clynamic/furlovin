import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:furlovin/settings/settings.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:material_ui/material_ui.dart';

const String sectionPrefix = 'section.';

class PersistentSliverSection extends ConsumerWidget {
  const PersistentSliverSection({
    super.key,
    required this.name,
    required this.title,
    required this.sliver,
    this.count,
    this.action,
    this.inset = const EdgeInsets.all(Space.medium),
    this.byDefault = true,
  });

  final String name;
  final String title;
  final Widget sliver;
  final int? count;
  final Widget? action;
  final EdgeInsets inset;
  final bool byDefault;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Map<String, String> preferences =
        ref.watch(preferencesProvider).asData?.value ?? const {};
    final bool expanded = switch (preferences['$sectionPrefix$name']) {
      'true' => true,
      'false' => false,
      _ => byDefault,
    };
    return SliverSection(
      title: title,
      count: count,
      expanded: expanded,
      action: action,
      inset: inset,
      onToggle: () => ref
          .read(preferenceStoreProvider)
          .put('$sectionPrefix$name', '${!expanded}'),
      sliver: sliver,
    );
  }
}

class BrokenSection extends StatelessWidget {
  const BrokenSection({
    super.key,
    required this.broken,
    required this.name,
    required this.title,
  });

  final Breakage? broken;
  final String name;
  final String title;

  @override
  Widget build(BuildContext context) => switch (broken) {
    null => const SliverToBoxAdapter(),
    final Breakage known => PersistentSliverSection(
      name: name,
      title: title,
      sliver: SliverToBoxAdapter(
        child: BreakageCard(broken: known, name: title.toLowerCase()),
      ),
    ),
  };
}
