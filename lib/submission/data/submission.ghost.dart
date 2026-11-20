part of 'submission.rules.dart';

class SubmissionGhost extends Submission with Ghost {
  const SubmissionGhost([this.index = 0]) : super._();

  @override
  final int index;

  @override
  String get file => '';

  @override
  int get id => -1 - index;

  @override
  SubmissionRating get rating => SubmissionRating.general;

  @override
  String get title => words(1, 2, 5);

  @override
  String get uploader => words(2, 1);

  @override
  String? get category => words(3, 1);

  @override
  int? get comments => count(4, 50);

  @override
  String? get description => words(5, 20, 60);

  @override
  String? get extension => null;

  @override
  int? get favorites => count(6, 500);

  @override
  String? get favouriteLink => null;

  @override
  bool? get favourited => null;

  @override
  String? get fileSize => words(7, 1);

  @override
  String? get filterTags => null;

  @override
  String? get noteLink => null;

  @override
  DateTime? get posted => DateTime(2000 + count(8, 20));

  @override
  String? get preview => null;

  @override
  String? get reportLink => null;

  @override
  String? get resolution => words(9, 1);

  @override
  String? get species => words(10, 1, 2);

  @override
  List<String> get tags => const [];

  @override
  String? get theme => words(11, 1, 2);

  @override
  SubmissionType? get type => null;

  @override
  String? get uploaderAvatar => null;

  @override
  String? get uploaderName => null;

  @override
  int? get views => count(12, 5000);

  @override
  Map<String, ParseException> get failed => const {};

  @override
  $SubmissionCopyWith<Submission> get copyWith =>
      throw GhostsAreIntangibleError(this, 'Cannot copy a ghost.');
}
