import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:furlovin/user/user.dart';

void main() {
  test('a user ghost reads the same every time for its index', () {
    expect(const UserGhost(3).profile, const UserGhost(3).profile);
    expect(const UserGhost(3).name, const UserGhost(3).name);
  });

  test('user ghosts of different indexes differ', () {
    expect({
      for (int i = 0; i < 6; i++) UserGhost(i).profile,
    }, hasLength(greaterThan(1)));
  });

  test('a user ghost refuses to be copied', () {
    expect(
      () => const UserGhost().copyWith,
      throwsA(isA<GhostsAreIntangibleError>()),
    );
  });
}
