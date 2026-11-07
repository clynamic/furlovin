import 'package:furlovin/client/client.dart';
import 'package:furlovin/submission/submission.dart';

List<FaImageRung> submissionRungs({
  required double extent,
  required double pixelRatio,
  required SubmissionPreview? preview,
  required Submission? loaded,
}) {
  final List<FaImageRung> rungs = [];

  if (preview case final SubmissionPreview value) {
    rungs.add((
      url: thumbnailFor(value.thumbnail, extent, pixelRatio),
      store: ImageStore.thumbnails,
      decodeWidth: (extent * pixelRatio).round(),
    ));
  }

  final String? middle =
      loaded?.preview ??
      (preview == null
          ? null
          : thumbnailAt(preview.thumbnail, thumbnailSizes.last));
  if (middle != null) {
    rungs.add((url: middle, store: ImageStore.thumbnails, decodeWidth: null));
  }

  if (loaded case final Submission value when value.type.isViewable) {
    if (value.file case final String file) {
      rungs.add((url: file, store: ImageStore.artwork, decodeWidth: null));
    }
  }

  return rungs;
}
