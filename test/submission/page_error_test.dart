import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:furlovin/submission/submission.dart';
import 'package:material_ui/material_ui.dart';

Future<int> _tapped(WidgetTester tester, Object error) async {
  int retries = 0;
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          body: NewPageError(error: error, onRetry: () => retries++),
        ),
      ),
    ),
  );
  await tester.tap(find.byType(NewPageError));
  await tester.pumpAndSettle();
  return retries;
}

void main() {
  testWidgets('a failed page retries on tap', (tester) async {
    expect(await _tapped(tester, Exception('offline')), 1);
  });

  testWidgets('an unreadable page opens its details instead of retrying', (
    tester,
  ) async {
    final ParseFailure failure = ParseFailure(
      'browse',
      DocumentErrors()..add(
        const FieldError(
          path: 'submissions',
          kind: FieldErrorKind.missing,
          error: NoMatch(causes: [EmptyStep(1, 'select "figure"')]),
        ),
      ),
    );
    expect(await _tapped(tester, failure), 0);
    expect(find.text('This page could not be read'), findsOneWidget);
    expect(find.text('submissions missing'), findsOneWidget);
  });
}
