import 'package:flutter_riverpod/misc.dart';

class Retention {
  Retention(this.capacity);

  final int capacity;
  final Map<Object, KeepAliveLink> _held = <Object, KeepAliveLink>{};

  int get length => _held.length;

  void hold(Object key, KeepAliveLink link) {
    _held.remove(key)?.close();
    _held[key] = link;
    while (_held.length > capacity) {
      final Object oldest = _held.keys.first;
      _held.remove(oldest)?.close();
    }
  }

  void release(Object key) => _held.remove(key)?.close();
}
