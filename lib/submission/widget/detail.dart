import 'dart:math' as math;

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/comment/comment.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/markup/markup.dart';
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

class _SubmissionPageState extends ConsumerState<SubmissionPage> {
  late final DismissController dismiss = DismissController(
    DismissRoute.of(context),
  );

  int get id => widget.id;

  SubmissionPreview? get preview => widget.preview;

  @override
  Widget build(BuildContext context) {
    final AsyncValue<SubmissionDetail> detail = ref.watch(
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
    final List<CommentRow> comments = threadComments(
      detail.asData?.value.comments ?? const [],
    );
    final SubmissionFacade facade = SubmissionFacade(
      submission: loaded,
      preview: preview,
    );

    return ScrollToDismiss(
      controller: dismiss,
      onDismiss: () => Navigator.of(context).maybePop(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned.fill(
              child: DismissFade(
                controller: dismiss,
                child: ColoredBox(color: Theme.of(context).colorScheme.surface),
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
                                    wide: wide,
                                  ),
                                ),
                              ),
                              const SizedBox(height: Space.large),
                              Skeletonizer(
                                enabled: loaded == null,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 22,
                                  children: [
                                    if (loaded == null)
                                      Text(BoneMock.paragraph)
                                    else if (loaded.description
                                        case final String description)
                                      MarkupBody(markup: description),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (loaded?.tags case final List<String> tags
                            when tags.isNotEmpty)
                          PersistentSliverSection(
                            name: 'tags',
                            title: 'Tags',
                            count: tags.length,
                            sliver: SliverToBoxAdapter(
                              child: SubmissionTags(tags: tags),
                            ),
                          ),
                        if (comments.isNotEmpty)
                          PersistentSliverSection(
                            name: 'comments',
                            title: 'Comments',
                            count: comments.length,
                            sliver: SliverList.separated(
                              itemCount: comments.length,
                              itemBuilder: (context, index) =>
                                  CommentTile(row: comments[index]),
                              separatorBuilder: (context, index) =>
                                  CommentBreak(below: comments[index + 1]),
                            ),
                          ),
                        PersistentSliverSection(
                          name: 'metadata',
                          title: 'Details',
                          sliver: SliverToBoxAdapter(
                            child: Skeletonizer(
                              enabled: loaded == null,
                              child: SubmissionMetadata(submission: loaded),
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
        decodeWidth: null,
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
    this.wide = false,
  });

  final Submission? submission;
  final bool wide;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: Space.large,
    runSpacing: Space.small,
    alignment: wide ? WrapAlignment.end : WrapAlignment.start,
    children: [
      for (final (IconData, int?, String) stat in <(IconData, int?, String)>[
        (Icons.visibility_outlined, submission?.views, 'views'),
        (Icons.favorite_outline, submission?.favorites, 'favourites'),
        (Icons.mode_comment_outlined, submission?.comments, 'comments'),
      ])
        if (submission == null || stat.$2 != null)
          Statistic(icon: stat.$1, value: stat.$2, label: stat.$3),
    ],
  );
}

class Statistic extends StatelessWidget {
  const Statistic({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final int? value;
  final String label;

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
                  text: value == null ? BoneMock.chars(5) : countOf(value!),
                  style: const TextStyle(
                    fontFeatures: [FontFeature.tabularFigures()],
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
        onTap: () =>
            context.openQuery(SearchQuery(text: '$keywordField $label')),
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
});

class SubmissionMetadata extends StatelessWidget {
  const SubmissionMetadata({super.key, required this.submission});

  final Submission? submission;

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
      ),
      (
        icon: Icons.brush_outlined,
        label: 'Category',
        value: submission?.category,
        tint: null,
      ),
      (
        icon: Icons.palette_outlined,
        label: 'Theme',
        value: submission?.theme,
        tint: null,
      ),
      (
        icon: Icons.pets,
        label: 'Species',
        value: submission?.species,
        tint: null,
      ),
      (
        icon: Icons.aspect_ratio,
        label: 'Resolution',
        value: submission?.resolution,
        tint: null,
      ),
      (
        icon: Icons.sd_storage_outlined,
        label: 'File size',
        value: submission?.fileSize,
        tint: null,
      ),
    ].where((e) => submission == null || e.value != null).toList();
    if (rows.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: Space.snug,
      children: [
        for (final MetadataEntry row in rows)
          MetadataRow(
            icon: row.icon,
            label: row.label,
            value: row.value ?? BoneMock.words(2),
            tint: row.tint,
          ),
      ],
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
