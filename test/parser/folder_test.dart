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
          ?row.within(const GallerySource.main('indigo')),
      ],
    );

    test('finds every folder, grouped or not', () {
      expect(folders, hasLength(14));
      expect(folders.every((e) => e.user == 'indigo'), isTrue);
    });

    test('reads a folder completely', () {
      expect(
        folders.first,
        const Folder(
          user: 'indigo',
          id: 580876,
          slug: 'Clover',
          name: 'Clover',
          count: 13,
          group: 'Fennel',
        ),
      );
    });

    test('tells same named folders apart by group', () {
      expect(folders.where((e) => e.name == 'Hazel1').map((e) => e.group), [
        'Heath Quince',
        'Yarrow Damson',
        'Elder Gorse Tansy32',
      ]);
    });

    test('leaves folders outside any heading without a group', () {
      final Folder loose = folders.last;
      expect(loose.name, 'Elder1 Clover1');
      expect(loose.count, 67);
      expect(loose.group, isNull);
    });

    test('keeps a slug FA could not write', () {
      expect(folders.singleWhere((e) => e.id == 1518630).slug, '-');
    });
  });

  group('open folder', () {
    const GallerySource open = GallerySource.folder(
      'fennel',
      1255257,
      'Characters',
    );
    late List<FolderRow> entries;

    setUpAll(() => entries = rows('folder_grouped'));

    test('keeps the open folder in its place without a link', () {
      expect(entries, hasLength(14));
      final int at = entries.indexWhere((e) => e.id == null);
      expect(entries[at].name, 'Hazel1');
      expect(entries[at].group, 'Yarrow Damson');
      expect(entries[at].count, 9);
      expect(entries[at - 1].group, 'Heath Quince');
      expect(entries[at + 1].group, 'Elder Gorse Tansy32');
    });

    test('takes the open folder identity from the request', () {
      final List<Folder> folders = [
        for (final FolderRow entry in entries) ?entry.within(open),
      ];
      expect(folders, hasLength(14));
      expect(
        folders.singleWhere(open.holds),
        const Folder(
          user: 'fennel',
          id: 1255257,
          slug: 'Characters',
          name: 'Hazel1',
          count: 9,
          group: 'Yarrow Damson',
        ),
      );
    });

    test('the main gallery and scraps are not folder rows', () {
      expect(rows('gallery_folders').where((e) => e.id == null), isEmpty);
    });

    test('a row without a link is dropped outside a folder page', () {
      expect(
        entries.map((e) => e.within(const GallerySource.main('fennel'))),
        contains(isNull),
      );
    });
  });

  test('collapses whitespace inside a folder name like a browser', () {
    final Document page = html.parse('''
      <div class="submission-folder">
        <a href="/gallery/someone/folder/7/wide/" title="3 submissions">
          <span>
            very

                  wide   name  </span>
        </a>
      </div>
    ''');
    final Folder folder = Folder.fromOutcome(
      children(loose(page), 'folders').single,
    )!;
    expect(folder.name, 'very wide name');
  });

  group('submission page', () {
    test('lists the folders a submission sits in, without groups', () {
      expect(submission('view_folders').folders, const [
        Folder(
          user: 'quince',
          id: 1728686,
          slug: 'yarrow4',
          name: 'yarrow4',
          count: 89,
        ),
        Folder(
          user: 'quince',
          id: 1253800,
          slug: 'OLIVE1',
          name: 'OLIVE1',
          count: 9,
        ),
      ]);
    });

    test('splits the mini gallery around the submission', () {
      final MiniGallery gallery = submission('view_comments').miniGallery!;
      final List<int> newer = gallery.newer.map((e) => e.id).toList();
      final List<int> older = gallery.older.map((e) => e.id).toList();
      expect(newer, [25397113, 25592827, 28056445]);
      expect(older, [26248825, 23358717, 27492451]);
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
      expect(gallery.newer.map((e) => e.id), [25397113, 25592827, 28056445]);
      expect(gallery.older.map((e) => e.id), [26248825, 23358717, 27492451]);
    });

    test('names the listing the neighbours come from', () {
      final MiniGallery gallery = submission('view_comments').miniGallery!;
      expect(gallery.link, 'https://www.furaffinity.net/gallery/fennel/');
      expect(gallery.count, 822);
      expect(gallery.name, isNotEmpty);
    });
  });
}
