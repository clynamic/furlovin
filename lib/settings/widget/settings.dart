import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/routing/routing.dart';
import 'package:furlovin/settings/settings.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:material_ui/material_ui.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  Future<void> _forget(BuildContext context, WidgetRef ref) async {
    final bool? sure = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Log out'),
          ),
        ],
      ),
    );
    if (sure != true) return;
    await logOut(ref);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final bool authenticated = ref.watch(authenticatedProvider);
    final Viewer? viewer = ref
        .watch(viewerProvider)
        .maybeWhen(data: (e) => e, orElse: () => null);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding:
            Layout.pageOf(context) + const EdgeInsets.only(top: Space.page),
        children: [
          Text(
            'Account',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: Space.small),
          Card(
            child: ListTile(
              leading: authenticated
                  ? Avatar(
                      url: viewer?.avatar,
                      name: viewer?.displayName ?? viewer?.name,
                      size: 40,
                    )
                  : Icon(
                      Icons.person_outline,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
              title: Text(
                authenticated
                    ? (viewer?.displayName ?? viewer?.name ?? 'Logged in')
                    : 'Not logged in',
              ),
              subtitle: Text(
                authenticated
                    ? (viewer?.name == null ? 'Logged in' : '@${viewer!.name}')
                    : 'You can continue browsing anonymously.',
              ),
              trailing: authenticated
                  ? TextButton(
                      onPressed: () => _forget(context, ref),
                      child: const Text('Log out'),
                    )
                  : FilledButton(
                      onPressed: () => context.openLogin(),
                      child: const Text('Log in'),
                    ),
            ),
          ),
          const SizedBox(height: Space.page),
          Text(
            'Appearance',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: Space.small),
          const AppearanceSettings(),
          const SizedBox(height: Space.page),
          Text(
            'Grid',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: Space.small),
          const TilesSettings(),
        ],
      ),
    );
  }
}
