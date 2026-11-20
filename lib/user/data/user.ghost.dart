part of 'user.rules.dart';

class UserGhost extends User with Ghost {
  const UserGhost([this.index = 0]) : super._();

  @override
  final int index;

  @override
  String get name => words(1, 1);

  @override
  String? get avatar => null;

  @override
  String? get banner => null;

  @override
  String? get blockKey => null;

  @override
  bool? get blocked => null;

  @override
  int? get commentsEarned => count(2, 500);

  @override
  int? get commentsMade => count(3, 500);

  @override
  String? get displayName => null;

  @override
  int? get favorites => count(4, 5000);

  @override
  int? get journals => count(5, 50);

  @override
  String? get profile => words(6, 20, 60);

  @override
  DateTime? get registered => DateTime(2000 + count(7, 20));

  @override
  int? get submissions => count(8, 500);

  @override
  String? get symbol => null;

  @override
  String? get title => words(9, 2, 5);

  @override
  int? get views => count(10, 50000);

  @override
  String? get watchKey => null;

  @override
  bool? get watched => null;

  @override
  int? get watchedBy => count(11, 5000);

  @override
  int? get watching => count(12, 500);

  @override
  Map<String, ParseException> get failed => const {};

  @override
  $UserCopyWith<User> get copyWith =>
      throw GhostsAreIntangibleError(this, 'Cannot copy a ghost.');
}
