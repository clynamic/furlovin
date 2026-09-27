import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/routing/routing.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:furlovin/submission/submission.dart';
import 'package:furlovin/user/user.dart';
import 'package:material_ui/material_ui.dart';

class MePage extends ConsumerWidget {
  const MePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool authenticated = ref.watch(authenticatedProvider);
    final AsyncValue<Viewer?> viewer = ref.watch(viewerProvider);

    if (!authenticated) return const GuestPage();

    if (viewer.asData?.value case final Viewer known) {
      return UserPage(name: known.name, onSettings: context.openSettings);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('You')),
      body: viewer.hasError
          ? failureFor(
              viewer.error!,
              onRetry: () => ref.invalidate(viewerProvider),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class GuestPage extends ConsumerWidget {
  const GuestPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final String? banner = ref.watch(siteBannerProvider);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 190,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                tooltip: 'Settings',
                onPressed: context.openSettings,
                icon: const Icon(
                  Icons.settings_outlined,
                  color: Colors.white,
                  shadows: [Shadow(color: scrimShadow, blurRadius: 10)],
                ),
              ),
            ],
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: ProfileBanner(url: banner),
            ),
          ),
          SliverPadding(
            padding:
                Layout.textOf(context) +
                const EdgeInsets.only(top: Space.medium),
            sliver: SliverList.list(
              children: [
                Row(
                  spacing: 14,
                  children: [
                    const Avatar(url: null, size: 78),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Guest',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Not logged in',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: Space.large),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FilledButton.icon(
                    onPressed: context.openLogin,
                    icon: const Icon(Icons.login),
                    label: const Text('Log in to Fur Affinity'),
                  ),
                ),
                const SizedBox(height: Space.snug),
                Text(
                  'Log in to favourite submissions and watch users.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
