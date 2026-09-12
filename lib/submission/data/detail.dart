import 'package:furlovin/comment/comment.dart';
import 'package:furlovin/submission/submission.dart';
import 'package:meta/meta.dart';

@immutable
class SubmissionDetail {
  const SubmissionDetail({
    required this.submission,
    this.comments = const [],
    this.related = const [],
  });

  final Submission submission;
  final List<Comment> comments;
  final List<SubmissionPreview> related;
}
