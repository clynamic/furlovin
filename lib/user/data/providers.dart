import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:furlovin/user/user.dart';

const int userRetention = 8;

final FutureProvider<UserClient> userClientProvider =
    FutureProvider<UserClient>(
      (ref) async => UserClient(
        client: await ref.watch(clientProvider.future),
        rules: await ref.watch(rulesProvider.future),
      ),
    );

final Provider<Retention> userRetentionProvider = Provider<Retention>(
  (ref) => Retention(userRetention),
);

final AsyncNotifierProviderFamily<UserDetail, UserDocument, String>
userProvider = AsyncNotifierProvider.autoDispose
    .family<UserDetail, UserDocument, String>(UserDetail.new);

class UserDetail extends AsyncNotifier<UserDocument> {
  UserDetail(this.name);

  final String name;

  UserDocument? _confirmed;
  Optimistic<bool>? _watch;

  @override
  Future<UserDocument> build() async {
    ref.discardOnSessionChange();
    final Retention retention = ref.watch(userRetentionProvider);
    final KeepAliveLink link = ref.keepAlive();
    ref.onDispose(() => retention.release(name));
    final UserClient client = await ref.watch(userClientProvider.future);
    try {
      final UserDocument detail = await client.user(name);
      retention.hold(name, link);
      ref.refreshWhenStale(settled: () => _watch?.settled ?? true);
      _confirmed = detail;
      _watch = null;
      return detail;
    } on Object {
      link.close();
      rethrow;
    }
  }

  Future<void> setWatched(bool wanted) async {
    final bool? watched = _confirmed?.user.watched;
    if (watched == null) return;
    final Optimistic<bool> sync = _watch ??= Optimistic<bool>(
      confirmed: watched,
      send: _sendWatched,
      settle: actionSettle,
      spacing: actionSpacing,
      pause: pauseOnRateLimit,
    );
    try {
      await sync.want(wanted, _publish);
    } on FormatException {
      ref.invalidateSelf();
      rethrow;
    }
  }

  Future<bool> _sendWatched(bool wanted) async {
    final UserDocument document = _confirmed!;
    final String? key = document.user.watchKey;
    if (key == null) throw const AuthenticationRequired();
    final UserClient client = await ref.read(userClientProvider.future);
    final WatchAnswer answer = await client.setWatched(
      name,
      watched: wanted,
      key: key,
    );
    _confirmed = _withWatched(
      document,
      answer.watched,
    ).copyWith.user(watchKey: answer.key);
    return answer.watched;
  }

  void _publish() {
    final UserDocument? document = _confirmed;
    if (document == null || !ref.mounted) return;
    final Optimistic<bool>? sync = _watch;
    state = AsyncData(
      sync == null ? document : _withWatched(document, sync.shown),
    );
  }

  UserDocument _withWatched(UserDocument document, bool watched) {
    final User user = document.user;
    if (user.watched == watched) return document;
    final int? count = user.watchedBy;
    return document.copyWith(
      user: user.copyWith(
        watched: watched,
        watchedBy: count == null ? null : count + (watched ? 1 : -1),
      ),
    );
  }
}
