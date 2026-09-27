import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:furlovin/submission/submission.dart';

final FutureProvider<SubmissionClient> submissionClientProvider =
    FutureProvider<SubmissionClient>(
      (ref) async => SubmissionClient(
        client: await ref.watch(clientProvider.future),
        rules: await ref.watch(rulesProvider.future),
      ),
    );

const int submissionListingRetention = 4;

final Provider<Retention> submissionListingRetentionProvider =
    Provider<Retention>((ref) => Retention(submissionListingRetention));

final Provider<Retention> pinnedSubmissionListingsProvider =
    Provider<Retention>((ref) => Retention.unbounded());

final SubmissionListing<void, BrowseDocument> browseListing = SubmissionListing(
  name: 'browse',
  pinned: true,
  fetch: (client, _, page) => client.browse(page: page),
  items: (page) => page.submissions,
  next: (page, key) => page.submissions.isEmpty ? null : key + 1,
);

final Provider<String?> siteBannerProvider = Provider<String?>(
  (ref) => switch (ref
      .watch(
        submissionListingPageProvider((
          ref.watch(sessionEpochProvider),
          (browseListing, null),
          browseListing.first,
        )),
      )
      .value) {
    final BrowseDocument page => page.banner,
    _ => null,
  },
);

final SubmissionListing<void, List<SubmissionPreview>> inboxListing =
    SubmissionListing(
      name: 'inbox',
      pinned: true,
      needsLogin: true,
      first: 0,
      fetch: (client, _, after) => client.inbox(after: after),
      items: (page) => page,
      next: (page, after) => page.lastOrNull?.id,
    );

final SubmissionListing<GallerySource, GalleryPage> galleryListing =
    SubmissionListing(
      name: 'gallery',
      fetch: (client, source, page) => client.gallery(source, page: page),
      items: (page) => page.submissions,
      next: (page, key) => page.submissions.isEmpty ? null : key + 1,
    );

final NotifierProviderFamily<KnownFolders, List<Folder>?, String>
knownFoldersProvider = NotifierProvider.autoDispose
    .family<KnownFolders, List<Folder>?, String>(KnownFolders.new);

class KnownFolders extends Notifier<List<Folder>?> {
  KnownFolders(this.user);

  final String user;

  @override
  List<Folder>? build() => null;

  void remember(GalleryPage page) => state = page.folders;
}

final ProviderFamily<List<Folder>?, GallerySource> galleryFoldersProvider =
    Provider.autoDispose.family<List<Folder>?, GallerySource>((ref, source) {
      final (int, SubmissionListingKey, int) head = (
        ref.watch(sessionEpochProvider),
        (galleryListing, source),
        galleryListing.first,
      );
      ref.listen(submissionListingPageProvider(head), (previous, next) {
        if (next.value case final GalleryPage page) {
          ref.read(knownFoldersProvider(source.user).notifier).remember(page);
        }
      });
      return switch (ref.watch(submissionListingPageProvider(head)).value) {
        final GalleryPage page => page.folders,
        _ => ref.watch(knownFoldersProvider(source.user)),
      };
    });

final SubmissionListing<String, List<Favorite>> favoritesListing =
    SubmissionListing(
      name: 'favorites',
      first: 0,
      fetch: (client, user, after) => client.favorites(user, after: after),
      items: (page) => [
        for (final Favorite favorite in page) favorite.submission,
      ],
      next: (page, after) => page.lastOrNull?.id,
    );

const int submissionRetention = 12;

final Provider<Retention> submissionRetentionProvider = Provider<Retention>(
  (ref) => Retention(submissionRetention),
);

final AsyncNotifierProviderFamily<SubmissionDetail, SubmissionDocument, int>
submissionProvider = AsyncNotifierProvider.autoDispose
    .family<SubmissionDetail, SubmissionDocument, int>(SubmissionDetail.new);

class SubmissionDetail extends AsyncNotifier<SubmissionDocument> {
  SubmissionDetail(this.id);

  final int id;

  SubmissionDocument? _confirmed;
  Optimistic<bool>? _favourite;

  @override
  Future<SubmissionDocument> build() async {
    ref.discardOnSessionChange();
    final Retention retention = ref.watch(submissionRetentionProvider);
    final KeepAliveLink link = ref.keepAlive();
    ref.onDispose(() => retention.release(id));
    final SubmissionClient client = await ref.watch(
      submissionClientProvider.future,
    );
    try {
      final SubmissionDocument detail = await client.submission(id);
      retention.hold(id, link);
      ref.refreshWhenStale(settled: () => _favourite?.settled ?? true);
      _confirmed = detail;
      _favourite = null;
      return detail;
    } on Object {
      link.close();
      rethrow;
    }
  }

  Future<void> setFavourited(bool wanted) async {
    final bool? favourited = _confirmed?.submission.favourited;
    if (favourited == null) return;
    final Optimistic<bool> sync = _favourite ??= Optimistic<bool>(
      confirmed: favourited,
      send: _sendFavourited,
      settle: actionSettle,
      spacing: actionSpacing,
      pause: pauseOnRateLimit,
    );
    await sync.want(wanted, _publish);
  }

  Future<bool> _sendFavourited(bool wanted) async {
    final String? link = _confirmed?.submission.favouriteLink;
    if (link == null) throw const AuthenticationRequired();
    final SubmissionClient client = await ref.read(
      submissionClientProvider.future,
    );
    SubmissionDocument answer;
    try {
      answer = await client.favourite(link);
    } on ParseFailure {
      answer = await client.submission(id);
    }
    _confirmed = answer;
    return answer.submission.favourited ?? false;
  }

  void _publish() {
    final SubmissionDocument? document = _confirmed;
    if (document == null || !ref.mounted) return;
    final Optimistic<bool>? sync = _favourite;
    state = AsyncData(
      sync == null ? document : _withFavourited(document, sync.shown),
    );
  }

  SubmissionDocument _withFavourited(
    SubmissionDocument document,
    bool favourited,
  ) {
    final Submission submission = document.submission;
    if (submission.favourited == favourited) return document;
    final int? count = submission.favorites;
    return document.copyWith(
      submission: submission.copyWith(
        favourited: favourited,
        favorites: count == null ? null : count + (favourited ? 1 : -1),
      ),
    );
  }
}
