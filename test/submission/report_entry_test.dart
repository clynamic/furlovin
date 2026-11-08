import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:furlovin/routing/routing.dart';
import 'package:furlovin/settings/settings.dart';
import 'package:furlovin/submission/submission.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../_support/documents.dart';

void main() {
  late RuleSet rules;

  setUpAll(() => rules = loadRules());

  Submission read(String name) => Submission.fromOutcome(
    child(parseFixture(rules, SubmissionDocument.ruleType, name), 'submission'),
  )!;

  Future<void> show(WidgetTester tester, Submission submission) async {
    final GoRouter router = GoRouter(
      initialLocation: browsePath,
      routes: [
        GoRoute(
          path: browsePath,
          builder: (context, state) => Scaffold(
            body: SubmissionActions(id: submission.id, submission: submission),
          ),
          routes: [
            GoRoute(
              path: 'report',
              builder: (context, state) => Text(
                '${state.uri.path} '
                'report ${state.uri.queryParameters[reportLinkKey]}',
              ),
            ),
          ],
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authenticatedProvider.overrideWithValue(true),
          downloadDirectoryProvider.overrideWithValue(null),
          handProvider.overrideWithValue(Hand.right),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.more_horiz));
    await tester.pumpAndSettle();
  }

  testWidgets('Report opens the ticket the submission links to', (
    tester,
  ) async {
    final Submission submission = read('view_member');
    await show(tester, submission);
    await tester.tap(find.text('Report'));
    await tester.pumpAndSettle();
    expect(
      find.text('$browsePath$reportPath report ${submission.reportLink}'),
      findsOneWidget,
    );
  });

  testWidgets('a submission without a report link offers no Report', (
    tester,
  ) async {
    await show(tester, read('view'));
    expect(find.text('Open in browser'), findsOneWidget);
    expect(find.text('Report'), findsNothing);
  });
}
