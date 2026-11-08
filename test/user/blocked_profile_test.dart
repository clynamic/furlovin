import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/database/database.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:furlovin/settings/settings.dart';
import 'package:furlovin/theme/theme.dart';
import 'package:furlovin/user/user.dart';
import 'package:html/parser.dart' as html;
import 'package:material_ui/material_ui.dart';

import '../_support/documents.dart';

const String _name = 'fennel-v0578';

class _Silent implements FileService {
  @override
  int concurrentFetches = 1;

  @override
  Future<FileServiceResponse> get(String url, {Map<String, String>? headers}) =>
      Completer<FileServiceResponse>().future;
}

class _Members extends UserClient {
  _Members({required this.blocked})
    : super(client: FaClient(), rules: loadRules());

  bool blocked;

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
    blocked = active;
    return UserActionAnswer(active: active, key: 'k2');
  }
}

void main() {
  Future<void> settle(WidgetTester tester) async {
    for (int frame = 0; frame < 30; frame++) {
      await tester.pump(const Duration(milliseconds: 16));
    }
  }

  Future<void> show(WidgetTester tester, {required bool blocked}) async {
    final CacheManager cache = CacheManager(
      Config(
        'test',
        fileSystem: MemoryCacheSystem(),
        repo: NonStoringObjectProvider(),
        fileService: _Silent(),
      ),
    );
    final AppDatabase database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(database),
          preferencesProvider.overrideWith((ref) => Stream.value(const {})),
          sessionKeyProvider.overrideWithValue('member'),
          authenticatedProvider.overrideWithValue(true),
          userClientProvider.overrideWith((ref) => _Members(blocked: blocked)),
          viewerProvider.overrideWith(
            (ref) async => const Viewer(name: 'mossbadger'),
          ),
          thumbnailCacheProvider.overrideWithValue(cache),
          artworkCacheProvider.overrideWithValue(cache),
        ],
        child: MaterialApp(
          theme: buildTheme(Brightness.light),
          home: const UserPage(name: _name),
        ),
      ),
    );
    await settle(tester);
  }

  Future<void> finish(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(hours: 1));
  }

  Finder blurred() =>
      find.byWidgetPredicate((e) => e is ImageFiltered && e.enabled);

  Future<void> choose(WidgetTester tester, String item) async {
    await tester.tap(find.byIcon(Icons.more_vert));
    await settle(tester);
    await tester.tap(find.text(item));
    await settle(tester);
  }

  testWidgets('a blocked profile shows a notice in place of its content', (
    tester,
  ) async {
    await show(tester, blocked: true);
    expect(find.byType(BlockedProfileNotice), findsOneWidget);
    expect(find.byType(ProfileCounts), findsNothing);
    expect(blurred(), findsNWidgets(2));
    expect(find.byType(WatchButton), findsNothing);
    await finish(tester);
  });

  testWidgets('the notice sits centred below the name', (tester) async {
    await show(tester, blocked: true);
    final double top = tester.getBottomLeft(find.byType(ProfileIdentity)).dy;
    final Size screen = tester.view.physicalSize / tester.view.devicePixelRatio;
    final Finder icon = find.descendant(
      of: find.byType(BlockedProfileNotice),
      matching: find.byIcon(Icons.block),
    );
    final double first = tester.getTopLeft(icon).dy;
    final double last = tester.getBottomLeft(find.text('Show profile')).dy;
    expect(
      tester.getCenter(icon).dx,
      moreOrLessEquals(screen.width / 2, epsilon: 1),
    );
    expect(
      (first + last) / 2,
      moreOrLessEquals((top + screen.height) / 2, epsilon: 40),
    );
    await finish(tester);
  });

  testWidgets('Show anyway reveals the profile', (tester) async {
    await show(tester, blocked: true);
    await tester.tap(find.text('Show profile'));
    await settle(tester);
    expect(find.byType(BlockedProfileNotice), findsNothing);
    expect(find.byType(ProfileCounts), findsOneWidget);
    expect(blurred(), findsNothing);
    await finish(tester);
  });

  testWidgets('blocking a revealed profile hides it again', (tester) async {
    await show(tester, blocked: true);
    await tester.tap(find.text('Show profile'));
    await settle(tester);
    await choose(tester, 'Unblock user');
    expect(find.byType(WatchButton), findsOneWidget);
    await choose(tester, 'Block user');
    await tester.tap(find.widgetWithText(FilledButton, 'Block'));
    await settle(tester);
    expect(find.byType(BlockedProfileNotice), findsOneWidget);
    expect(find.byType(ProfileCounts), findsNothing);
    await finish(tester);
  });
}
