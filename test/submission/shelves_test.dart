import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/submission/submission.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  List<Folder> folders(int count) => [
    for (int at = 0; at < count; at++)
      Folder(
        user: 'fennel',
        id: at,
        slug: 'f$at',
        name: 'folder $at',
        count: at,
      ),
  ];

  Future<void> pump(
    WidgetTester tester,
    double width,
    GallerySource source,
    List<Folder> known,
  ) {
    tester.view.physicalSize = Size(width, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GalleryShelves(
            source: source,
            folders: ValueNotifier<List<Folder>?>(known),
          ),
        ),
      ),
    );
  }

  bool visible(WidgetTester tester, String label) =>
      find.textContaining(label).hitTestable().evaluate().isNotEmpty;

  testWidgets('a narrow row keeps the open folder and offers the rest', (
    tester,
  ) async {
    await pump(
      tester,
      1000,
      const GallerySource.folder('fennel', 11, 'f11'),
      folders(12),
    );
    expect(visible(tester, 'Main Gallery'), isTrue);
    expect(visible(tester, 'Scraps'), isTrue);
    expect(visible(tester, 'folder 11'), isTrue);
    expect(visible(tester, 'folder 10'), isFalse);
    expect(visible(tester, 'All folders'), isTrue);
  });

  testWidgets('a row with room shows every folder without the dialog', (
    tester,
  ) async {
    await pump(tester, 1400, const GallerySource.main('fennel'), folders(3));
    for (final Folder folder in folders(3)) {
      expect(visible(tester, folder.name), isTrue);
    }
    expect(visible(tester, 'All folders'), isFalse);
  });

  testWidgets('a phone gives up main gallery before the open folder', (
    tester,
  ) async {
    await pump(
      tester,
      450,
      const GallerySource.folder('fennel', 11, 'f11'),
      folders(12),
    );
    expect(tester.takeException(), isNull);
    expect(visible(tester, 'folder 11'), isTrue);
    expect(visible(tester, 'All folders'), isTrue);
    expect(visible(tester, 'Main Gallery'), isFalse);
  });

  testWidgets('a folder page pins nothing before its folders load', (
    tester,
  ) async {
    await pump(
      tester,
      450,
      const GallerySource.folder('fennel', 11, 'f11'),
      const [],
    );
    expect(tester.takeException(), isNull);
    expect(visible(tester, 'Main Gallery'), isTrue);
  });
}
