import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/routing/routing.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:furlovin/user/user.dart';
import 'package:material_ui/material_ui.dart';

class MePage extends ConsumerWidget {
  const MePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool authenticated = ref.watch(authenticatedProvider);
    final AsyncValue<Viewer?> viewer = ref.watch(viewerProvider);

    if (!authenticated) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('You'),
          actions: [
            IconButton(
              tooltip: 'Settings',
              onPressed: context.openSettings,
              icon: const Icon(Icons.settings_outlined),
            ),
          ],
        ),
        body: FailureView(
          icon: Icons.person_outline,
          title: 'Not signed in',
          detail: 'Sign in to reach your gallery, favourites and watches.',
          actionLabel: 'Log in',
          onAction: context.openLogin,
        ),
      );
    }

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
