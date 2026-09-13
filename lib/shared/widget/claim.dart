import 'dart:math' as math;

import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

class BottomClaim extends ChangeNotifier {
  final Map<Object, double> _shares = {};

  double get coverage => _shares.values.fold(0, math.max);

  bool get claimed => coverage > 0;

  void cover(Object claimant, double share) {
    final double before = coverage;
    if (share <= 0) {
      _shares.remove(claimant);
    } else {
      _shares[claimant] = share.clamp(0, 1);
    }
    if (coverage != before) _announce();
  }

  void _announce() {
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (!_disposed) notifyListeners();
      });
      return;
    }
    notifyListeners();
  }

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

class BottomReserve extends InheritedWidget {
  const BottomReserve({super.key, required this.space, required super.child});

  final double space;

  static double of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<BottomReserve>()?.space ?? 0;

  @override
  bool updateShouldNotify(BottomReserve oldWidget) => oldWidget.space != space;
}

class ClaimedBottom extends StatelessWidget {
  const ClaimedBottom({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    final double space = BottomReserve.of(context);
    if (space == 0) return child;
    return MediaQuery(
      data: media.copyWith(
        padding: media.padding.copyWith(
          bottom: math.max(0, media.padding.bottom - space),
        ),
      ),
      child: child,
    );
  }
}

final Provider<BottomClaim> bottomClaimProvider = Provider<BottomClaim>((ref) {
  final BottomClaim claim = BottomClaim();
  ref.onDispose(claim.dispose);
  return claim;
});

mixin BottomClaimant<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  late final BottomClaim _bottom = ref.read(bottomClaimProvider);
  ModalRoute<Object?>? _route;

  void _onMove() {
    final ModalRoute<Object?>? route = _route;
    if (route == null) return;
    final double shown = route.animation?.value ?? 1;
    final double covered = route.secondaryAnimation?.value ?? 0;
    _bottom.cover(this, shown * (1 - covered));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ModalRoute<Object?>? now = ModalRoute.of(context);
    if (now == _route) return;
    _route?.animation?.removeListener(_onMove);
    _route?.secondaryAnimation?.removeListener(_onMove);
    _route = now;
    _route?.animation?.addListener(_onMove);
    _route?.secondaryAnimation?.addListener(_onMove);
    _onMove();
  }

  @override
  void dispose() {
    _route?.animation?.removeListener(_onMove);
    _route?.secondaryAnimation?.removeListener(_onMove);
    _bottom.cover(this, 0);
    super.dispose();
  }
}
