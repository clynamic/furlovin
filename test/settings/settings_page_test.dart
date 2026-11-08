import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/database/database.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/settings/settings.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('the settings page hides the tab bar while open', (tester) async {
    final AppDatabase database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final BottomClaim claim = BottomClaim();
    addTearDown(claim.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(database),
          preferencesProvider.overrideWith((ref) => Stream.value(const {})),
          authenticatedProvider.overrideWithValue(false),
          viewerProvider.overrideWith((ref) async => null),
        ],
        child: MaterialApp(
          builder: (context, child) =>
              BottomClaimScope(claim: claim, child: child!),
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => const SettingsPage(),
                  ),
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(claim.coverage, 1);

    Navigator.of(tester.element(find.byType(SettingsPage))).pop();
    await tester.pumpAndSettle();
    expect(claim.coverage, 0);
    await tester.pumpWidget(const SizedBox());
  });
}
