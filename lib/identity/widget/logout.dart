import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/logs/logs.dart';

const String faCookieDomain = '.furaffinity.net';

final Logger logoutLogger = Logger('Logout');

Future<void> logOut(WidgetRef ref) async {
  if (ref.read(viewerProvider).value?.logoutKey case final String key) {
    try {
      final ViewerClient client = await ref.read(viewerClientProvider.future);
      await client.logOut(key);
    } on Object catch (error) {
      logoutLogger.warn('Could not end the session on the site', {
        'failure': '$error',
      });
    }
  }
  await _forgetSiteCookies();
  await ref.read(identityStoreProvider).clear();
}

Future<void> _forgetSiteCookies() async {
  final CookieManager cookies = CookieManager.instance();
  final WebUri site = WebUri(faOrigin);
  try {
    await cookies.deleteCookies(url: site);
    await cookies.deleteCookies(url: site, domain: faCookieDomain);
  } on Object catch (error) {
    logoutLogger.warn('Could not clear the login cookies', {
      'failure': '$error',
    });
  }
}
