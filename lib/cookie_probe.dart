import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/logs/logs.dart';
import 'package:material_ui/material_ui.dart';

const String loggedInMarker = 'logout-link';
const String loggedInFallback = 'loggedin_user_avatar';
const String authCheckPath = '/controls/submissions/';

class ProbeResult {
  const ProbeResult({
    this.cookies = const [],
    this.userAgent,
    this.authenticated,
    this.detail,
    this.error,
  });

  final List<Cookie> cookies;
  final String? userAgent;
  final bool? authenticated;
  final String? detail;
  final String? error;

  bool get empty => cookies.isEmpty && userAgent == null && error == null;

  bool get hasSession => Session.required.every(
    (name) => cookies.any((cookie) => cookie.name == name),
  );

  List<String> get missing => Session.required
      .where((name) => !cookies.any((cookie) => cookie.name == name))
      .toList();
}

class CookieProbePage extends StatefulWidget {
  const CookieProbePage({super.key, required this.store});

  final IdentityStore store;

  @override
  State<CookieProbePage> createState() => _CookieProbePageState();
}

class _CookieProbePageState extends State<CookieProbePage> {
  final Logger logger = Logger('CookieProbe');
  InAppWebViewController? controller;
  ProbeResult result = const ProbeResult();
  bool probing = false;
  String? currentUrl;

  @override
  void initState() {
    super.initState();
    resume();
  }

  Future<void> resume() async {
    final Session? stored = await widget.store.read();
    if (stored == null) {
      logger.info('No stored session');
      return;
    }
    logger.info('Restored session, cookies: {names}', {
      'names': stored.cookies.keys.toList(),
      'present': stored.isAuthenticated,
    });
    if (!mounted) return;
    setState(
      () => result = ProbeResult(
        userAgent: stored.userAgent,
        detail: 'restored from storage',
      ),
    );
    await verify(stored, const []);
  }

  Future<void> verify(Session session, List<Cookie> cookies) async {
    final FaClient client = FaClient(session: session);
    try {
      final String page = await client.get(authCheckPath);
      final bool authed =
          page.contains(loggedInMarker) || page.contains(loggedInFallback);
      logger.info('Logged in: {state} ({bytes} bytes)', {
        'state': authed,
        'bytes': page.length,
        'marker': page.contains(loggedInMarker)
            ? loggedInMarker
            : page.contains(loggedInFallback)
            ? loggedInFallback
            : 'none',
      });
      if (!mounted) return;
      setState(
        () => result = ProbeResult(
          cookies: cookies,
          userAgent: session.userAgent,
          authenticated: authed,
          detail: '${page.length} bytes from $authCheckPath',
        ),
      );
    } on FaException catch (e) {
      logger.warn('Verification rejected', {'failure': '$e'});
      if (!mounted) return;
      setState(
        () => result = ProbeResult(
          cookies: cookies,
          userAgent: session.userAgent,
          authenticated: false,
          detail: '$e',
        ),
      );
    }
  }

  Future<void> forget() async {
    await widget.store.clear();
    logger.info('Cleared stored session');
    if (!mounted) return;
    setState(() => result = const ProbeResult());
  }

  Future<void> probe() async {
    setState(() => probing = true);
    try {
      final List<Cookie> cookies = await CookieManager.instance().getCookies(
        url: WebUri(faOrigin),
      );
      final Object? agent = await controller?.evaluateJavascript(
        source: 'navigator.userAgent',
      );
      final Session session = Session(
        cookies: {
          for (final Cookie cookie in cookies)
            cookie.name: cookie.value?.toString() ?? '',
        },
        userAgent: agent?.toString(),
      );

      logger.info('Harvested {count} cookies, session present: {present}', {
        'count': cookies.length,
        'present': session.isAuthenticated,
        'missing': session.missing,
        'names': cookies.map((e) => e.name).toList(),
        'http_only': {
          for (final Cookie cookie in cookies)
            cookie.name: cookie.isHttpOnly.toString(),
        },
        'user_agent': session.userAgent,
      });

      setState(
        () => result = ProbeResult(
          cookies: cookies,
          userAgent: session.userAgent,
          detail: 'verifying',
        ),
      );

      if (session.isAuthenticated) {
        await widget.store.write(session);
        logger.info('Stored session');
      }

      await verify(session, cookies);
    } on Exception catch (e, stacktrace) {
      logger.error('Probe failed', null, e, stacktrace);
      setState(() => result = ProbeResult(error: '$e'));
    } finally {
      setState(() => probing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cookie probe'),
        actions: [
          IconButton(
            onPressed: forget,
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Forget stored session',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                currentUrl ?? 'loading',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri('$faOrigin/login/')),
              onWebViewCreated: (value) => controller = value,
              onLoadStop: (value, url) =>
                  setState(() => currentUrl = url?.toString()),
            ),
          ),
          const Divider(height: 1),
          SizedBox(
            height: 220,
            width: double.infinity,
            child: SelectionArea(child: ProbeReport(result: result)),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: probing ? null : probe,
        icon: const Icon(Icons.cookie),
        label: const Text('Read cookies'),
      ),
    );
  }
}

class ProbeReport extends StatelessWidget {
  const ProbeReport({super.key, required this.result});

  final ProbeResult result;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    if (result.error case final String error) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Text(
            error,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ),
      );
    }
    if (result.empty) {
      return const Center(child: Text('Log in, then read cookies.'));
    }
    final Color tone = switch (result.authenticated) {
      true => theme.colorScheme.primary,
      false => theme.colorScheme.error,
      null => theme.colorScheme.onSurface,
    };
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(switch (result.authenticated) {
          true => 'Authenticated',
          false => 'Not authenticated',
          null =>
            result.hasSession
                ? 'Session cookies present'
                : 'Missing: ${result.missing.join(', ')}',
        }, style: theme.textTheme.titleMedium?.copyWith(color: tone)),
        if (result.detail case final String detail)
          Text(detail, style: theme.textTheme.bodySmall),
        const SizedBox(height: 8),
        for (final Cookie cookie in result.cookies)
          Text(
            '${cookie.name}  '
            'httpOnly=${cookie.isHttpOnly}  '
            'secure=${cookie.isSecure}  '
            'domain=${cookie.domain}  '
            'len=${cookie.value?.toString().length}',
            style: theme.textTheme.bodySmall,
          ),
        const SizedBox(height: 12),
        Text('User agent', style: theme.textTheme.titleSmall),
        Text(result.userAgent ?? 'none', style: theme.textTheme.bodySmall),
      ],
    );
  }
}
