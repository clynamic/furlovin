import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:furlovin/submission/submission.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as html;

void main() {
  late RuleSet rules;

  setUpAll(() {
    rules = RuleSet.fromJson(
      decodeRules(File('assets/rules/v1.yaml').readAsStringSync()),
    );
  });

  Document fixture(String name) =>
      html.parse(File('test/_fixtures/$name.html').readAsStringSync());

  List<T> all<T>(ListSlot<T> slot, String page) => rules
      .parseSlotAll(
        rules.pages[slot.page]!.slots[slot.name]!,
        fixture(page),
        base: Uri.parse(faOrigin),
      )
      .map(slot.build)
      .whereType<T>()
      .toList();

  group('gallery sidebar', () {
    late List<Folder> folders;

    setUpAll(
      () => folders = [
        for (final FolderEntry entry in all(
          GallerySlots.folders,
          'gallery_folders',
        ))
          ?entry.within(const GallerySource.main('fennel76')),
      ],
    );

    test('finds every folder, grouped or not', () {
      expect(folders, hasLength(14));
      expect(folders.every((e) => e.user == 'fennel76'), isTrue);
    });

    test('reads a folder completely', () {
      expect(
        folders.first,
        const Folder(
          user: 'fennel76',
          id: 593014,
          slug: 'Indigo86',
          name: 'Indigo86',
          count: 11,
          group: 'Comics',
        ),
      );
    });

    test('tells same named folders apart by group', () {
      expect(folders.where((e) => e.name == 'Juniper17').map((e) => e.group), [
        'Cedar46 Mallow53',
        'Damson Damson2',
        'The First Elder27',
      ]);
    });

    test('leaves folders outside any heading without a group', () {
      final Folder loose = folders.last;
      expect(loose.name, 'Heath66 Kelp85');
      expect(loose.count, 67);
      expect(loose.group, isNull);
    });

    test('keeps a slug FA could not write', () {
      expect(folders.singleWhere((e) => e.id == 1244065).slug, '-');
    });
  });

  group('open folder', () {
    const GallerySource open = GallerySource.folder(
      'fennel76',
      1255257,
      'Juniper17',
    );
    late List<FolderEntry> entries;

    setUpAll(() => entries = all(GallerySlots.folders, 'folder_grouped'));

    test('keeps the open folder in its place without a link', () {
      expect(entries, hasLength(14));
      final int at = entries.indexWhere((e) => e.id == null);
      expect(entries[at].name, 'Juniper17');
      expect(entries[at].group, 'Damson Damson2');
      expect(entries[at].count, 9);
      expect(entries[at - 1].group, 'Cedar46 Mallow53');
      expect(entries[at + 1].group, 'The First Elder27');
    });

    test('takes the open folder identity from the request', () {
      final List<Folder> folders = [
        for (final FolderEntry entry in entries) ?entry.within(open),
      ];
      expect(folders, hasLength(14));
      expect(
        folders.singleWhere(open.holds),
        const Folder(
          user: 'fennel76',
          id: 1255257,
          slug: 'Juniper17',
          name: 'Juniper17',
          count: 9,
          group: 'Abyss Alert',
        ),
      );
    });

    test('the main gallery and scraps are not folder rows', () {
      expect(
        all(GallerySlots.folders, 'gallery_folders').where((e) => e.id == null),
        isEmpty,
      );
    });

    test('a row without a link is dropped outside a folder page', () {
      expect(
        entries.map((e) => e.within(const GallerySource.main('fennel76'))),
        contains(isNull),
      );
    });
  });

  group('submission page', () {
    test('lists the folders a submission sits in, without groups', () {
      expect(all(SubmissionSlots.folders, 'view_folders'), const [
        Folder(
          user: 'birch92',
          id: 1232817,
          slug: 'cedar94',
          name: 'cedar94',
          count: 84,
        ),
        Folder(user: 'birch92', id: 1598395, slug: 'VERVAIN72', name: 'VERVAIN72', count: 9),
      ]);
    });

    test('splits the mini gallery around the submission', () {
      final List<int> newer = [
        for (final SubmissionPreview item in all(
          SubmissionSlots.newer,
          'view_comments',
        ))
          item.id,
      ];
      final List<int> older = [
        for (final SubmissionPreview item in all(
          SubmissionSlots.older,
          'view_comments',
        ))
          item.id,
      ];
      expect(newer, [28250384, 28235854, 28196107]);
      expect(older, [28151556, 28139782, 28128819]);
    });

    test('a first submission has only older neighbours', () {
      expect(all(SubmissionSlots.newer, 'view'), isEmpty);
      expect(all(SubmissionSlots.older, 'view'), isNotEmpty);
    });

    test('names the listing the neighbours come from', () {
      final ParseOutcome outcome = rules.parseSlot(
        rules.pages['submission']!.slots['miniGallery']!,
        fixture('view_comments'),
        base: Uri.parse(faOrigin),
      );
      final MiniGallery gallery = MiniGallery.fromOutcome(outcome)!;
      expect(gallery.link, 'https://www.furaffinity.net/gallery/fennel76/');
      expect(gallery.count, 891);
      expect(gallery.name, isNotEmpty);
    });
  });
}
