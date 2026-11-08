import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/routing/routing.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:material_ui/material_ui.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BlocklistSettings extends ConsumerStatefulWidget {
  const BlocklistSettings({super.key});

  @override
  ConsumerState<BlocklistSettings> createState() => _BlocklistSettingsState();
}

class _BlocklistSettingsState extends ConsumerState<BlocklistSettings> {
  final Set<String> busy = {};
  final TextEditingController entry = TextEditingController();
  bool adding = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) ref.invalidate(viewerProvider);
    });
  }

  @override
  void dispose() {
    entry.dispose();
    super.dispose();
  }

  Future<void> _set(String tag, {required bool blocked}) async {
    final String name = tag.trim();
    if (name.isEmpty || busy.contains(name)) return;
    setState(() => busy.add(name));
    try {
      await ref.read(blocklistProvider.notifier).setTag(name, blocked: blocked);
    } on Object catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(describeFailure(error)),
        ),
      );
    } finally {
      if (mounted) setState(() => busy.remove(name));
    }
  }

  void _confirm() {
    final String tag = entry.text;
    entry.clear();
    setState(() => adding = false);
    unawaited(_set(tag, blocked: true));
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Blocklist blocklist = ref.watch(blocklistProvider);
    final List<String> tags = blocklist.tags.toList()..sort();
    final AsyncValue<ProfileSettingsDocument> users = ref.watch(
      profileSettingsProvider,
    );
    final TextStyle? empty = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Space.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: Space.small,
          children: [
            Text('Blocked tags', style: theme.textTheme.labelLarge),
            ChipShelf(
              loading: !ref.watch(viewerProvider).hasValue,
              empty: 'No blocked tags',
              chips: [
                for (final String tag in tags)
                  InputChip(
                    label: Text(tag),
                    onDeleted: !blocklist.editable || busy.contains(tag)
                        ? null
                        : () => _set(tag, blocked: false),
                  ),
              ],
            ),
            if (blocklist.editable && adding)
              TextField(
                controller: entry,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Tag to block',
                  isDense: true,
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    tooltip: 'Block',
                    onPressed: _confirm,
                    icon: const Icon(Icons.check),
                  ),
                ),
                textInputAction: TextInputAction.done,
                onSubmitted: (value) => _confirm(),
              )
            else if (blocklist.editable)
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton.icon(
                  onPressed: () => setState(() => adding = true),
                  icon: const Icon(Icons.add),
                  label: const Text('Block a tag'),
                ),
              ),
            const SizedBox(height: Space.small),
            Text('Blocked users', style: theme.textTheme.labelLarge),
            switch (users) {
              AsyncError(:final Object error) when !users.hasValue => Text(
                describeFailure(error),
                style: empty,
              ),
              _ => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: Space.small,
                children: [
                  ChipShelf(
                    loading: !users.hasValue,
                    empty: 'No blocked users',
                    chips: [
                      for (final String name in [
                        if (users.value
                            case final ProfileSettingsDocument settings)
                          ...blockedNames(settings),
                      ])
                        ActionChip(
                          label: Text(name),
                          onPressed: () => context.openUser(
                            name.toLowerCase().replaceAll('_', ''),
                          ),
                        ),
                    ],
                  ),
                  Skeletonizer(
                    enabled: !users.hasValue,
                    child: Text(
                      (users.value?.hideBlockedContent ?? false)
                          ? 'You hide their posts outside their profile.'
                          : 'You see their posts outside their profile.',
                      style: empty,
                    ),
                  ),
                ],
              ),
            },
          ],
        ),
      ),
    );
  }
}

class ChipShelf extends StatefulWidget {
  const ChipShelf({
    super.key,
    required this.chips,
    required this.empty,
    this.loading = false,
  });

  final List<Widget> chips;
  final String empty;
  final bool loading;

  @override
  State<ChipShelf> createState() => _ChipShelfState();
}

class _ChipShelfState extends State<ChipShelf> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    if (widget.loading) {
      return Skeletonizer(
        child: PriorityRow(
          spacing: Space.small,
          overflow: const SizedBox.shrink(),
          children: [
            for (int at = 0; at < 3; at++) Chip(label: Text(BoneMock.name)),
          ],
        ),
      );
    }
    if (widget.chips.isEmpty) {
      return Stack(
        alignment: AlignmentDirectional.centerStart,
        children: [
          const Visibility(
            visible: false,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: Chip(label: Text('')),
          ),
          Text(
            widget.empty,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      );
    }
    if (expanded) {
      return Wrap(
        spacing: Space.small,
        runSpacing: Space.small,
        children: [
          ...widget.chips,
          ActionChip(
            label: const Text('Show fewer'),
            onPressed: () => setState(() => expanded = false),
          ),
        ],
      );
    }
    return PriorityRow(
      spacing: Space.small,
      overflow: ActionChip(
        label: Text('Show all ${widget.chips.length}'),
        onPressed: () => setState(() => expanded = true),
      ),
      children: widget.chips,
    );
  }
}
