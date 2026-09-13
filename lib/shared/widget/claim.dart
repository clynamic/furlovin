import 'dart:math' as math;

import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

class BottomClaim extends ChangeNotifier {
  int _held = 0;

  bool get claimed => _held > 0;

  void take() {
    _held++;
    if (_held == 1) _announce();
  }

  void drop() {
    _held--;
    if (_held == 0) _announce();
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
  Animation<double>? _covered;
  bool _holding = false;

  void _hold(bool wanted) {
    if (_holding == wanted) return;
    _holding = wanted;
    if (wanted) {
      _bottom.take();
      return;
    }
    _bottom.drop();
  }

  void _onCover() => _hold((_covered?.value ?? 0) < 0.5);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Animation<double>? now = ModalRoute.of(context)?.secondaryAnimation;
    if (now == _covered) return;
    _covered?.removeListener(_onCover);
    _covered = now;
    _covered?.addListener(_onCover);
    _onCover();
  }

  @override
  void dispose() {
    _covered?.removeListener(_onCover);
    _hold(false);
    super.dispose();
  }
}
