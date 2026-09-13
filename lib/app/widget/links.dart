import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:furlovin/logs/logs.dart';
import 'package:furlovin/markup/markup.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

final Logger linkLogger = Logger('Links');

Future<void> handInside(String url) async {
  final Logger scope = linkLogger.child({'url': url});
  if (defaultTargetPlatform != TargetPlatform.android) return hand(url);
  scope.debug('Opening {url} in an in-app browser');
  try {
    final bool opened = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.inAppBrowserView,
    );
    if (!opened) scope.warn('The system refused {url}');
  } on Object catch (error) {
    scope.error('Could not open {url}', const {}, error);
  }
}

class LinkListener extends StatefulWidget {
  const LinkListener({
    super.key,
    required this.links,
    required this.navigator,
    required this.child,
    this.elsewhere = handInside,
  });

  final Stream<Uri> links;
  final GlobalKey<NavigatorState> navigator;
  final Future<void> Function(String url) elsewhere;
  final Widget child;

  @override
  State<LinkListener> createState() => _LinkListenerState();
}

class _LinkListenerState extends State<LinkListener> {
  StreamSubscription<Uri>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = widget.links.listen(_open);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> _open(Uri uri) async {
    linkLogger.debug('Received {url}', {'url': '$uri'});
    BuildContext? context = widget.navigator.currentContext;
    while (context == null && mounted) {
      await WidgetsBinding.instance.endOfFrame;
      context = widget.navigator.currentContext;
    }
    if (context == null || !context.mounted) return;
    await openTarget(
      context,
      readTarget(uri.toString()),
      elsewhere: widget.elsewhere,
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
