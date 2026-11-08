import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:html/parser.dart' as html;
import 'package:material_ui/material_ui.dart';

import '../_support/documents.dart';

const String _page = '''
<html><body><form id="new-ticket" action="/controls/newticket/">
  <select name="issuetype">
    <option class="default-value" value="-1" selected>--Select an Option--</option>
    <optgroup label="General"><option value="38">Feedback</option></optgroup>
    <optgroup label="Code of Conduct"><option value="18">Spam</option></optgroup>
  </select>
  <input type="text" name="other" value="" maxlength="70">
  <textarea name="message" minlength="1" maxlength="1028" required>Content URL: https://www.furaffinity.net/view/1
Relevant details (Required):</textarea>
  <label><input type="checkbox" name="sharenotes" value="1"> Let staff read linked notes.</label>
  <input type="submit" value="Create Ticket">
</form></body></html>''';

class _Staff extends ViewerClient {
  _Staff({this.refusal}) : super(client: FaClient(), rules: loadRules());

  final FaException? refusal;
  final List<List<FormEntry>> filed = [];

  @override
  Future<TicketDocument> ticket(String link) async =>
      TicketDocument.fromOutcome(
        rules.parsePage(
          TicketDocument.ruleType,
          html.parse(_page),
          base: Uri.parse(faOrigin),
        ),
      )!;

  @override
  Future<void> fileTicket(FormRequest form) async {
    filed.add(form.entries);
    if (refusal case final FaException error) throw error;
  }
}

void main() {
  Future<void> open(
    WidgetTester tester,
    _Staff staff, {
    BottomClaim? claim,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [viewerClientProvider.overrideWith((ref) async => staff)],
        child: MaterialApp(
          builder: (context, child) =>
              BottomClaimScope(claim: claim ?? BottomClaim(), child: child!),
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => const ReportPage(link: ticketsPath),
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
  }

  Future<void> pick(WidgetTester tester, String issue) async {
    await tester.tap(find.byType(DropdownButtonFormField<int>));
    await tester.pumpAndSettle();
    await tester.tap(find.text(issue).last);
    await tester.pumpAndSettle();
  }

  FilledButton send(WidgetTester tester) => tester.widget<FilledButton>(
    find.ancestor(
      of: find.text('Send report'),
      matching: find.byWidgetPredicate((e) => e is FilledButton),
    ),
  );

  testWidgets('sends the report once an issue is picked and confirmed', (
    tester,
  ) async {
    final _Staff staff = _Staff();
    await open(tester, staff);
    expect(find.textContaining('view/1'), findsOneWidget);
    expect(find.text('Let staff read linked notes.'), findsOneWidget);
    expect(send(tester).onPressed, isNull);

    await tester.tap(find.byType(DropdownButtonFormField<int>));
    await tester.pumpAndSettle();
    expect(find.text('Code of Conduct'), findsOneWidget);
    expect(find.text('--Select an Option--'), findsNothing);
    await tester.tap(find.text('Spam').last);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Details'),
      'Links to a scam in every comment',
    );
    await tester.tap(find.text('Send report'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(staff.filed, isEmpty);

    await tester.tap(find.text('Send report'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Send'));
    await tester.pumpAndSettle();

    expect(staff.filed.single, [
      (name: 'issuetype', value: '18'),
      (name: 'other', value: ''),
      (name: 'message', value: 'Links to a scam in every comment'),
    ]);
    expect(find.byType(ReportPage), findsNothing);
    expect(find.text('Report sent'), findsOneWidget);
  });

  testWidgets('a refused report keeps the page open', (tester) async {
    final _Staff staff = _Staff(refusal: const ActionRejected('Too many'));
    await open(tester, staff);
    await pick(tester, 'Feedback');
    await tester.tap(find.text('Let staff read linked notes.'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Send report'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Send'));
    await tester.pumpAndSettle();

    expect(staff.filed.single.first, (name: 'issuetype', value: '38'));
    expect(staff.filed.single.last, (name: 'sharenotes', value: '1'));
    expect(find.byType(ReportPage), findsOneWidget);
    expect(find.text('Report sent'), findsNothing);
    expect(send(tester).onPressed, isNotNull);
  });

  testWidgets('the report page hides the tab bar while open', (tester) async {
    final BottomClaim claim = BottomClaim();
    addTearDown(claim.dispose);
    await open(tester, _Staff(), claim: claim);
    expect(claim.coverage, 1);
    Navigator.of(tester.element(find.byType(ReportPage))).pop();
    await tester.pumpAndSettle();
    expect(claim.coverage, 0);
  });
}
