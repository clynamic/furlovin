import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/database/database.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/parser/parser.dart';

final Provider<IdentityStore> identityStoreProvider = Provider<IdentityStore>(
  (ref) => IdentityStore(ref.watch(databaseProvider)),
);

final StreamProvider<Session> sessionProvider = StreamProvider<Session>(
  (ref) => ref
      .watch(identityStoreProvider)
      .watch()
      .map((session) => session ?? const Session()),
);

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

final Provider<bool> authenticatedProvider = Provider<bool>(
  (ref) => ref
      .watch(sessionProvider)
      .maybeWhen(data: (e) => e.isAuthenticated, orElse: () => false),
);
