import 'package:furlovin/shared/shared.dart';
import 'package:material_ui/material_ui.dart';

const double choicePreviewMinWidth = 96;
const double choicePreviewMaxWidth = 128;
const double choicePreviewAspect = 3 / 4;
const int choiceSlots = 4;

class ChoiceStrip extends StatelessWidget {
  const ChoiceStrip({
    super.key,
    required this.children,
    this.alignment = MainAxisAlignment.start,
  });

  final List<Widget> children;
  final MainAxisAlignment alignment;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final double width =
          ((constraints.maxWidth -
                      Space.medium * 2 -
                      Space.small * (choiceSlots - 1)) /
                  choiceSlots)
              .clamp(choicePreviewMinWidth, choicePreviewMaxWidth);
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: Space.medium),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: constraints.maxWidth - Space.medium * 2,
          ),
          child: Row(
            mainAxisAlignment: alignment,
            spacing: Space.small,
            children: [
              for (final Widget child in children)
                SizedBox(width: width, child: child),
            ],
          ),
        ),
      );
    },
  );
}

class ChoiceTile extends StatelessWidget {
  const ChoiceTile({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.preview,
    this.aspect = choicePreviewAspect,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Widget preview;
  final double aspect;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: Corner.panels,
        child: Column(
          spacing: Space.tight,
          children: [
            AspectRatio(
              aspectRatio: aspect,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(borderRadius: Corner.panels),
                foregroundDecoration: BoxDecoration(
                  borderRadius: Corner.panels,
                  border: Border.all(
                    width: selected ? 2 : 1,
                    color: selected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outlineVariant,
                  ),
                ),
                child: preview,
              ),
            ),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: selected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
                fontWeight: selected ? FontWeight.w600 : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
