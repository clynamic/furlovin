import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:furlovin/submission/submission.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class SubmissionListing<A, P> {
  SubmissionListing({
    required this.name,
    required this._fetch,
    required this._items,
    required this._next,
    this.first = 1,
    this.pinned = false,
    this.needsLogin = false,
  });

  final String name;
  final int first;
  final bool pinned;
  final bool needsLogin;
  final Future<P> Function(SubmissionClient client, A arg, int key) _fetch;
  final List<SubmissionPreview> Function(P page) _items;
  final int? Function(P page, int key) _next;

  Future<Object?> load(SubmissionClient client, Object? arg, int key) =>
      _fetch(client, arg as A, key);

  List<SubmissionPreview> itemsOf(Object? page) => _items(page as P);

  int? after(Object? page, int key) => switch (_next(page as P, key)) {
    final int following when following != key => following,
    _ => null,
  };
}

typedef SubmissionListingKey = (
  SubmissionListing<Object?, Object?> listing,
  Object? arg,
);

final FutureProviderFamily<Object?, (int, SubmissionListingKey, int)>
submissionListingPageProvider = FutureProvider.autoDispose
    .family<Object?, (int, SubmissionListingKey, int)>((ref, key) async {
      final (
        _,
        (SubmissionListing<Object?, Object?> listing, Object? arg),
        int at,
      ) = key;
      if (listing.needsLogin && !ref.watch(authenticatedProvider)) {
        throw const AuthenticationRequired();
      }
      final SubmissionClient client = await ref.watch(
        submissionClientProvider.future,
      );
      return listing.load(client, arg, at);
    });

final NotifierProviderFamily<
  SubmissionListingPagination,
  List<int>,
  SubmissionListingKey
>
submissionListingPaginationProvider = NotifierProvider.autoDispose
    .family<SubmissionListingPagination, List<int>, SubmissionListingKey>(
      SubmissionListingPagination.new,
    );

class SubmissionListingPagination extends Notifier<List<int>> {
  SubmissionListingPagination(this.key);

  final SubmissionListingKey key;

  @override
  List<int> build() {
    ref.discardOnSessionChange();
    return [key.$1.first];
  }

  (int, SubmissionListingKey, int) _at(int key) =>
      (ref.read(sessionEpochProvider), this.key, key);

  void fetchNextPage() {
    final (int, SubmissionListingKey, int) last = _at(state.last);
    final AsyncValue<Object?> loaded = ref.read(
      submissionListingPageProvider(last),
    );
    if (loaded.hasValue) {
      if (key.$1.after(loaded.value, last.$3) case final int next) {
        state = [...state, next];
      }
    } else if (loaded.hasError && !loaded.isLoading) {
      ref.invalidate(submissionListingPageProvider(last));
    }
  }

  Future<void> restart() async {
    final (int, SubmissionListingKey, int) first = _at(state.first);
    ref.invalidate(submissionListingPageProvider(first));
    try {
      await ref.read(submissionListingPageProvider(first).future);
    } on Exception {
      return;
    }
    if (ref.mounted) state = [first.$3];
  }
}

final ProviderFamily<PagingState<int, SubmissionPreview>, SubmissionListingKey>
submissionListingProvider = Provider.autoDispose
    .family<PagingState<int, SubmissionPreview>, SubmissionListingKey>((
      ref,
      key,
    ) {
      final (SubmissionListing<Object?, Object?> listing, Object? arg) = key;
      final Retention retention = listing.pinned
          ? ref.watch(pinnedSubmissionListingsProvider)
          : ref.watch(submissionListingRetentionProvider);
      retention.follow(
        (listing.name, arg),
        ref.container,
        submissionListingProvider(key),
      );
      final int session = ref.watch(sessionEpochProvider);
      final Set<int> seen = {};
      final List<List<SubmissionPreview>> pages = [];
      final List<int> keys = [];
      for (final int at in ref.watch(
        submissionListingPaginationProvider(key),
      )) {
        final AsyncValue<Object?> loaded = ref.watch(
          submissionListingPageProvider((session, key, at)),
        );
        if (!loaded.hasValue) {
          return PagingState<int, SubmissionPreview>(
            pages: pages.isEmpty ? null : pages,
            keys: keys.isEmpty ? null : keys,
            error: loaded.isLoading ? null : loaded.error,
            isLoading: loaded.isLoading,
          );
        }
        pages.add([
          for (final SubmissionPreview item in listing.itemsOf(loaded.value))
            if (seen.add(item.id)) item,
        ]);
        keys.add(at);
        if (listing.after(loaded.value, at) == null) {
          return PagingState<int, SubmissionPreview>(
            pages: pages,
            keys: keys,
            hasNextPage: false,
          );
        }
      }
      return PagingState<int, SubmissionPreview>(pages: pages, keys: keys);
    });
