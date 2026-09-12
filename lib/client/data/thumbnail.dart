const List<int> thumbnailSizes = [200, 300, 400, 600];

final RegExp _sized = RegExp(r'@(\d+)-');

int thumbnailBucket(double extent) {
  for (final int size in thumbnailSizes) {
    if (size >= extent) return size;
  }
  return thumbnailSizes.last;
}

String thumbnailAt(String url, int size) {
  if (!_sized.hasMatch(url)) return url;
  return url.replaceFirst(_sized, '@$size-');
}

String thumbnailFor(String url, double extent, double pixelRatio) =>
    thumbnailAt(url, thumbnailBucket(extent * pixelRatio));
