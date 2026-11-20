part of 'submission_preview.rules.dart';

class SubmissionPreviewGhost extends SubmissionPreview with Ghost {
  const SubmissionPreviewGhost([this.index = 0]) : super._();

  @override
  final int index;

  static const List<double> ratios = [1, 0.75, 1.33, 0.8, 1.5, 0.7];

  @override
  int get id => -1 - index;

  @override
  String get link => '';

  @override
  SubmissionRating get rating => SubmissionRating.general;

  @override
  String get thumbnail => '';

  @override
  String get uploader => words(1, 1);

  @override
  String? get filterTags => null;

  @override
  double? get thumbnailHeight => 200;

  @override
  double? get thumbnailWidth => 200 * ratios[count(2, ratios.length - 1)];

  @override
  String? get title => words(3, 2, 4);

  @override
  SubmissionType? get type => null;

  @override
  String? get uploaderName => words(1, 1);

  @override
  Map<String, ParseException> get failed => const {};

  @override
  $SubmissionPreviewCopyWith<SubmissionPreview> get copyWith =>
      throw GhostsAreIntangibleError(this, 'Cannot copy a ghost.');
}
