import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/client/client.dart';

const String url = 'https://t.furaffinity.net/66339591@200-1789201164.jpg';

void main() {
  group('thumbnailBucket', () {
    test('picks the smallest bucket that covers the extent', () {
      expect(thumbnailBucket(120), 200);
      expect(thumbnailBucket(200), 200);
      expect(thumbnailBucket(201), 300);
      expect(thumbnailBucket(440), 600);
    });

    test('clamps above the largest bucket', () {
      expect(thumbnailBucket(2000), 600);
    });
  });

  group('thumbnailAt', () {
    test('rewrites the size segment', () {
      expect(
        thumbnailAt(url, 600),
        'https://t.furaffinity.net/66339591@600-1789201164.jpg',
      );
    });

    test('leaves the mtime and id alone', () {
      expect(thumbnailAt(url, 400), contains('66339591@400-1789201164'));
    });

    test('returns unsized urls untouched', () {
      const String plain = 'https://d.furaffinity.net/art/someone/1/2.png';
      expect(thumbnailAt(plain, 600), plain);
    });
  });

  test('thumbnailFor accounts for pixel ratio', () {
    expect(thumbnailFor(url, 220, 1), contains('@300-'));
    expect(thumbnailFor(url, 220, 2), contains('@600-'));
    expect(thumbnailFor(url, 110, 2), contains('@300-'));
  });
}
