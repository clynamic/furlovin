import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:furlovin/submission/submission.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as html;

import '../_support/documents.dart';

void main() {
  late RuleSet rules;

  setUpAll(() => rules = loadRules());

  List<FolderRow> rows(String name) => GalleryDocument.fromOutcome(
    parseFixture(rules, GalleryDocument.ruleType, name),
  )!.folders;

  SubmissionDocument submission(String name) => SubmissionDocument.fromOutcome(
    parseFixture(rules, SubmissionDocument.ruleType, name),
  )!;

  ParseOutcome loose(Document page) => TreeEngine(
    types: rules,
    base: Uri.parse(faOrigin),
  ).parseType(rules[SubmissionDocument.ruleType]!, page);
  group('gallery sidebar', () {
    late List<Folder> folders;

    setUpAll(
      () => folders = [
        for (final FolderRow row in rows('gallery_folders'))
          ?row.within(const GallerySource.main('fennel76')),
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
    late List<FolderRow> entries;

    setUpAll(() => entries = rows('folder_grouped'));

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
        for (final FolderRow entry in entries) ?entry.within(open),
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
      expect(rows('gallery_folders').where((e) => e.id == null), isEmpty);
    });

    test('a row without a link is dropped outside a folder page', () {
      expect(
        entries.map((e) => e.within(const GallerySource.main('fennel76'))),
        contains(isNull),
      );
    });
  });

  test('collapses whitespace inside a folder name like a browser', () {
    final Document page = html.parse('''
      <div class="submission-folder">
        <a href="/gallery/olive96/folder/7/wide/" title="3 submissions">
          <span>
            very

                  wide   name  </span>
        </a>
      </div>
    ''');
    final Folder folder = Folder.fromOutcome(
      children(loose(page), 'folders').single,
    )!;
    expect(folder.name, 'poplar110 wide name');
  });

  group('submission page', () {
    test('lists the folders a submission sits in, without groups', () {
      expect(submission('view_folders').folders, const [
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
      final MiniGallery gallery = submission('view_comments').miniGallery!;
      final List<int> newer = gallery.newer.map((e) => e.id).toList();
      final List<int> older = gallery.older.map((e) => e.id).toList();
      expect(newer, [28250384, 28235854, 28196107]);
      expect(older, [28151556, 28139782, 28128819]);
    });

    test('a first submission has only older neighbours', () {
      final MiniGallery gallery = submission('view').miniGallery!;
      expect(gallery.newer, isEmpty);
      expect(gallery.older, isNotEmpty);
    });

    test('reads only the first mini gallery', () {
      final Document page = html.parse(fixture('view_comments'));
      final Element first = page.querySelector('div#minigallery > section')!;
      first.parent!.append(first.clone(true));
      final MiniGallery gallery = SubmissionDocument.fromOutcome(
        rules.parsePage(
          SubmissionDocument.ruleType,
          page,
          base: Uri.parse(faOrigin),
        ),
      )!.miniGallery!;
      expect(gallery.newer.map((e) => e.id), [28250384, 28235854, 28196107]);
      expect(gallery.older.map((e) => e.id), [28151556, 28139782, 28128819]);
    });

    test('names the listing the neighbours come from', () {
      final MiniGallery gallery = submission('view_comments').miniGallery!;
      expect(gallery.link, 'https://www.furaffinity.net/gallery/fennel76/');
      expect(gallery.count, 891);
      expect(gallery.name, isNotEmpty);
    });
  });
}
