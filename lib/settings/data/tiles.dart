import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/settings/settings.dart';
import 'package:material_ui/material_ui.dart';

enum TileShape { natural, even }

const String tileShapeKey = 'tiles.shape';
const String tileExtentKey = 'tiles.extent';
const String tileCaptionsKey = 'tiles.captions';

const double defaultTileExtent = 220;
const double minTileExtent = 100;
const double maxTileExtent = 400;
const double tileExtentStep = 20;

const double evenTileAspectRatio = 1 / 1.2;

@immutable
class Tiles {
  const Tiles({
    this.shape = TileShape.natural,
    this.extent = defaultTileExtent,
    this.captions = true,
  });

  final TileShape shape;
  final double extent;
  final bool captions;

  Tiles copyWith({TileShape? shape, double? extent, bool? captions}) => Tiles(
    shape: shape ?? this.shape,
    extent: extent ?? this.extent,
    captions: captions ?? this.captions,
  );

  @override
  bool operator ==(Object other) =>
      other is Tiles &&
      other.shape == shape &&
      other.extent == extent &&
      other.captions == captions;

  @override
  int get hashCode => Object.hash(shape, extent, captions);
}

final Provider<Tiles> tilesProvider = Provider<Tiles>((ref) {
  final Map<String, String> preferences =
      ref.watch(preferencesProvider).value ?? const {};
  final double? extent = double.tryParse(preferences[tileExtentKey] ?? '');
  return Tiles(
    shape:
        TileShape.values.asNameMap()[preferences[tileShapeKey]] ??
        TileShape.natural,
    extent: extent == null || !extent.isFinite
        ? defaultTileExtent
        : extent.clamp(minTileExtent, maxTileExtent),
    captions: preferences[tileCaptionsKey] != 'false',
  );
});
