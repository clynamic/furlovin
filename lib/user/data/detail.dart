import 'package:furlovin/submission/submission.dart';
import 'package:furlovin/user/user.dart';
import 'package:meta/meta.dart';

@immutable
class UserDetail {
  const UserDetail({
    required this.user,
    this.contacts = const [],
    this.facts = const [],
    this.shouts = const [],
    this.gallery = const [],
    this.favorites = const [],
  });

  final User user;
  final List<Contact> contacts;
  final List<Fact> facts;
  final List<Shout> shouts;
  final List<SubmissionPreview> gallery;
  final List<SubmissionPreview> favorites;
}
