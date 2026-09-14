import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/markup/markup.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:furlovin/routing/routing.dart';
import 'package:furlovin/settings/settings.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:furlovin/submission/submission.dart';
import 'package:furlovin/user/user.dart';
import 'package:material_ui/material_ui.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UserPage extends ConsumerWidget {
  const UserPage({super.key, required this.name, this.onSettings});

  final String name;
  final VoidCallback? onSettings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<UserDocument> detail = ref.watch(userProvider(name));

    if (detail case AsyncError(:final Object error)) {
      return Scaffold(
        appBar: AppBar(title: Text(name)),
        body: failureFor(
          error,
          onRetry: () => ref.invalidate(userProvider(name)),
          onLogin: ref.watch(authenticatedProvider) ? null : context.openLogin,
        ),
      );
    }

    final UserDocument? loaded = detail.value;
    final User? user = loaded?.user;
    final DocumentErrors? errors = loaded?.errors;

    return Scaffold(
      body: RevisitRefresh(
        edgeOffset: MediaQuery.paddingOf(context).top + kToolbarHeight,
        onRefresh: () async {
          ref.invalidate(userProvider(name));
          await ref
              .read(userProvider(name).future)
              .then<void>((_) {}, onError: (Object _) {});
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 190,
              automaticallyImplyLeading: onSettings == null,
              leading: onSettings == null ? const ScrimBackButton() : null,
              actions: [
                DocumentErrorsButton(errors: loaded?.errors, onImage: true),
                if (onSettings case final VoidCallback open)
                  IconButton(
                    tooltip: 'Settings',
                    onPressed: open,
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
                background: ProfileBanner(url: user?.banner),
              ),
            ),
            SliverPadding(
              padding:
                  Layout.textOf(context) +
                  const EdgeInsets.only(top: Space.medium),
              sliver: SliverList.list(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: Space.medium,
                    children: [
                      Expanded(
                        child: ProfileIdentity(user: user, fallback: name),
                      ),
                      if (user?.watched case final bool watched
                          when ref.watch(authenticatedProvider))
                        WatchButton(name: name, watched: watched),
                    ],
                  ),
                  const SizedBox(height: Space.medium),
                  Skeletonizer(
                    enabled: user == null,
                    child: ProfileCounts(user: user, errors: errors),
                  ),
                  const SizedBox(height: Space.large),
                  ErrorBoundary(
                    errors: errors,
                    name: 'user.profile',
                    paths: const ['user.profile'],
                    builder: (context, broken) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 22,
                      children: [
                        if (broken case final Breakage known)
                          BreakageCard(broken: known, name: 'the profile'),
                        if (user == null)
                          Skeletonizer(child: Text(BoneMock.paragraph))
                        else if (user.profile case final String profile)
                          MarkupBody(markup: profile),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ErrorBoundary(
              errors: errors,
              name: 'user.facts',
              paths: const ['facts'],
              builder: (context, broken) => switch (loaded?.facts) {
                final List<Fact> facts when facts.isNotEmpty =>
                  PersistentSliverSection(
                    name: 'facts',
                    title: 'About',
                    sliver: BreakageSliver(
                      broken: broken,
                      name: 'about',
                      sliver: SliverList.separated(
                        itemCount: facts.length,
                        itemBuilder: (context, index) =>
                            FactRow(fact: facts[index]),
                        separatorBuilder: (context, index) =>
                            facts[index].group == facts[index + 1].group
                            ? const SizedBox(height: Space.snug)
                            : const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: Space.snug,
                                ),
                                child: Divider(height: 1),
                              ),
                      ),
                    ),
                  ),
                _ => BrokenSection(
                  broken: broken,
                  name: 'facts',
                  title: 'About',
                ),
              },
            ),
            ErrorBoundary(
              errors: errors,
              name: 'user.contacts',
              paths: const ['contacts'],
              builder: (context, broken) => switch (loaded?.contacts) {
                final List<Contact> contacts when contacts.isNotEmpty =>
                  PersistentSliverSection(
                    name: 'contacts',
                    title: 'Elsewhere',
                    sliver: BreakageSliver(
                      broken: broken,
                      name: 'contacts',
                      sliver: SliverList.separated(
                        itemCount: contacts.length,
                        itemBuilder: (context, index) =>
                            ContactRow(contact: contacts[index]),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                      ),
                    ),
                  ),
                _ => BrokenSection(
                  broken: broken,
                  name: 'contacts',
                  title: 'Elsewhere',
                ),
              },
            ),
            ErrorBoundary(
              errors: errors,
              name: 'user.gallery',
              paths: const ['gallery'],
              builder: (context, broken) => switch (loaded?.gallery) {
                final List<SubmissionPreview> gallery when gallery.isNotEmpty =>
                  PersistentSliverSection(
                    name: 'userGallery',
                    title: 'Gallery',
                    count: user?.submissions,
                    action: TextButton.icon(
                      onPressed: () => context.openGallery(user?.name ?? name),
                      iconAlignment: IconAlignment.end,
                      icon: const Icon(Icons.arrow_forward, size: 16),
                      label: const Text('View gallery'),
                    ),
                    inset: const EdgeInsets.fromLTRB(
                      Space.medium,
                      Space.medium,
                      0,
                      Space.medium,
                    ),
                    sliver: BreakageSliver(
                      broken: broken,
                      name: 'the gallery',
                      sliver: SliverToBoxAdapter(
                        child: SubmissionStrip(submissions: gallery),
                      ),
                    ),
                  ),
                _ => BrokenSection(
                  broken: broken,
                  name: 'userGallery',
                  title: 'Gallery',
                ),
              },
            ),
            ErrorBoundary(
              errors: errors,
              name: 'user.favorites',
              paths: const ['favorites'],
              builder: (context, broken) => switch (loaded?.favorites) {
                final List<SubmissionPreview> favorites
                    when favorites.isNotEmpty =>
                  PersistentSliverSection(
                    name: 'userFavorites',
                    title: 'Favourites',
                    count: user?.favorites,
                    action: TextButton.icon(
                      onPressed: () =>
                          context.openFavorites(user?.name ?? name),
                      iconAlignment: IconAlignment.end,
                      icon: const Icon(Icons.arrow_forward, size: 16),
                      label: const Text('View favourites'),
                    ),
                    inset: const EdgeInsets.fromLTRB(
                      Space.medium,
                      Space.medium,
                      0,
                      Space.medium,
                    ),
                    sliver: BreakageSliver(
                      broken: broken,
                      name: 'favourites',
                      sliver: SliverToBoxAdapter(
                        child: SubmissionStrip(submissions: favorites),
                      ),
                    ),
                  ),
                _ => BrokenSection(
                  broken: broken,
                  name: 'userFavorites',
                  title: 'Favourites',
                ),
              },
            ),
            ErrorBoundary(
              errors: errors,
              name: 'user.shouts',
              paths: const ['shouts'],
              builder: (context, broken) => switch (loaded?.shouts) {
                final List<Shout> shouts when shouts.isNotEmpty =>
                  PersistentSliverSection(
                    name: 'shouts',
                    title: 'Shouts',
                    count: shouts.length,
                    sliver: BreakageSliver(
                      broken: broken,
                      name: 'shouts',
                      sliver: SliverList.separated(
                        itemCount: shouts.length,
                        itemBuilder: (context, index) =>
                            ShoutTile(shout: shouts[index]),
                        separatorBuilder: (context, index) => const Padding(
                          padding: EdgeInsets.symmetric(vertical: Space.medium),
                          child: Divider(height: 1),
                        ),
                      ),
                    ),
                  ),
                _ => BrokenSection(
                  broken: broken,
                  name: 'shouts',
                  title: 'Shouts',
                ),
              },
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }
}

class ProfileBanner extends StatelessWidget {
  const ProfileBanner({super.key, required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ColoredBox(
      color: theme.colorScheme.surfaceContainer,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (url case final String value) FaImage(url: value),
          const Align(alignment: Alignment.topCenter, child: TopScrim()),
        ],
      ),
    );
  }
}

class ProfileIdentity extends StatelessWidget {
  const ProfileIdentity({
    super.key,
    required this.user,
    required this.fallback,
  });

  final User? user;
  final String fallback;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String shown = user?.displayName ?? fallback;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 14,
      children: [
        Avatar(url: user?.avatar, name: shown, size: 78),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                shown,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '@${user?.name ?? fallback}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              if (user?.title case final String title) ...[
                const SizedBox(height: 8),
                Text(title, style: theme.textTheme.bodyMedium),
              ],
              if (user?.registered case final DateTime registered) ...[
                const SizedBox(height: 6),
                Text(
                  'Here since ${describeWhen(registered)}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class ProfileCounts extends StatelessWidget {
  const ProfileCounts({
    super.key,
    required this.user,
    this.errors,
    this.wide = false,
  });

  final User? user;
  final DocumentErrors? errors;
  final bool wide;

  @override
  Widget build(BuildContext context) => StatisticsRow(
    errors: errors,
    name: 'user.stats',
    loading: user == null,
    wide: wide,
    stats: [
      (
        icon: Icons.person_outline,
        value: user?.watchedBy,
        label: 'watchers',
        path: 'user.watchedBy',
      ),
      (
        icon: Icons.visibility_outlined,
        value: user?.views,
        label: 'views',
        path: 'user.views',
      ),
      (
        icon: Icons.image_outlined,
        value: user?.submissions,
        label: 'submissions',
        path: 'user.submissions',
      ),
      (
        icon: Icons.favorite_outline,
        value: user?.favorites,
        label: 'favourites',
        path: 'user.favorites',
      ),
    ],
  );
}

class ContactRow extends StatelessWidget {
  const ContactRow({super.key, required this.contact});

  final Contact contact;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String? link = contact.link;
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: Corner.cards,
        onTap: link == null
            ? () => copyContact(context, contact)
            : () => hand(link),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Space.small,
            vertical: Space.small,
          ),
          child: Row(
            spacing: 12,
            children: [
              SizedBox.square(
                dimension: 24,
                child: contact.icon == null
                    ? Icon(
                        Icons.link,
                        size: 24,
                        color: theme.colorScheme.onSurfaceVariant,
                      )
                    : FaImage(url: contact.icon!, fit: BoxFit.contain),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      contact.label ?? contact.kind,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      contact.value,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: link == null ? null : theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                switch (link) {
                  null => Icons.copy,
                  final String url when url.startsWith('mailto') =>
                    Icons.mail_outline,
                  _ => Icons.open_in_new,
                },
                size: 15,
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> copyContact(BuildContext context, Contact contact) async {
  await Clipboard.setData(ClipboardData(text: contact.value));
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text('Copied ${contact.label ?? contact.kind}'),
    ),
  );
}

class ShoutTile extends StatelessWidget {
  const ShoutTile({super.key, required this.shout});

  final Shout shout;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Poster(
          name: shout.author,
          child: Avatar(
            url: shout.authorAvatar,
            name: shout.authorName ?? shout.author,
            size: 30,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                spacing: 8,
                children: [
                  Flexible(
                    child: Poster(
                      name: shout.author,
                      child: Text(
                        shout.authorName ?? shout.author ?? 'unknown',
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  if (shout.posted case final DateTime posted)
                    Text(
                      describeWhen(posted),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 3),
              if (shout.body case final String body)
                MarkupBody(
                  markup: body,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.35),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class FactRow extends StatelessWidget {
  const FactRow({super.key, required this.fact});

  final Fact fact;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: Space.snug,
      children: [
        SizedBox(
          width: 150,
          child: Text(
            fact.label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: MarkupBody(
            markup: fact.value,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

class WatchButton extends ConsumerWidget {
  const WatchButton({super.key, required this.name, required this.watched});

  final String name;
  final bool watched;

  Future<void> _set(BuildContext context, WidgetRef ref, bool wanted) async {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    final UserDetail detail = ref.read(userProvider(name).notifier);
    if (!wanted) {
      messenger.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Unwatched $name'),
          persist: false,
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () => detail.setWatched(true),
          ),
        ),
      );
    }
    try {
      await detail.setWatched(wanted);
    } on Object catch (error) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(describeFailure(error)),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void toggle() => _set(context, ref, !watched);
    if (MediaQuery.sizeOf(context).width < Layout.compact) {
      return IconButton.filledTonal(
        isSelected: watched,
        tooltip: watched ? 'Watching' : 'Watch',
        onPressed: toggle,
        icon: const Icon(Icons.person_add_alt_1_outlined),
        selectedIcon: const Icon(Icons.how_to_reg),
      );
    }
    return watched
        ? OutlinedButton.icon(
            onPressed: toggle,
            icon: const Icon(Icons.how_to_reg),
            label: const Text('Watching'),
          )
        : FilledButton.tonalIcon(
            onPressed: toggle,
            icon: const Icon(Icons.person_add_alt_1_outlined),
            label: const Text('Watch'),
          );
  }
}
