import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:html/parser.dart' as html;

void main() {
  late RuleSet current;
  late TypeSet draft;

  setUpAll(() {
    current = RuleSet.fromJson(
      decodeRules(File('assets/rules/v1.yaml').readAsStringSync()),
    );
    draft = TypeSet.fromJson(
      decodeRules(File('test/_rules/types.yaml').readAsStringSync()),
    );
  });

  String fixture(String name) =>
      File('test/_fixtures/$name.html').readAsStringSync();

  PageOutcome flat(String page, String name) => current.parseDocument(
    page,
    html.parse(fixture(name)),
    base: Uri.parse(faOrigin),
  );

  ParseOutcome tree(String page, String name) => draft.parsePage(
    page,
    html.parse(fixture(name)),
    base: Uri.parse(faOrigin),
  );

  void same(
    Iterable<ParseOutcome> before,
    Iterable<ParseOutcome> after,
    String what, {
    required String entity,
  }) {
    final Iterable<String> required = current[entity]!.fields.entries
        .where((e) => e.value.required)
        .map((e) => e.key);
    final List<ParseOutcome> old = before
        .where((e) => required.every((field) => e[field] != null))
        .toList();
    expect(after.length, old.length, reason: '$what count');
    for (final (int at, ParseOutcome item) in after.indexed) {
      for (final MapEntry<String, Object?> value in item.values.entries) {
        if (value.value is ParseOutcome || value.value is List<ParseOutcome>) {
          continue;
        }
        if (!old[at].values.containsKey(value.key)) continue;
        expect(
          value.value,
          old[at].values[value.key],
          reason: '$what[$at].${value.key}',
        );
      }
    }
  }

  List<ParseOutcome> list(ParseOutcome outcome, String field) =>
      (outcome[field] as List?)?.cast<ParseOutcome>() ?? const [];

  test('the draft rules load', () {
    expect(draft.types.values.where((e) => e.page), hasLength(9));
  });

  for (final String name in ['browse']) {
    test('browse reads the same from $name', () {
      same(
        flat('browse', name).items['submissions']!,
        list(tree('browsePage', name), 'submissions'),
        'submissions',
        entity: 'submissionPreview',
      );
    });
  }

  for (final String name in ['gallery_folders', 'folder_grouped']) {
    test('gallery reads the same from $name', () {
      final PageOutcome before = flat('gallery', name);
      final ParseOutcome after = tree('galleryPage', name);
      same(
        before.items['submissions']!,
        list(after, 'submissions'),
        'submissions',
        entity: 'submissionPreview',
      );
      same(
        before.items['folders']!,
        list(after, 'folders'),
        'folders',
        entity: 'folderEntry',
      );
      expect(after.failed, isEmpty);
    });
  }

  test('favourites nest the preview under the favourite', () {
    final List<ParseOutcome> before = flat(
      'favorites',
      'favorites',
    ).items['submissions']!;
    final List<ParseOutcome> after = list(
      tree('favoritesPage', 'favorites'),
      'favorites',
    );
    same(
      before,
      [
        for (final ParseOutcome item in after)
          item['submission']! as ParseOutcome,
      ],
      'favorites',
      entity: 'submissionPreview',
    );
    expect(after.map((e) => e['id']), before.map((e) => e['favouriteId']));
  });

  for (final String name in ['view', 'view_comments', 'view_folders']) {
    test('submission page reads the same from $name', () {
      final PageOutcome before = flat('submission', name);
      final ParseOutcome after = tree('submissionPage', name);
      same(
        [before.single['submission']!],
        [after['submission']! as ParseOutcome],
        'submission',
        entity: 'submission',
      );
      expect(
        (after['submission']! as ParseOutcome)['tags'],
        before.single['submission']!['tags'],
      );
      same(
        before.items['comments']!,
        list(after, 'comments'),
        'comments',
        entity: 'comment',
      );
      same(
        before.items['folders']!,
        list(after, 'folders'),
        'folders',
        entity: 'folder',
      );
      final ParseOutcome? gallery = after['miniGallery'] as ParseOutcome?;
      same(
        [?before.single['miniGallery']],
        [?gallery],
        'miniGallery',
        entity: 'miniGallery',
      );
      same(
        before.items['newer']!,
        [if (gallery != null) ...list(gallery, 'newer')],
        'newer',
        entity: 'submissionPreview',
      );
      same(
        before.items['older']!,
        [if (gallery != null) ...list(gallery, 'older')],
        'older',
        entity: 'submissionPreview',
      );
      expect(after.failed, isEmpty);
    });
  }

  for (final String name in ['user', 'user_full']) {
    test('user page reads the same from $name', () {
      final PageOutcome before = flat('user', name);
      final ParseOutcome after = tree('userPage', name);
      same(
        [before.single['profile']!],
        [after['user']! as ParseOutcome],
        'user',
        entity: 'user',
      );
      for (final (String slot, String entity) in [
        ('contacts', 'contact'),
        ('facts', 'fact'),
        ('shouts', 'shout'),
        ('gallery', 'submissionPreview'),
        ('favorites', 'submissionPreview'),
      ]) {
        same(before.items[slot]!, list(after, slot), slot, entity: entity);
      }
    });
  }
}
