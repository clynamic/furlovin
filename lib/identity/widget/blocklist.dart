import 'dart:ui' as ui;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:material_ui/material_ui.dart';

const double blockedBlur = 18;

String describeBlock(List<BlockReason> reasons) {
  final List<String> tags = [
    for (final BlockReason reason in reasons)
      if (reason case BlockedTag(:final String tag)) tag,
  ];
  return [
    if (tags.isNotEmpty) 'Blocked tags: ${tags.join(', ')}',
    if (reasons.contains(const BlockedUser())) 'You blocked this user',
    if (reasons.contains(const BlockedTagless())) 'You hide untagged work',
  ].join('\n');
}

class BlockedBlur extends StatelessWidget {
  const BlockedBlur({super.key, required this.child, this.enabled = true});

  final Widget child;
  final bool enabled;

  @override
  Widget build(BuildContext context) => ClipRect(
    child: ImageFiltered(
      enabled: enabled,
      imageFilter: ui.ImageFilter.blur(
        sigmaX: blockedBlur,
        sigmaY: blockedBlur,
        tileMode: TileMode.decal,
      ),
      child: child,
    ),
  );
}

class BlockedCover extends ConsumerWidget {
  const BlockedCover({
    super.key,
    required this.filterTags,
    required this.child,
  });

  final String? filterTags;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool blocked = ref
        .watch(blocklistProvider)
        .reasonsFor(filterTags)
        .isNotEmpty;
    return Stack(
      fit: StackFit.passthrough,
      alignment: Alignment.center,
      children: [
        BlockedBlur(enabled: blocked, child: child),
        if (blocked)
          const Icon(
            Icons.block,
            color: Colors.white,
            size: 28,
            shadows: [Shadow(color: scrimShadow, blurRadius: 10)],
          ),
      ],
    );
  }
}

class BlockedNotice extends StatelessWidget {
  const BlockedNotice({super.key, required this.reasons, required this.onShow});

  final List<BlockReason> reasons;
  final VoidCallback onShow;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Space.page),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: Space.small,
          children: [
            const Icon(
              Icons.block,
              color: Colors.white,
              size: 40,
              shadows: [Shadow(color: scrimShadow, blurRadius: 10)],
            ),
            Text(
              describeBlock(reasons),
              textAlign: TextAlign.center,
              style: theme.textTheme.titleSmall?.copyWith(
                color: Colors.white,
                shadows: const [Shadow(color: scrimShadow, blurRadius: 10)],
              ),
            ),
            FilledButton.tonal(
              onPressed: onShow,
              child: const Text('Show anyway'),
            ),
          ],
        ),
      ),
    );
  }
}
