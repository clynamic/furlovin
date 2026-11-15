import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:material_ui/material_ui.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<void> _show(WidgetTester tester, FaFailureView view) =>
    tester.pumpWidget(
      ProviderScope(
        overrides: [
          packageInfoProvider.overrideWith(
            (ref) => PackageInfo(
              appName: 'furlovin',
              packageName: 'furlovin',
              version: '0.0.0',
              buildNumber: '1',
            ),
          ),
        ],
        child: MaterialApp(home: Scaffold(body: view)),
      ),
    );

ParseFailure _unreadable() => ParseFailure(
  'submission',
  DocumentErrors(page: 'https://www.furaffinity.net/view/1/', rules: '1/2')
    ..add(
      const FieldError(
        path: 'submission',
        kind: FieldErrorKind.missing,
        error: NoMatch(causes: [EmptyStep(1, 'select "#submission"')]),
      ),
    ),
);

void main() {
  testWidgets('the failure text for a rejected request carries its status '
      'code', (tester) async {
    await _show(tester, const FaFailureView(RequestRejected(400)));
    expect(find.textContaining('400'), findsOneWidget);
  });

  testWidgets('a rejected request withholds retry', (tester) async {
    await _show(
      tester,
      FaFailureView(const RequestRejected(400), onRetry: () {}),
    );
    expect(find.text('Try again'), findsNothing);
  });

  testWidgets('a snackbar carries the same sentence as the page detail', (
    tester,
  ) async {
    const RateLimited failure = RateLimited(Duration(seconds: 30));
    expect(describeFailure(failure), contains('30'));
    await _show(tester, const FaFailureView(failure));
    expect(find.text(describeFailure(failure)), findsOneWidget);
  });

  testWidgets('a disabled account offers no retry', (tester) async {
    await _show(tester, FaFailureView(const AccountDisabled(), onRetry: () {}));
    expect(find.text('Try again'), findsNothing);
  });

  testWidgets('a lost connection offers retry', (tester) async {
    await _show(
      tester,
      FaFailureView(const TransportFailure('offline'), onRetry: () {}),
    );
    expect(find.text('Try again'), findsOneWidget);
  });

  testWidgets('an unreadable page withholds retry', (tester) async {
    await _show(tester, FaFailureView(_unreadable(), onRetry: () {}));
    expect(find.text('Unreadable page'), findsOneWidget);
    expect(find.text('Try again'), findsNothing);
  });

  testWidgets('an unreadable page copies its details from the dialog', (
    tester,
  ) async {
    final List<String> copied = [];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied.add((call.arguments as Map)['text'] as String);
        }
        return null;
      },
    );
    await _show(tester, FaFailureView(_unreadable()));
    await tester.tap(find.text('Show details'));
    await tester.pumpAndSettle();
    expect(find.text('This page could not be read'), findsOneWidget);
    await tester.tap(find.text('Copy details'));
    await tester.pump();
    expect(copied, hasLength(1));
    expect(copied.single, contains('https://www.furaffinity.net/view/1/'));
    expect(copied.single, contains('submission missing'));
  });
}
