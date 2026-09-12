import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/logs/logs.dart';
import 'package:material_ui/material_ui.dart';

const String faLoginPath = '/login/';
const String loggedInMarker = 'logout-link';
const String loggedInFallback = 'loggedin_user_avatar';
const String authCheckPath = '/controls/';

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
      final String page = await FaClient(session: session).get(authCheckPath);
      if (!page.contains(loggedInMarker) && !page.contains(loggedInFallback)) {
        logger.warn('Cookies present but the site does not know us');
        if (mounted) setState(() => settling = false);
        return;
      }
      await store.write(session);
      logger.info('Signed in');
      if (mounted) Navigator.of(context).maybePop(true);
    } on FaException catch (error) {
      logger.warn('Could not confirm the session', {'failure': '$error'});
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

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Sign in to Fur Affinity'),
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
