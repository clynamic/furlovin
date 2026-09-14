import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  Widget page(
    RevisitController controller,
    Future<void> Function() onRefresh,
  ) => MaterialApp(
    home: Revisit(
      controller: controller,
      child: Scaffold(
        body: RevisitRefresh(
          onRefresh: onRefresh,
          child: ListView(
            children: [
              for (int i = 0; i < 30; i++)
                SizedBox(height: 60, child: Text('$i')),
            ],
          ),
        ),
      ),
    ),
  );

  testWidgets('revisiting a page runs its pull to refresh', (tester) async {
    final RevisitController controller = RevisitController();
    int refreshed = 0;
    await tester.pumpWidget(page(controller, () async => refreshed++));

    final Future<void> revisit = controller.revisit();
    await tester.pumpAndSettle();
    await revisit;

    expect(refreshed, 1);
    expect(find.byType(RefreshProgressIndicator), findsNothing);
  });

  testWidgets('a page that is gone no longer answers revisits', (tester) async {
    final RevisitController controller = RevisitController();
    int refreshed = 0;
    await tester.pumpWidget(page(controller, () async => refreshed++));
    await tester.pumpWidget(const MaterialApp(home: SizedBox()));

    await controller.revisit();

    expect(controller.handler, isNull);
    expect(refreshed, 0);
  });
}
