import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:furlovin/submission/submission.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

typedef SubmissionPaging = PagingController<int, SubmissionPreview>;

extension SubmissionPagingRestart on SubmissionPaging {
  Future<void> restart() {
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
  int Function(PagingState<int, SubmissionPreview> state)? nextKey,
}) {
  late final SubmissionPaging controller;
  bool exhausted = false;
  controller = SubmissionPaging(
    getNextPageKey: (state) {
      if (state.keys?.isNotEmpty != true) exhausted = false;
      if (exhausted) return null;
      final int next = nextKey?.call(state) ?? state.nextIntPageKey;
      return state.keys?.lastOrNull == next ? null : next;
    },
    fetchPage: (key) async {
      final SubmissionClient client = await ref.read(
        submissionClientProvider.future,
      );
      final List<SubmissionPreview> fetched = await fetch(client, key);
      exhausted = fetched.isEmpty;
      final Set<int> seen = {
        for (final SubmissionPreview item in controller.items ?? const [])
          item.id,
      };
      return [
        for (final SubmissionPreview item in fetched)
          if (seen.add(item.id)) item,
      ];
    },
  );
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
  Future<List<SubmissionPreview>> Function(SubmissionClient, int) fetch,
) {
  final Retention retention = ref.read(listingRetentionProvider);
  ref.onDispose(() => retention.release(key));
  retention.hold(key, ref.keepAlive());
  return submissionPaging(ref, fetch);
}

final Provider<SubmissionPaging> browseProvider = Provider<SubmissionPaging>(
  (ref) => submissionPaging(ref, (client, page) => client.browse(page: page)),
);

final Provider<SubmissionPaging> inboxProvider = Provider<SubmissionPaging>(
  (ref) => submissionPaging(
    ref,
    (client, after) => client.inbox(after: after),
    nextKey: (state) => state.items?.lastOrNull?.id ?? 0,
  ),
);

final ProviderFamily<SubmissionPaging, String> galleryProvider = Provider
    .autoDispose
    .family<SubmissionPaging, String>(
      (ref, user) => retainedPaging(ref, (
        'gallery',
        user,
      ), (client, page) => client.gallery(user, page: page)),
    );

const int submissionRetention = 12;

final Provider<Retention> submissionRetentionProvider = Provider<Retention>(
  (ref) => Retention(submissionRetention),
);

final FutureProviderFamily<SubmissionDetail, int> submissionProvider =
    FutureProvider.autoDispose.family<SubmissionDetail, int>((ref, id) async {
      final Retention retention = ref.read(submissionRetentionProvider);
      final KeepAliveLink link = ref.keepAlive();
      ref.onDispose(() => retention.release(id));
      final SubmissionClient client = await ref.watch(
        submissionClientProvider.future,
      );
      try {
        final SubmissionDetail detail = await client.submission(id);
        retention.hold(id, link);
        return detail;
      } on Object {
        link.close();
        rethrow;
      }
    });
