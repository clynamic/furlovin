import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/shared/shared.dart';

void main() {
  test('names an Android folder by its place in storage', () {
    expect(folderLabel(androidPictures), 'Pictures');
    expect(
      folderLabel(
        'content://com.android.externalstorage.documents/tree/primary%3APictures%2Ffurlovin',
      ),
      'Pictures/furlovin',
    );
    expect(
      folderLabel(
        'content://com.android.externalstorage.documents/tree/primary%3A',
      ),
      'Internal storage',
    );
    expect(
      folderLabel(
        'content://com.android.externalstorage.documents/tree/1A2B-3C4D%3AArt',
      ),
      'Art',
    );
  });

  test('names a desktop folder by its path', () {
    expect(folderLabel('/home/someone/Downloads'), '/home/someone/Downloads');
  });
}
