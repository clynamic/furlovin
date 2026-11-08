import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:furlovin/routing/routing.dart';
import 'package:furlovin/user/user.dart';
import 'package:go_router/go_router.dart';
import 'package:html/parser.dart' as html;
import 'package:material_ui/material_ui.dart';

import '../_support/documents.dart';

class _Members extends UserClient {
  _Members({required this.blocked})
    : super(client: FaClient(), rules: loadRules());

  bool blocked;
  final List<String> sent = [];

  @override
  Future<UserDocument> user(String name) async {
    final String href = blocked
        ? '/unblock/$name/?key=k1'
        : '/block/$name/?key=k1';
    final String page = fixture('user_full').replaceFirst(
      '</userpage-nav-interface-buttons>',
      '<a id="block-button" href="$href">Block</a></userpage-nav-interface-buttons>',
    );
    return UserDocument.fromOutcome(
      rules.parsePage(
        UserDocument.ruleType,
        html.parse(page),
        base: Uri.parse(faOrigin),
      ),
    )!;
  }

  @override
  Future<UserActionAnswer> setUserAction(
    String name,
    UserAction action, {
    required bool active,
    required String key,
  }) async {
    sent.add('${active ? '' : 'un'}${action.name}');
    blocked = active;
    return UserActionAnswer(active: active, key: 'k2');
  }
}

void main() {
  const String name = 'fennel-v0578';

  Future<_Members> show(WidgetTester tester, {required bool blocked}) async {
    final _Members members = _Members(blocked: blocked);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionKeyProvider.overrideWithValue('member'),
          userClientProvider.overrideWith((ref) => members),
          viewerProvider.overrideWith(
            (ref) async => const Viewer(name: 'mossbadger'),
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: Consumer(
              builder: (context, ref, child) {
                final bool? shown = ref
                    .watch(userProvider(name))
                    .value
                    ?.user
                    .blocked;
                return shown == null
                    ? const SizedBox()
                    : ProfileMenu(name: name, blocked: shown);
              },
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return members;
  }

  Future<void> choose(WidgetTester tester, String item) async {
    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    await tester.tap(find.text(item));
    await tester.pumpAndSettle();
  }

  testWidgets('blocking asks first and sends only once confirmed', (
    tester,
  ) async {
    final _Members members = await show(tester, blocked: false);

    await choose(tester, 'Block user');
    expect(find.text('Block $name?'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(members.sent, isEmpty);

    await choose(tester, 'Block user');
    await tester.tap(find.widgetWithText(FilledButton, 'Block'));
    await tester.pumpAndSettle();
    expect(members.sent, ['block']);

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    expect(find.text('Unblock user'), findsOneWidget);
  });

  testWidgets('unblocking sends without asking', (tester) async {
    final _Members members = await show(tester, blocked: true);

    await choose(tester, 'Unblock user');
    expect(find.byType(AlertDialog), findsNothing);
    expect(members.sent, ['unblock']);
  });

  testWidgets('Report user opens a blank ticket', (tester) async {
    final GoRouter router = GoRouter(
      initialLocation: browsePath,
      routes: [
        GoRoute(
          path: browsePath,
          builder: (context, state) =>
              const Scaffold(body: ProfileMenu(name: name, blocked: false)),
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
      ProviderScope(child: MaterialApp.router(routerConfig: router)),
    );
    await choose(tester, 'Report user');
    expect(
      find.text('$browsePath$reportPath report $ticketsPath'),
      findsOneWidget,
    );
  });
}
