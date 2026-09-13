import 'dart:math' as math;

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/comment/comment.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/markup/markup.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:furlovin/routing/routing.dart';
import 'package:furlovin/search/search.dart';
import 'package:furlovin/settings/settings.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:furlovin/submission/submission.dart';
import 'package:furlovin/theme/theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:skeletonizer/skeletonizer.dart';

const double headerPortraitCeiling = 0.85;
const double headerLandscapeCeiling = 0.8;
const double headerLandscapeFloor = 400;

class SubmissionPage extends ConsumerStatefulWidget {
  const SubmissionPage({super.key, required this.id, this.preview});

  final int id;
  final SubmissionPreview? preview;

  @override
  ConsumerState<SubmissionPage> createState() => _SubmissionPageState();
}

class _SubmissionPageState extends ConsumerState<SubmissionPage>
    with BottomClaimant {
  late final DismissController dismiss = DismissController(
    DismissRoute.of(context),
  );

  int get id => widget.id;

  SubmissionPreview? get preview => widget.preview;

  @override
  Widget build(BuildContext context) {
    final AsyncValue<SubmissionDocument> detail = ref.watch(
      submissionProvider(id),
    );
    final Session session = ref
        .watch(sessionProvider)
        .maybeWhen(data: (e) => e, orElse: () => const Session());
    final CacheManager? thumbnails = ref
        .watch(thumbnailCacheProvider)
        .maybeWhen(data: (e) => e, orElse: () => null);
    final CacheManager? artwork = ref
        .watch(artworkCacheProvider)
        .maybeWhen(data: (e) => e, orElse: () => null);

    if (detail case AsyncError(:final Object error) when preview == null) {
      return Scaffold(
        appBar: AppBar(),
        body: failureFor(
          error,
          onRetry: () => ref.invalidate(submissionProvider(id)),
        ),
      );
    }

    final Submission? loaded = detail.asData?.value.submission;
    final DocumentErrors? errors = detail.asData?.value.errors;
    final List<CommentRow> comments = threadComments(
      detail.asData?.value.comments ?? const [],
    );
    final SubmissionFacade facade = SubmissionFacade(
      submission: loaded,
      preview: preview,
    );

    return ClaimedBottom(
      child: ScrollToDismiss(
        controller: dismiss,
        onDismiss: () => Navigator.of(context).maybePop(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Positioned.fill(
                child: DismissFade(
                  controller: dismiss,
                  child: ColoredBox(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) => CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      pinned: true,
                      expandedHeight: _headerHeight(
                        constraints,
                        facade.aspectRatio,
                      ),
                      leading: DismissFade(
                        controller: dismiss,
                        child: const ScrimBackButton(),
                      ),
                      actions: [
                        DismissFade(
                          controller: dismiss,
                          child: DocumentErrorsButton(
                            errors: errors,
                            onImage: true,
                          ),
                        ),
                      ],
                      backgroundColor: Colors.transparent,
                      surfaceTintColor: Colors.transparent,
                      flexibleSpace: FlexibleSpaceBar(
                        background: GestureDetector(
                          onTap: () => openViewer(
                            context,
                            rungs: _rungs(context, loaded, thumbnails, artwork),
                            tag: submissionHeroTag(id),
                          ),
                          child: SubmissionHeader(
                            rungs: _rungs(context, loaded, thumbnails, artwork),
                            session: session,
                            tag: submissionHeroTag(id),
                            dismiss: dismiss,
                          ),
                        ),
                      ),
                    ),
                    DismissSliverFade(
                      controller: dismiss,
                      sliver: SliverMainAxisGroup(
                        slivers: [
                          SliverPadding(
                            padding:
                                Layout.textOf(context) +
                                const EdgeInsets.only(top: Space.page),
                            sliver: SliverList.list(
                              children: [
                                SpreadRow(
                                  leading: SubmissionByline(facade: facade),
                                  trailing: (wide) => Skeletonizer(
                                    enabled: loaded == null,
                                    child: SubmissionStats(
                                      submission: loaded,
                                      errors: errors,
                                      wide: wide,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: Space.large),
                                ErrorBoundary(
                                  errors: errors,
                                  name: 'submission.description',
                                  paths: const ['submission.description'],
                                  builder: (context, broken) => Skeletonizer(
                                    enabled: loaded == null,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      spacing: 22,
                                      children: [
                                        if (broken case final Breakage known)
                                          BreakageCard(
                                            broken: known,
                                            name: 'the description',
                                          ),
                                        if (loaded == null)
                                          Text(BoneMock.paragraph)
                                        else if (loaded.description
                                            case final String description)
                                          MarkupBody(markup: description),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ErrorBoundary(
                            errors: errors,
                            name: 'submission.miniGallery',
                            paths: const ['miniGallery'],
                            builder: (context, broken) => switch (detail
                                .asData
                                ?.value) {
                              SubmissionDocument(
                                miniGallery: MiniGallery(
                                      :final List<SubmissionPreview> newer,
                                      :final List<SubmissionPreview> older,
                                    ) &&
                                    final MiniGallery gallery,
                                :final Submission submission,
                              )
                                  when newer.isNotEmpty || older.isNotEmpty =>
                                PersistentSliverSection(
                                  name: 'miniGallery',
                                  title: gallery.name,
                                  count: gallery.count,
                                  action: TextButton.icon(
                                    onPressed: () => openTarget(
                                      context,
                                      readTarget(gallery.link),
                                    ),
                                    iconAlignment: IconAlignment.end,
                                    icon: const Icon(
                                      Icons.arrow_forward,
                                      size: 16,
                                    ),
                                    label: const Text('View all'),
                                  ),
                                  inset: const EdgeInsets.fromLTRB(
                                    Space.medium,
                                    Space.medium,
                                    0,
                                    Space.medium,
                                  ),
                                  sliver: BreakageSliver(
                                    broken: broken,
                                    name: 'this gallery',
                                    sliver: SliverToBoxAdapter(
                                      child: SubmissionStrip(
                                        key: ValueKey(submission.id),
                                        current: submission.id,
                                        limit: newer.length + older.length + 1,
                                        submissions: [
                                          ...newer,
                                          preview ??
                                              SubmissionPreview(
                                                id: submission.id,
                                                link:
                                                    '$faOrigin/view/${submission.id}/',
                                                rating: submission.rating,
                                                thumbnail:
                                                    submission.preview ??
                                                    submission.file,
                                                uploader: submission.uploader,
                                                thumbnailWidth:
                                                    facade.aspectRatio,
                                                thumbnailHeight: 1,
                                              ),
                                          ...older,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              _ => BrokenSection(
                                broken: broken,
                                name: 'miniGallery',
                                title: 'Gallery',
                              ),
                            },
                          ),
                          ErrorBoundary(
                            errors: errors,
                            name: 'submission.tags',
                            paths: const ['submission.tags'],
                            builder: (context, broken) =>
                                switch (loaded?.tags) {
                                  final List<String> tags
                                      when tags.isNotEmpty =>
                                    PersistentSliverSection(
                                      name: 'tags',
                                      title: 'Tags',
                                      count: tags.length,
                                      sliver: BreakageSliver(
                                        broken: broken,
                                        name: 'tags',
                                        sliver: SliverToBoxAdapter(
                                          child: SubmissionTags(tags: tags),
                                        ),
                                      ),
                                    ),
                                  _ => BrokenSection(
                                    broken: broken,
                                    name: 'tags',
                                    title: 'Tags',
                                  ),
                                },
                          ),
                          ErrorBoundary(
                            errors: errors,
                            name: 'submission.folders',
                            paths: const ['folders'],
                            builder: (context, broken) =>
                                switch (detail.asData?.value.folders) {
                                  final List<Folder> folders
                                      when folders.isNotEmpty =>
                                    PersistentSliverSection(
                                      name: 'folders',
                                      title: 'Folders',
                                      count: folders.length,
                                      sliver: BreakageSliver(
                                        broken: broken,
                                        name: 'folders',
                                        sliver: SliverList.builder(
                                          itemCount: folders.length,
                                          itemBuilder: (context, index) =>
                                              FolderTile(
                                                folder: folders[index],
                                              ),
                                        ),
                                      ),
                                    ),
                                  _ => BrokenSection(
                                    broken: broken,
                                    name: 'folders',
                                    title: 'Folders',
                                  ),
                                },
                          ),
                          ErrorBoundary(
                            errors: errors,
                            name: 'submission.comments',
                            paths: const ['comments'],
                            builder: (context, broken) => comments.isEmpty
                                ? BrokenSection(
                                    broken: broken,
                                    name: 'comments',
                                    title: 'Comments',
                                  )
                                : PersistentSliverSection(
                                    name: 'comments',
                                    title: 'Comments',
                                    count: comments.length,
                                    sliver: BreakageSliver(
                                      broken: broken,
                                      name: 'comments',
                                      sliver: SliverList.separated(
                                        itemCount: comments.length,
                                        itemBuilder: (context, index) =>
                                            CommentTile(row: comments[index]),
                                        separatorBuilder: (context, index) =>
                                            CommentBreak(
                                              below: comments[index + 1],
                                            ),
                                      ),
                                    ),
                                  ),
                          ),
                          PersistentSliverSection(
                            name: 'metadata',
                            title: 'Details',
                            sliver: SliverToBoxAdapter(
                              child: Skeletonizer(
                                enabled: loaded == null,
                                child: SubmissionMetadata(
                                  submission: loaded,
                                  errors: errors,
                                ),
                              ),
                            ),
                          ),
                          const SliverToBoxAdapter(
                            child: SizedBox(height: toolbarClearance),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: DismissFade(
                  controller: dismiss,
                  child: SubmissionActions(id: id, submission: loaded),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _headerHeight(BoxConstraints constraints, double ratio) {
    final double width = constraints.maxWidth;
    final double height = constraints.maxHeight;
    final bool landscape = width > height;
    final double natural = width / ratio;
    final double floor = height / 2;
    final double ceiling = landscape
        ? math.max(headerLandscapeFloor, height * headerLandscapeCeiling)
        : height * headerPortraitCeiling;
    return natural.clamp(math.min(floor, ceiling), ceiling);
  }

  List<ImageRung> _rungs(
    BuildContext context,
    Submission? loaded,
    CacheManager? thumbnails,
    CacheManager? artwork,
  ) {
    final double ratio = MediaQuery.devicePixelRatioOf(context);
    final List<ImageRung> rungs = [];

    if (preview case final SubmissionPreview value) {
      rungs.add((
        url: thumbnailFor(value.thumbnail, tileExtent, ratio),
        cache: thumbnails,
        decodeWidth: (tileExtent * ratio).round(),
      ));
    }

    final String? middle =
        loaded?.preview ??
        (preview == null
            ? null
            : thumbnailAt(preview!.thumbnail, thumbnailSizes.last));
    if (middle != null) {
      rungs.add((url: middle, cache: thumbnails, decodeWidth: null));
    }

    if (loaded case final Submission value when value.type.isViewable) {
      if (value.file case final String file) {
        rungs.add((url: file, cache: artwork, decodeWidth: null));
      }
    }

    return rungs;
  }
}

class SubmissionFacade {
  const SubmissionFacade({this.submission, this.preview});

  final Submission? submission;
  final SubmissionPreview? preview;

  String? get title => submission?.title ?? preview?.title;

  String? get uploader =>
      submission?.uploaderName ??
      submission?.uploader ??
      preview?.uploaderName ??
      preview?.uploader;

  String? get uploaderId => submission?.uploader ?? preview?.uploader;

  SubmissionRating? get rating => submission?.rating ?? preview?.rating;

  String? get avatar => submission?.uploaderAvatar;

  DateTime? get posted => submission?.posted;

  static final RegExp _resolution = RegExp(r'^(\d+)\s*x\s*(\d+)$');

  double get aspectRatio {
    double? width = preview?.thumbnailWidth;
    double? height = preview?.thumbnailHeight;
    if (submission?.resolution case final String value) {
      if (_resolution.firstMatch(value.trim()) case final RegExpMatch match) {
        width = double.parse(match.group(1)!);
        height = double.parse(match.group(2)!);
      }
    }
    if (width == null || height == null || height == 0) return 1;
    return (width / height).clamp(0.4, 2.5);
  }
}

class SubmissionHeader extends StatelessWidget {
  const SubmissionHeader({
    super.key,
    required this.rungs,
    required this.session,
    required this.tag,
    required this.dismiss,
  });

  final List<ImageRung> rungs;
  final Session session;
  final Object tag;
  final DismissController dismiss;

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      DismissFade(
        controller: dismiss,
        child: ColoredBox(
          color: Theme.of(context).colorScheme.surfaceContainer,
        ),
      ),
      Hero(
        tag: tag,
        flightShuttleBuilder: _ownShuttle,
        child: ProgressiveImage(
          rungs: rungs,
          headers: session.headersFor,
          discriminator: session.discriminator,
          background: Colors.transparent,
        ),
      ),
      DismissFade(
        controller: dismiss,
        child: const Align(alignment: Alignment.topCenter, child: TopScrim()),
      ),
    ],
  );

  static Widget _ownShuttle(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection direction,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) => switch (direction) {
    HeroFlightDirection.push => (toHeroContext.widget as Hero).child,
    HeroFlightDirection.pop => (fromHeroContext.widget as Hero).child,
  };
}

class SubmissionByline extends StatelessWidget {
  const SubmissionByline({super.key, required this.facade});

  final SubmissionFacade facade;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool pending = facade.title == null && facade.uploader == null;
    final String title =
        facade.title ?? (pending ? BoneMock.words(3) : 'Untitled');
    final String uploader =
        facade.uploader ?? (pending ? BoneMock.words(1) : 'unknown');
    final String? id = facade.uploaderId;
    return Skeletonizer(
      enabled: pending,
      child: InkWell(
        onTap: id == null ? null : () => context.openUser(id),
        child: Row(
          spacing: 12,
          children: [
            Avatar(url: facade.avatar, name: facade.uploader, size: 44),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    facade.posted == null
                        ? uploader
                        : '$uploader  ·  ${describeWhen(facade.posted!)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SubmissionStats extends StatelessWidget {
  const SubmissionStats({
    super.key,
    required this.submission,
    this.errors,
    this.wide = false,
  });

  final Submission? submission;
  final DocumentErrors? errors;
  final bool wide;

  @override
  Widget build(BuildContext context) => StatisticsRow(
    errors: errors,
    name: 'submission.stats',
    loading: submission == null,
    wide: wide,
    stats: [
      (
        icon: Icons.visibility_outlined,
        value: submission?.views,
        label: 'views',
        path: 'submission.views',
      ),
      (
        icon: Icons.favorite_outline,
        value: submission?.favorites,
        label: 'favourites',
        path: 'submission.favorites',
      ),
      (
        icon: Icons.mode_comment_outlined,
        value: submission?.comments,
        label: 'comments',
        path: 'submission.comments',
      ),
    ],
  );
}

typedef StatisticEntry = ({
  IconData icon,
  int? value,
  String label,
  String path,
});

class StatisticsRow extends StatelessWidget {
  const StatisticsRow({
    super.key,
    required this.errors,
    required this.name,
    required this.loading,
    required this.stats,
    this.wide = false,
  });

  final DocumentErrors? errors;
  final String name;
  final bool loading;
  final List<StatisticEntry> stats;
  final bool wide;

  @override
  Widget build(BuildContext context) => ErrorBoundary(
    errors: errors,
    name: name,
    paths: [for (final StatisticEntry stat in stats) stat.path],
    builder: (context, broken) => Wrap(
      spacing: Space.large,
      runSpacing: Space.small,
      alignment: wide ? WrapAlignment.end : WrapAlignment.start,
      children: [
        for (final StatisticEntry stat in stats)
          if (broken?.at(stat.path) case final Breakage known
              when stat.value == null)
            BreakageMark(
              broken: known,
              child: Statistic(
                icon: stat.icon,
                value: null,
                label: stat.label,
                broken: true,
              ),
            )
          else if (loading || stat.value != null)
            Statistic(icon: stat.icon, value: stat.value, label: stat.label),
      ],
    ),
  );
}

class Statistic extends StatelessWidget {
  const Statistic({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.broken = false,
  });

  final IconData icon;
  final int? value;
  final String label;
  final bool broken;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Semantics(
      label: value == null ? label : '$value $label',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: Space.small,
        children: [
          Skeleton.keep(
            child: Icon(
              icon,
              size: 17,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: switch (value) {
                    final int count => countOf(count),
                    null when broken => '?',
                    null => BoneMock.chars(5),
                  },
                  style: TextStyle(
                    fontFeatures: const [FontFeature.tabularFigures()],
                    color: broken ? theme.colorScheme.error : null,
                  ),
                ),
                const TextSpan(text: ' '),
                TextSpan(text: label),
              ],
            ),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class SubmissionTags extends StatelessWidget {
  const SubmissionTags({super.key, required this.tags});

  final List<String> tags;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 6,
    runSpacing: 6,
    children: [for (final String tag in tags) TagChip(label: tag)],
  );
}

class TagChip extends StatelessWidget {
  const TagChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surfaceContainerHighest,
      borderRadius: Corner.panels,
      child: InkWell(
        borderRadius: Corner.panels,
        onTap: () => context.openQuery(
          SearchQuery(
            terms: [
              SearchTerm([label], scope: TermScope.tags),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Space.small,
            vertical: Space.tight,
          ),
          child: Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

typedef MetadataEntry = ({
  IconData icon,
  String label,
  String? value,
  Color? tint,
  String path,
});

class SubmissionMetadata extends StatelessWidget {
  const SubmissionMetadata({super.key, required this.submission, this.errors});

  final Submission? submission;
  final DocumentErrors? errors;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final SubmissionRating? rating = submission?.rating;
    final List<MetadataEntry> rows = <MetadataEntry>[
      (
        icon: Icons.shield_outlined,
        label: 'Rating',
        value: rating == null ? null : titleOf(rating.name),
        tint: rating == null
            ? null
            : readableOn(
                theme.ratings.of(rating),
                theme.colorScheme.surfaceContainerLowest,
              ),
        path: 'submission.rating',
      ),
      (
        icon: Icons.brush_outlined,
        label: 'Category',
        value: submission?.category,
        tint: null,
        path: 'submission.category',
      ),
      (
        icon: Icons.palette_outlined,
        label: 'Theme',
        value: submission?.theme,
        tint: null,
        path: 'submission.theme',
      ),
      (
        icon: Icons.pets,
        label: 'Species',
        value: submission?.species,
        tint: null,
        path: 'submission.species',
      ),
      (
        icon: Icons.aspect_ratio,
        label: 'Resolution',
        value: submission?.resolution,
        tint: null,
        path: 'submission.resolution',
      ),
      (
        icon: Icons.sd_storage_outlined,
        label: 'File size',
        value: submission?.fileSize,
        tint: null,
        path: 'submission.fileSize',
      ),
    ];
    return ErrorBoundary(
      errors: errors,
      name: 'submission.details',
      paths: [for (final MetadataEntry row in rows) row.path],
      builder: (context, broken) {
        final List<Widget> shown = [
          for (final MetadataEntry row in rows)
            if (broken?.at(row.path) case final Breakage known
                when row.value == null)
              BreakageMark(
                broken: known,
                child: MetadataRow(
                  icon: row.icon,
                  label: row.label,
                  value: "Couldn't read",
                  tint: theme.colorScheme.error,
                ),
              )
            else if (submission == null || row.value != null)
              MetadataRow(
                icon: row.icon,
                label: row.label,
                value: row.value ?? BoneMock.words(2),
                tint: row.tint,
              ),
        ];
        if (shown.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: Space.snug,
          children: shown,
        );
      },
    );
  }
}

class MetadataRow extends StatelessWidget {
  const MetadataRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.tint,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? tint;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: Space.snug,
      children: [
        Skeleton.keep(
          child: Icon(
            icon,
            size: 18,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(
          width: 92,
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(color: tint),
          ),
        ),
      ],
    );
  }
}
