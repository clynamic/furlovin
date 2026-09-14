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

final FutureProviderFamily<UserDocument, String> userProvider = FutureProvider
    .autoDispose
    .family<UserDocument, String>((ref, name) async {
      ref.discardOnSessionChange();
      final Retention retention = ref.read(userRetentionProvider);
      final KeepAliveLink link = ref.keepAlive();
      ref.onDispose(() => retention.release(name));
      final UserClient client = await ref.watch(userClientProvider.future);
      try {
        final UserDocument detail = await client.user(name);
        retention.hold(name, link);
        return detail;
      } on Object {
        link.close();
        rethrow;
      }
    });
