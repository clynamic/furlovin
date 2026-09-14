import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/settings/settings.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:material_ui/material_ui.dart';

const double tilesPreviewMaxHeight = 360;

const List<double> tilesPreviewShapes = [
  0.75,
  1.33,
  0.9,
  1.25,
  0.8,
  0.95,
  0.7,
  1,
  0.8,
  0.66,
  1.25,
  0.75,
];

List<List<double>> stackTiles({
  required int columns,
  required TileShape shape,
  required double spacing,
  required double depth,
}) {
  final List<List<double>> stacks = [for (int i = 0; i < columns; i++) []];
  final List<double> heights = List.filled(columns, 0);
  int index = 0;
  while (heights.reduce(min) < depth) {
    final int shortest = heights.indexOf(heights.reduce(min));
    final double aspect = switch (shape) {
      TileShape.natural =>
        tilesPreviewShapes[index % tilesPreviewShapes.length],
      TileShape.even => evenTileAspectRatio,
    };
    stacks[shortest].add(aspect);
    heights[shortest] += 1 / aspect + spacing;
    index++;
  }
  return stacks;
}

class TilesSettings extends ConsumerStatefulWidget {
  const TilesSettings({super.key});

  @override
  ConsumerState<TilesSettings> createState() => _TilesSettingsState();
}

class _TilesSettingsState extends ConsumerState<TilesSettings> {
  double? _dragging;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Tiles stored = ref.watch(tilesProvider);
    final Tiles tiles = stored.copyWith(extent: _dragging);
    final PreferenceStore store = ref.read(preferenceStoreProvider);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Space.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Space.medium),
              child: TilesPreview(
                tiles: tiles,
                screen: MediaQuery.sizeOf(context),
              ),
            ),
            const SizedBox(height: Space.medium),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Space.medium),
              child: Text('Shape', style: theme.textTheme.labelLarge),
            ),
            const SizedBox(height: Space.small),
            ChoiceStrip(
              children: [
                for (final TileShape shape in TileShape.values)
                  ChoiceTile(
                    label: switch (shape) {
                      TileShape.natural => 'Natural',
                      TileShape.even => 'Even',
                    },
                    selected: tiles.shape == shape,
                    aspect: 1,
                    onTap: () => store.put(tileShapeKey, shape.name),
                    preview: TileShapePreview(
                      shape: shape,
                      selected: tiles.shape == shape,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: Space.medium),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Space.medium),
              child: Text('Size', style: theme.textTheme.labelLarge),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Space.medium),
              child: Row(
                children: [
                  Icon(
                    Icons.photo_size_select_small,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  Expanded(
                    child: Slider(
                      value: tiles.extent,
                      min: minTileExtent,
                      max: maxTileExtent,
                      divisions:
                          ((maxTileExtent - minTileExtent) / tileExtentStep)
                              .round(),
                      onChanged: (value) => setState(() => _dragging = value),
                      onChangeEnd: (value) async {
                        await store.put(tileExtentKey, '${value.round()}');
                        if (mounted) setState(() => _dragging = null);
                      },
                    ),
                  ),
                  Icon(
                    Icons.photo_size_select_large,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
            const SizedBox(height: Space.small),
            SwitchListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: Space.medium,
              ),
              value: tiles.captions,
              onChanged: (value) => store.put(tileCaptionsKey, '$value'),
              title: const Text('Titles and uploaders'),
              subtitle: const Text('Shown under each image.'),
            ),
          ],
        ),
      ),
    );
  }
}

class TileShapePreview extends StatelessWidget {
  const TileShapePreview({
    super.key,
    required this.shape,
    required this.selected,
  });

  final TileShape shape;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    const int columns = 3;
    return ColoredBox(
      color: colors.surfaceContainerLowest,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double width =
              (constraints.maxWidth - Space.tight * (columns - 1)) / columns;
          if (width <= 0) return const SizedBox.shrink();
          return ClipRect(
            child: OverflowBox(
              alignment: Alignment.topCenter,
              maxHeight: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: Space.tight,
                children: [
                  for (final List<double> stack in stackTiles(
                    columns: columns,
                    shape: shape,
                    spacing: Space.tight / width,
                    depth: constraints.maxHeight / width,
                  ))
                    Expanded(
                      child: Column(
                        spacing: Space.tight,
                        children: [
                          for (final double aspect in stack)
                            AspectRatio(
                              aspectRatio: aspect,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: selected
                                      ? colors.primary
                                      : colors.onSurfaceVariant,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class TilesPreview extends StatelessWidget {
  const TilesPreview({super.key, required this.tiles, required this.screen});

  final Tiles tiles;
  final Size screen;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: Corner.panels,
        border: Border.all(color: colors.outlineVariant),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double screenWidth = max(screen.width, 1);
          final double scale = constraints.maxWidth / screenWidth;
          final double height = min(
            screen.height * scale,
            tilesPreviewMaxHeight,
          );
          final double gap = Space.small * scale;
          final double usable = screenWidth - Space.small * 2;
          final int count = max(
            1,
            (usable / (tiles.extent + Space.small)).ceil(),
          );
          final double width =
              (constraints.maxWidth - gap * (count + 1)) / count;
          if (width <= 0) return const SizedBox.shrink();
          final double caption = tiles.captions ? 56 * scale : 0;
          final List<List<double>> columns = stackTiles(
            columns: count,
            shape: tiles.shape,
            spacing: (caption + gap) / width,
            depth: height / width,
          );
          return SizedBox(
            height: height,
            child: OverflowBox(
              alignment: Alignment.topCenter,
              maxHeight: double.infinity,
              child: Padding(
                padding: EdgeInsets.all(gap),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: gap,
                  children: [
                    for (final List<double> column in columns)
                      Expanded(
                        child: Column(
                          spacing: gap,
                          children: [
                            for (final double aspect in column)
                              TilesPreviewTile(
                                aspect: aspect,
                                caption: caption,
                                scale: scale,
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class TilesPreviewTile extends StatelessWidget {
  const TilesPreviewTile({
    super.key,
    required this.aspect,
    required this.caption,
    required this.scale,
  });

  final double aspect;
  final double caption;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    Widget bar(double width, Color color) => FractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: width,
      child: Container(
        height: max(3, 12 * scale),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: aspect,
            child: ColoredBox(color: colors.surfaceContainerHighest),
          ),
          if (caption > 0)
            SizedBox(
              height: caption,
              child: Padding(
                padding: EdgeInsets.all(8 * scale),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 6 * scale,
                  children: [
                    bar(0.85, colors.onSurface),
                    bar(0.5, colors.onSurfaceVariant),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
