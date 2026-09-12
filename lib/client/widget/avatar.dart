import 'package:furlovin/client/client.dart';
import 'package:material_ui/material_ui.dart';

class Avatar extends StatelessWidget {
  const Avatar({super.key, required this.url, this.name, this.size = 36});

  final String? url;
  final String? name;
  final double size;

  @override
  Widget build(BuildContext context) {
    final Widget fallback = AvatarFallback(name: name, size: size);
    return ClipOval(
      child: SizedBox.square(
        dimension: size,
        child: url == null
            ? fallback
            : FaImage(url: url!, placeholder: fallback),
      ),
    );
  }
}

class AvatarFallback extends StatelessWidget {
  const AvatarFallback({super.key, required this.name, required this.size});

  final String? name;
  final double size;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String initial = name == null || name!.isEmpty
        ? ''
        : name!.characters.first.toUpperCase();
    return ColoredBox(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Center(
        child: initial.isEmpty
            ? Icon(
                Icons.person_outline,
                size: size * 0.55,
                color: theme.colorScheme.onSurfaceVariant,
              )
            : Text(
                initial,
                style: TextStyle(
                  fontSize: size * 0.42,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
      ),
    );
  }
}
