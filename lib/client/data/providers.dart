import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/database/database.dart';
import 'package:furlovin/identity/identity.dart';

final Provider<Cooldown> cooldownProvider = Provider<Cooldown>(
  (ref) => Cooldown(),
);

final FutureProvider<FaClient> clientProvider = FutureProvider<FaClient>((
  ref,
) async {
  final IdentityStore store = ref.watch(identityStoreProvider);
  final Session session = await ref.watch(sessionProvider.future);
  final FaClient client = FaClient(
    session: session,
    cooldown: ref.watch(cooldownProvider),
  );
  final StreamSubscription<FaException> failures = client.failures.listen((
    failure,
  ) {
    if (failure is AuthenticationRequired && session.isAuthenticated) {
      store.clear();
    }
  });
  ref.onDispose(() {
    failures.cancel();
    client.close();
  });
  return client;
});

Future<Dio> _currentDio(Ref ref) async =>
    (await ref.read(clientProvider.future)).dio;

final Provider<CacheManager> thumbnailCacheProvider = Provider<CacheManager>((
  ref,
) {
  final CacheManager cache = createThumbnailCache(
    () => _currentDio(ref),
    ref.watch(databaseProvider),
  );
  ref.onDispose(cache.dispose);
  return cache;
});

final Provider<CacheManager> artworkCacheProvider = Provider<CacheManager>((
  ref,
) {
  final CacheManager cache = createArtworkCache(
    () => _currentDio(ref),
    ref.watch(databaseProvider),
  );
  ref.onDispose(cache.dispose);
  return cache;
});
