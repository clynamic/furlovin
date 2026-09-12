import 'dart:async';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/database/database.dart';
import 'package:furlovin/identity/identity.dart';

final FutureProvider<FaClient> clientProvider = FutureProvider<FaClient>((
  ref,
) async {
  final IdentityStore store = ref.watch(identityStoreProvider);
  final Session session = await ref.watch(sessionProvider.future);
  final FaClient client = FaClient(session: session);
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

final FutureProvider<CacheManager> thumbnailCacheProvider =
    FutureProvider<CacheManager>((ref) async {
      final CacheManager cache = createThumbnailCache(
        (await ref.watch(clientProvider.future)).dio,
        ref.watch(databaseProvider),
      );
      ref.onDispose(cache.dispose);
      return cache;
    });

final FutureProvider<CacheManager> artworkCacheProvider =
    FutureProvider<CacheManager>((ref) async {
      final CacheManager cache = createArtworkCache(
        (await ref.watch(clientProvider.future)).dio,
        ref.watch(databaseProvider),
      );
      ref.onDispose(cache.dispose);
      return cache;
    });
