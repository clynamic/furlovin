import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('survives being measured inside a filling sliver', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: FailureView(
                  icon: Icons.inbox_outlined,
                  title: 'Nothing here',
                  detail: 'The page held no submissions.',
                ),
              ),
            ],
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Nothing here'), findsOneWidget);
  });

  testWidgets('still works as a whole page body', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FailureView(
            icon: Icons.error_outline,
            title: 'Broke',
            onRetry: () {},
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Try again'), findsOneWidget);
  });
}
