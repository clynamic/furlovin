import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/markup/markup.dart';
import 'package:furlovin/routing/routing.dart';
import 'package:furlovin/settings/settings.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:furlovin/submission/submission.dart';
import 'package:furlovin/user/user.dart';
import 'package:material_ui/material_ui.dart';
import 'package:skeletonizer/skeletonizer.dart';

const double profileBannerHeight = 190;
const double profileAvatarSize = 78;
const double contactIconSize = 24;

class UserPage extends ConsumerWidget {
  const UserPage({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<UserDetail> detail = ref.watch(userProvider(name));

    if (detail case AsyncError(:final Object error)) {
      return Scaffold(
        appBar: AppBar(title: Text(name)),
        body: failureFor(
          error,
          onRetry: () => ref.invalidate(userProvider(name)),
        ),
      );
    }

    final UserDetail? loaded = detail.asData?.value;
    final User? user = loaded?.user;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: profileBannerHeight,
            leading: const ScrimBackButton(),
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
                SpreadRow(
                  leading: ProfileIdentity(user: user, fallback: name),
                  trailing: (wide) => Skeletonizer(
                    enabled: user == null,
                    child: ProfileCounts(user: user, wide: wide),
                  ),
                ),
                const SizedBox(height: Space.large),
                if (user == null)
                  Skeletonizer(child: Text(BoneMock.paragraph))
                else if (user.profile case final String profile)
                  MarkupBody(markup: profile),
              ],
            ),
          ),
          if (loaded?.facts case final List<Fact> facts when facts.isNotEmpty)
            PersistentSliverSection(
              name: 'facts',
              title: 'About',
              sliver: SliverList.separated(
                itemCount: facts.length,
                itemBuilder: (context, index) => FactRow(fact: facts[index]),
                separatorBuilder: (context, index) =>
                    facts[index].group == facts[index + 1].group
                    ? const SizedBox(height: Space.snug)
                    : const Padding(
                        padding: EdgeInsets.symmetric(vertical: Space.snug),
                        child: Divider(height: 1),
                      ),
              ),
            ),
          if (loaded?.contacts case final List<Contact> contacts
              when contacts.isNotEmpty)
            PersistentSliverSection(
              name: 'contacts',
              title: 'Elsewhere',
              sliver: SliverList.separated(
                itemCount: contacts.length,
                itemBuilder: (context, index) =>
                    ContactRow(contact: contacts[index]),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
              ),
            ),
          if (loaded?.gallery case final List<SubmissionPreview> gallery
              when gallery.isNotEmpty)
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
              sliver: SliverToBoxAdapter(
                child: SubmissionStrip(submissions: gallery),
              ),
            ),
          if (loaded?.favorites case final List<SubmissionPreview> favorites
              when favorites.isNotEmpty)
            PersistentSliverSection(
              name: 'userFavorites',
              title: 'Favourites',
              count: user?.favorites,
              action: TextButton.icon(
                onPressed: () => hand(
                  Uri.parse(faOrigin)
                      .resolve('/favorites/${user?.name ?? name}/')
                      .toString(),
                ),
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
              sliver: SliverToBoxAdapter(
                child: SubmissionStrip(submissions: favorites),
              ),
            ),
          if (loaded?.shouts case final List<Shout> shouts
              when shouts.isNotEmpty)
            PersistentSliverSection(
              name: 'shouts',
              title: 'Shouts',
              count: shouts.length,
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
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
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
        Avatar(url: user?.avatar, name: shown, size: profileAvatarSize),
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
  const ProfileCounts({super.key, required this.user, this.wide = false});

  final User? user;
  final bool wide;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: Space.large,
    runSpacing: Space.small,
    alignment: wide ? WrapAlignment.end : WrapAlignment.start,
    children: [
      for (final (IconData, int?, String) stat in <(IconData, int?, String)>[
        (Icons.person_outline, user?.watchedBy, 'watchers'),
        (Icons.visibility_outlined, user?.views, 'views'),
        (Icons.image_outlined, user?.submissions, 'submissions'),
        (Icons.favorite_outline, user?.favorites, 'favourites'),
      ])
        if (user == null || stat.$2 != null)
          Statistic(icon: stat.$1, value: stat.$2, label: stat.$3),
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
                dimension: contactIconSize,
                child: contact.icon == null
                    ? Icon(
                        Icons.link,
                        size: contactIconSize,
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
        Expanded(child: Text(fact.value, style: theme.textTheme.bodyMedium)),
      ],
    );
  }
}
