import 'package:furlovin/shared/shared.dart';
import 'package:furlovin/submission/submission.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SubmissionPreviewGhost extends Ghost<SubmissionPreview> {
  const SubmissionPreviewGhost();

  static const List<double> ratios = [1, 0.75, 1.33, 0.8, 1.5, 0.7];

  @override
  SubmissionPreview at(int index) => SubmissionPreview(
    id: -1 - index,
    title: BoneMock.words(2 + index % 3),
    uploader: BoneMock.name,
    uploaderName: BoneMock.name,
    rating: SubmissionRating.general,
    link: '',
    thumbnail: '',
    thumbnailWidth: 200 * ratios[index % ratios.length],
    thumbnailHeight: 200,
  );
}

String submissionHeroTag(int id) => 'submission-$id';

extension SubmissionTypeViewing on SubmissionType? {
  bool get isViewable => this == null || this == SubmissionType.image;
}
