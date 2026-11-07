import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/database/database.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/parser/parser.dart';

final Provider<IdentityStore> identityStoreProvider = Provider<IdentityStore>(
  (ref) => IdentityStore(ref.watch(databaseProvider)),
);

final StreamProvider<Session> sessionProvider = StreamProvider<Session>((ref) {
  final StreamController<Session> sessions = StreamController<Session>();
  Session? identity;
  Clearance? clearance;
  void emit() {
    if ((identity, clearance) case (
      final Session session,
      final Clearance value,
    )) {
      sessions.add(session.withClearance(value));
    }
  }

  final List<StreamSubscription<Object?>> subscriptions = [
    ref.watch(identityStoreProvider).watch().listen((value) {
      identity = value ?? const Session();
      emit();
    }, onError: sessions.addError),
    ref.watch(clearanceStoreProvider).watch().listen((value) {
      clearance = value ?? const Clearance();
      emit();
    }, onError: sessions.addError),
  ];
  ref.onDispose(() {
    for (final StreamSubscription<Object?> subscription in subscriptions) {
      subscription.cancel();
    }
    sessions.close();
  });
  return sessions.stream;
});

final FutureProvider<ViewerClient> viewerClientProvider =
    FutureProvider<ViewerClient>(
      (ref) async => ViewerClient(
        client: await ref.watch(clientProvider.future),
        rules: await ref.watch(rulesProvider.future),
      ),
    );

final FutureProvider<Viewer?> viewerProvider = FutureProvider<Viewer?>((
  ref,
) async {
  if (!ref.watch(authenticatedProvider)) return null;
  final ViewerClient client = await ref.watch(viewerClientProvider.future);
  return client.viewer();
});

final NotifierProvider<BlocklistState, Blocklist> blocklistProvider =
    NotifierProvider<BlocklistState, Blocklist>(BlocklistState.new);

class BlocklistState extends Notifier<Blocklist> {
  @override
  Blocklist build() {
    final AsyncValue<Viewer?> viewer = ref.watch(viewerProvider);
    final Blocklist? held = stateOrNull;
    if (viewer.isLoading && held != null) return held;
    return switch (viewer.value) {
      final Viewer known => Blocklist.of(known),
      null => const Blocklist(),
    };
  }

  Future<void> setTag(String tag, {required bool blocked}) async {
    final String? key = ref.read(viewerProvider).value?.blocklistKey;
    if (key == null) throw const AuthenticationRequired();
    final ViewerClient client = await ref.read(viewerClientProvider.future);
    try {
      final List<String> stored = await client.setTagBlocked(
        tag,
        blocked: blocked,
        key: key,
      );
      state = state.withTags(stored, blocked: blocked);
    } finally {
      ref.invalidate(viewerProvider);
    }
  }
}

final Provider<bool> authenticatedProvider = Provider<bool>(
  (ref) => ref
      .watch(sessionProvider)
      .maybeWhen(data: (e) => e.isAuthenticated, orElse: () => false),
);

final Provider<String?> sessionKeyProvider = Provider<String?>(
  (ref) => ref.watch(sessionProvider).asData?.value.discriminator,
);

final NotifierProvider<SettledSession, String?> settledSessionProvider =
    NotifierProvider<SettledSession, String?>(SettledSession.new);

class SettledSession extends Notifier<String?> {
  @override
  String? build() => ref.watch(sessionKeyProvider) ?? stateOrNull;
}

final NotifierProvider<SessionEpoch, int> sessionEpochProvider =
    NotifierProvider<SessionEpoch, int>(SessionEpoch.new);

class SessionEpoch extends Notifier<int> {
  @override
  int build() {
    ref.listen<String?>(settledSessionProvider, (previous, next) {
      if (previous != null && previous != next) state++;
    });
    return 0;
  }
}

extension SessionScopedRef on Ref {
  void discardOnSessionChange() =>
      listen<String?>(settledSessionProvider, (previous, next) {
        if (previous != null && previous != next) invalidateSelf();
      });
}
