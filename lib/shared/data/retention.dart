import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

class Retention {
  Retention(int this.capacity);

  Retention.unbounded() : capacity = null;

  final int? capacity;
  final Map<Object, VoidCallback> _held = <Object, VoidCallback>{};

  int get length => _held.length;

  void hold(Object key, KeepAliveLink link) {
    _held.remove(key)?.call();
    _keep(key, link.close);
  }

  void follow(
    Object key,
    ProviderContainer container,
    ProviderListenable<Object?> provider,
  ) => _keep(
    key,
    _held.remove(key) ?? container.listen(provider, (previous, next) {}).close,
  );

  void _keep(Object key, VoidCallback close) {
    _held[key] = close;
    final int? limit = capacity;
    if (limit == null) return;
    while (_held.length > limit) {
      final Object oldest = _held.keys.first;
      _held.remove(oldest)?.call();
    }
  }

  void release(Object key) => _held.remove(key)?.call();
}
