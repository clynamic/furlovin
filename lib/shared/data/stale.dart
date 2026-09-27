import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

const Duration detailStaleness = Duration(minutes: 5);

final Provider<DateTime Function()> clockProvider =
    Provider<DateTime Function()>((ref) => DateTime.now);

extension StaleRef on Ref {
  void refreshWhenStale({required bool Function() settled}) {
    final DateTime Function() now = watch(clockProvider);
    final DateTime fetched = now();
    onResume(() {
      if (now().difference(fetched) < detailStaleness) return;
      scheduleMicrotask(() {
        if (mounted && settled()) invalidateSelf();
      });
    });
  }
}
