import 'package:furlovin/shared/data/data.dart';
import 'package:material_ui/material_ui.dart';

const String markAsset = 'assets/icon/monochrome.png';

class AppMark extends StatelessWidget {
  const AppMark({super.key, this.size = 48, this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final int pixels = (size * MediaQuery.devicePixelRatioOf(context)).round();
    return Image.asset(
      markAsset,
      width: size,
      height: size,
      cacheWidth: pixels,
      cacheHeight: pixels,
      color: color ?? Theme.of(context).colorScheme.onSurface,
    );
  }
}

class MarkPlate extends StatelessWidget {
  const MarkPlate({super.key, this.size = 52});

  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PlateShape(color: Theme.of(context).colorScheme.surface),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Space.small),
        child: AppMark(size: size),
      ),
    );
  }
}

class _PlateShape extends CustomPainter {
  const _PlateShape({required this.color});

  final Color color;

  static const double corner = Corner.large;
  static const double flare = Corner.large;

  @override
  void paint(Canvas canvas, Size size) {
    const Radius top = Radius.circular(corner);
    const Radius foot = Radius.circular(flare);
    final Path path = Path()
      ..moveTo(-flare, size.height)
      ..arcToPoint(
        Offset(0, size.height - flare),
        radius: foot,
        clockwise: false,
      )
      ..lineTo(0, corner)
      ..arcToPoint(const Offset(corner, 0), radius: top)
      ..lineTo(size.width - corner, 0)
      ..arcToPoint(Offset(size.width, corner), radius: top)
      ..lineTo(size.width, size.height - flare)
      ..arcToPoint(
        Offset(size.width + flare, size.height),
        radius: foot,
        clockwise: false,
      )
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_PlateShape old) => old.color != color;
}
