import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/settings/settings.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:material_ui/material_ui.dart';

class ToolbarSettings extends ConsumerWidget {
  const ToolbarSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final Hand hand = ref.watch(handProvider);
    final PreferenceStore store = ref.read(preferenceStoreProvider);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Space.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Space.medium),
              child: Text('Hand', style: theme.textTheme.labelLarge),
            ),
            const SizedBox(height: Space.small),
            ChoiceStrip(
              alignment: MainAxisAlignment.center,
              children: [
                for (final Hand choice in Hand.values)
                  ChoiceTile(
                    label: switch (choice) {
                      Hand.left => 'Left',
                      Hand.right => 'Right',
                    },
                    selected: hand == choice,
                    aspect: 1,
                    onTap: () => store.put(handKey, choice.name),
                    preview: HandPreview(
                      hand: choice,
                      selected: hand == choice,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HandPreview extends StatelessWidget {
  const HandPreview({super.key, required this.hand, required this.selected});

  final Hand hand;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return ColoredBox(
      color: colors.surfaceContainerLowest,
      child: Center(
        child: Transform.flip(
          flipX: hand == Hand.left,
          child: Icon(
            Icons.front_hand,
            size: 48,
            color: selected ? colors.primary : colors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
