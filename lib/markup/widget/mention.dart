import 'package:furlovin/client/client.dart';
import 'package:furlovin/routing/routing.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:material_ui/material_ui.dart';

const double mentionAvatarSize = 18;

class Mention extends StatelessWidget {
  const Mention({
    super.key,
    required this.name,
    required this.display,
    this.avatar,
  });

  final String name;
  final String? display;
  final String? avatar;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Semantics(
      label: name,
      child: InkWell(
        borderRadius: Corner.cards,
        onTap: () => context.openUser(name),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.hair),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: Space.tight,
            children: [
              Avatar(
                url: avatar,
                name: display ?? name,
                size: mentionAvatarSize,
              ),
              if (display case final String shown)
                Text(
                  shown,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
