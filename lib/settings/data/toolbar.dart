import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/settings/settings.dart';

enum Hand { left, right }

const String handKey = 'toolbar.hand';

final Provider<Hand> handProvider = Provider<Hand>((ref) {
  final Map<String, String> preferences =
      ref.watch(preferencesProvider).value ?? const {};
  return Hand.values.asNameMap()[preferences[handKey]] ?? Hand.right;
});

extension HandOrder<T> on List<T> {
  List<T> forHand(Hand hand) => switch (hand) {
    Hand.left => reversed.toList(),
    Hand.right => this,
  };
}
