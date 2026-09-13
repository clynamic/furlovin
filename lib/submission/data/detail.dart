import 'package:furlovin/comment/comment.dart';
import 'package:furlovin/submission/submission.dart';
import 'package:meta/meta.dart';

@immutable
class SubmissionDetail {
  const SubmissionDetail({
    required this.submission,
    this.comments = const [],
    this.miniGallery,
    this.newer = const [],
    this.older = const [],
    this.folders = const [],
  });

  final Submission submission;
  final List<Comment> comments;
  final MiniGallery? miniGallery;
  final List<SubmissionPreview> newer;
  final List<SubmissionPreview> older;
  final List<Folder> folders;
}
