import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:furlovin/submission/submission.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

typedef PageLoader = Future<List<SubmissionPreview>> Function(int key);

typedef PageKeyReader = int Function(PagingState<int, SubmissionPreview> state);

class SubmissionPaging extends PagingController<int, SubmissionPreview> {
  factory SubmissionPaging(PageLoader load, {PageKeyReader? nextKey}) {
    late final SubmissionPaging paging;
    return paging = SubmissionPaging._(
      load,
      nextKey,
      getNextPageKey: (state) => paging._next(state),
      fetchPage: (key) => paging._page(key),
    );
  }

  SubmissionPaging._(
    this._load,
    this._nextKey, {
    required super.getNextPageKey,
    required super.fetchPage,
  });

  final PageLoader _load;
  final PageKeyReader? _nextKey;
  bool _exhausted = false;

  int? _next(PagingState<int, SubmissionPreview> state) {
    if (state.keys?.isNotEmpty != true) _exhausted = false;
    if (_exhausted) return null;
    final int next = _nextKey?.call(state) ?? state.nextIntPageKey;
    return state.keys?.lastOrNull == next ? null : next;
  }

  Future<List<SubmissionPreview>> _page(int key) async {
    final List<SubmissionPreview> fetched = await _load(key);
    _exhausted = fetched.isEmpty;
    return _unseen(fetched, items ?? const []);
  }

  List<SubmissionPreview> _unseen(
    List<SubmissionPreview> fetched,
    List<SubmissionPreview> shown,
  ) {
    final Set<int> seen = {for (final SubmissionPreview item in shown) item.id};
    return [
      for (final SubmissionPreview item in fetched)
        if (seen.add(item.id)) item,
    ];
  }

  Future<void> restart() async {
    final List<SubmissionPreview>? shown = items;
    if (shown == null || shown.isEmpty || value.error != null) return _reset();
    final Object current = operation = Object();
    try {
      final int first =
          _nextKey?.call(PagingState<int, SubmissionPreview>()) ??
          PagingState<int, SubmissionPreview>().nextIntPageKey;
      final List<SubmissionPreview> fetched = await _load(first);
      if (current != operation) return;
      _exhausted = fetched.isEmpty;
      value = PagingState<int, SubmissionPreview>(
        pages: [_unseen(fetched, const [])],
        keys: [first],
      );
    } on Exception {
      return;
    } finally {
      if (current == operation) operation = null;
    }
  }

  Future<void> _reset() {
    refresh();
    fetchNextPage();
    if (!value.isLoading) return Future<void>.value();
    final Completer<void> done = Completer<void>();
    void settle() {
      if (value.isLoading) return;
      removeListener(settle);
      done.complete();
    }

    addListener(settle);
    return done.future;
  }
}

final FutureProvider<SubmissionClient> submissionClientProvider =
    FutureProvider<SubmissionClient>(
      (ref) async => SubmissionClient(
        client: await ref.watch(clientProvider.future),
        rules: await ref.watch(rulesProvider.future),
      ),
    );

SubmissionPaging submissionPaging(
  Ref ref,
  Future<List<SubmissionPreview>> Function(SubmissionClient, int) fetch, {
  PageKeyReader? nextKey,
}) {
  ref.discardOnSessionChange();
  final SubmissionPaging controller = SubmissionPaging((key) async {
    final SubmissionClient client = await ref.read(
      submissionClientProvider.future,
    );
    return fetch(client, key);
  }, nextKey: nextKey);
  ref.onDispose(controller.dispose);
  controller.fetchNextPage();
  return controller;
}

const int listingRetention = 4;

final Provider<Retention> listingRetentionProvider = Provider<Retention>(
  (ref) => Retention(listingRetention),
);

SubmissionPaging retainedPaging(
  Ref ref,
  Object key,
  Future<List<SubmissionPreview>> Function(SubmissionClient, int) fetch, {
  PageKeyReader? nextKey,
}) {
  final Retention retention = ref.read(listingRetentionProvider);
  ref.onDispose(() => retention.release(key));
  retention.hold(key, ref.keepAlive());
  return submissionPaging(ref, fetch, nextKey: nextKey);
}

final Provider<ValueNotifier<String?>> siteBannerProvider =
    Provider<ValueNotifier<String?>>((ref) {
      final ValueNotifier<String?> banner = ValueNotifier(null);
      ref.onDispose(banner.dispose);
      return banner;
    });

final Provider<SubmissionPaging> browseProvider = Provider<SubmissionPaging>(
  (ref) => submissionPaging(ref, (client, page) async {
    final BrowseDocument fetched = await client.browse(page: page);
    if (fetched.banner case final String banner) {
      ref.read(siteBannerProvider).value = banner;
    }
    return fetched.submissions;
  }),
);

final Provider<SubmissionPaging> inboxProvider = Provider<SubmissionPaging>(
  (ref) => submissionPaging(ref, (client, after) async {
    if (!ref.read(authenticatedProvider)) {
      throw const AuthenticationRequired();
    }
    return client.inbox(after: after);
  }, nextKey: (state) => state.items?.lastOrNull?.id ?? 0),
);

final ProviderFamily<ValueNotifier<List<Folder>?>, String>
galleryFoldersProvider = Provider.autoDispose
    .family<ValueNotifier<List<Folder>?>, String>((ref, user) {
      final ValueNotifier<List<Folder>?> folders = ValueNotifier(null);
      ref.onDispose(folders.dispose);
      return folders;
    });

final ProviderFamily<GalleryListing, GallerySource> galleryProvider = Provider
    .autoDispose
    .family<GalleryListing, GallerySource>((ref, source) {
      final ValueNotifier<List<Folder>?> folders = ref.watch(
        galleryFoldersProvider(source.user),
      );
      final SubmissionPaging paging = retainedPaging(ref, ('gallery', source), (
        client,
        page,
      ) async {
        final GalleryPage fetched = await client.gallery(source, page: page);
        if (page == 1 && ref.mounted) folders.value = fetched.folders;
        return fetched.submissions;
      });
      return GalleryListing(paging: paging, folders: folders);
    });

final ProviderFamily<SubmissionPaging, String> favoritesProvider = Provider
    .autoDispose
    .family<SubmissionPaging, String>((ref, user) {
      final Map<int, int> cursors = {};
      return retainedPaging(ref, ('favorites', user), (client, after) async {
        final List<Favorite> favorites = await client.favorites(
          user,
          after: after,
        );
        if (favorites.lastOrNull case final Favorite last) {
          cursors[last.submission.id] = last.id;
        }
        return [for (final Favorite favorite in favorites) favorite.submission];
      }, nextKey: (state) => cursors[state.items?.lastOrNull?.id] ?? 0);
    });

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

  @override
  Future<SubmissionDocument> build() async {
    ref.discardOnSessionChange();
    final Retention retention = ref.read(submissionRetentionProvider);
    final KeepAliveLink link = ref.keepAlive();
    ref.onDispose(() => retention.release(id));
    final SubmissionClient client = await ref.watch(
      submissionClientProvider.future,
    );
    try {
      final SubmissionDocument detail = await client.submission(id);
      retention.hold(id, link);
      return detail;
    } on Object {
      link.close();
      rethrow;
    }
  }

  Future<void> favourite(String link) async {
    final SubmissionClient client = await ref.read(
      submissionClientProvider.future,
    );
    try {
      state = AsyncData(await client.favourite(link));
    } on ParseFailure {
      ref.invalidateSelf();
      await future;
    }
  }
}
