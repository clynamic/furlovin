import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/logs/logs.dart';
import 'package:material_ui/material_ui.dart';

const String challengePendingScript =
    "typeof window._cf_chl_opt !== 'undefined'";

class ChallengePage extends ConsumerStatefulWidget {
  const ChallengePage({super.key, required this.url});

  final String url;

  @override
  ConsumerState<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends ConsumerState<ChallengePage> {
  final Logger logger = Logger('Challenge');
  bool settling = false;

  String get target =>
      Uri.tryParse(widget.url)?.host == faHost ? widget.url : faOrigin;

  Future<void> _settle(InAppWebViewController controller) async {
    if (settling || !mounted) return;
    final ClearanceStore store = ref.read(clearanceStoreProvider);
    final Cooldown cooldown = ref.read(cooldownProvider);
    setState(() => settling = true);
    final Object? pending = await controller.evaluateJavascript(
      source: challengePendingScript,
    );
    final List<Cookie> jar = await CookieManager.instance().getCookies(
      url: WebUri(faOrigin),
    );
    final Map<String, String> cookies = {
      for (final Cookie cookie in jar)
        if (Clearance.names.contains(cookie.name))
          cookie.name: cookie.value?.toString() ?? '',
    };
    if (pending != false || cookies.isEmpty) {
      if (mounted) setState(() => settling = false);
      return;
    }

    final Object? agent = await controller.evaluateJavascript(
      source: 'navigator.userAgent',
    );
    await store.write(
      Clearance(cookies: cookies, userAgent: agent?.toString()),
    );
    cooldown.release();
    logger.info('Passed the challenge');
    if (mounted) Navigator.of(context).maybePop(true);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Verify'),
      bottom: settling
          ? const PreferredSize(
              preferredSize: Size.fromHeight(2),
              child: LinearProgressIndicator(minHeight: 2),
            )
          : null,
    ),
    body: InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(target)),
      onLoadStop: (controller, url) => _settle(controller),
    ),
  );
}
