import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/app/app.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/routing/routing.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

class AppChrome extends ConsumerStatefulWidget {
  const AppChrome({super.key, required this.router, required this.child});

  final GoRouter router;
  final Widget child;

  @override
  ConsumerState<AppChrome> createState() => _AppChromeState();
}

class _AppChromeState extends ConsumerState<AppChrome> {
  final RetreatController retreat = RetreatController();
  int _last = 1;

  @override
  void initState() {
    super.initState();
    widget.router.routerDelegate.addListener(_onRoute);
  }

  @override
  void dispose() {
    widget.router.routerDelegate.removeListener(_onRoute);
    retreat.dispose();
    super.dispose();
  }

  void _onRoute() {
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) => _onRoute());
      return;
    }
    if (!mounted) return;
    retreat.show();
    setState(() {});
  }

  String get _where =>
      widget.router.routerDelegate.currentConfiguration.uri.path;

  int? get _rooted {
    final int at = shellDestinations.indexWhere((e) => e.path == _where);
    return at == -1 ? null : at;
  }

  void _go(int index) {
    final int? here = _rooted;
    _last = index;
    if (here == index) {
      retreat.show();
      return;
    }
    widget.router.go(shellDestinations[index].path);
  }

  @override
  Widget build(BuildContext context) {
    final int? here = _rooted;
    if (here != null) _last = here;
    final BottomClaim claim = ref.watch(bottomClaimProvider);
    final MediaQueryData media = MediaQuery.of(context);
    final bool wide = media.size.width >= Layout.compact;

    return ListenableBuilder(
      listenable: claim,
      builder: (context, _) => _build(context, claim.claimed, media, wide),
    );
  }

  Widget _build(
    BuildContext context,
    bool claimed,
    MediaQueryData media,
    bool wide,
  ) {
    return Stack(
      children: [
        Positioned.fill(
          child: MediaQuery(
            data: media.copyWith(
              padding: media.padding.copyWith(
                bottom: media.padding.bottom + (claimed ? 0 : barSpace),
              ),
            ),
            child: ScrollRetreat(controller: retreat, child: widget.child),
          ),
        ),
        if (!claimed)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: RetreatSlide(
              controller: retreat,
              child: SafeArea(
                top: false,
                child: Align(
                  alignment: wide ? Alignment.centerRight : Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      Layout.gutterOf(context),
                      0,
                      Layout.gutterOf(context),
                      Space.snug,
                    ),
                    child: ShellBar(
                      index: _last,
                      viewer: ref.watch(viewerProvider).asData?.value,
                      onGo: _go,
                      onSearch: () => widget.router.push(searchPath),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
