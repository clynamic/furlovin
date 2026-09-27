import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/shared/shared.dart';

void main() {
  test('names an Android directory by its place in storage', () {
    expect(directoryLabel(androidPictures), 'Pictures');
    expect(
      directoryLabel(
        'content://com.android.externalstorage.documents/tree/primary%3APictures%2Ffurlovin',
      ),
      'Pictures/furlovin',
    );
    expect(
      directoryLabel(
        'content://com.android.externalstorage.documents/tree/primary%3A',
      ),
      'Internal storage',
    );
    expect(
      directoryLabel(
        'content://com.android.externalstorage.documents/tree/1A2B-3C4D%3AArt',
      ),
      'Art',
    );
  });

  test('names a desktop directory by its path', () {
    expect(
      directoryLabel('/home/someone/Downloads'),
      '/home/someone/Downloads',
    );
  });
}
