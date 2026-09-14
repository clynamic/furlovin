import 'dart:async';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/logs/logs.dart';
import 'package:material_ui/material_ui.dart';

const String faLoginPath = '/login/';
const Duration sessionSwitchTimeout = Duration(seconds: 5);

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final Logger logger = Logger('Login');
  InAppWebViewController? controller;
  bool settling = false;

  Future<void> _settle() async {
    if (settling || !mounted) return;
    final IdentityStore store = ref.read(identityStoreProvider);
    setState(() => settling = true);
    final List<Cookie> jar = await CookieManager.instance().getCookies(
      url: WebUri(faOrigin),
    );
    final Map<String, String> cookies = {
      for (final Cookie cookie in jar)
        cookie.name: cookie.value?.toString() ?? '',
    };
    final Session candidate = Session(cookies: cookies);
    if (!candidate.isAuthenticated) {
      if (mounted) setState(() => settling = false);
      return;
    }

    final Object? agent = await controller?.evaluateJavascript(
      source: 'navigator.userAgent',
    );
    final Session session = Session(
      cookies: cookies,
      userAgent: agent?.toString(),
    );

    try {
      await store.write(session);
      await _switchedTo(session.discriminator);
      final Viewer? viewer = await ref.read(viewerProvider.future);
      if (viewer == null) {
        logger.warn('Cookies present but the site does not know us');
        await store.clear();
        if (mounted) setState(() => settling = false);
        return;
      }
      logger.info('Signed in');
      if (mounted) Navigator.of(context).maybePop(true);
    } on Object catch (error) {
      logger.warn('Could not confirm the session', {'failure': '$error'});
      await store.clear();
      if (!mounted) return;
      setState(() => settling = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(describeFailure(error)),
        ),
      );
    }
  }

  Future<void> _switchedTo(String key) {
    if (ref.read(sessionKeyProvider) == key) return Future<void>.value();
    final Completer<void> switched = Completer<void>();
    final ProviderSubscription<String?> watching = ref.listenManual(
      sessionKeyProvider,
      (previous, next) {
        if (next == key && !switched.isCompleted) switched.complete();
      },
    );
    return switched.future
        .timeout(sessionSwitchTimeout)
        .whenComplete(watching.close);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Log in to Fur Affinity'),
      bottom: settling
          ? const PreferredSize(
              preferredSize: Size.fromHeight(2),
              child: LinearProgressIndicator(minHeight: 2),
            )
          : null,
    ),
    body: InAppWebView(
      initialUrlRequest: URLRequest(
        url: WebUri(Uri.parse(faOrigin).resolve(faLoginPath).toString()),
      ),
      onWebViewCreated: (value) => controller = value,
      onLoadStop: (controller, url) => _settle(),
    ),
  );
}
