// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.rules.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$User {

/// The url form of the name, lowercased and with underscores removed.
 String get name;/// Absolute url of the avatar.
 String? get avatar;/// Absolute url of the banner across the top of the profile.
 String? get banner;/// How many comments the member has received.
 int? get commentsEarned;/// How many comments the member has written.
 int? get commentsMade;/// The name as displayed.
 String? get displayName;/// How many submissions the member has favourited.
 int? get favorites;/// How many journals the member has posted.
 int? get journals;/// The profile text, as markup rather than text.
 String? get profile;/// When the account was made.
 DateTime? get registered;/// How many submissions the member has posted.
 int? get submissions;/// The account class the site marks the name with.
 String? get symbol;/// The one line the member writes under their name.
 String? get title;/// How many times the profile has been viewed.
 int? get views;/// How many members watch this one.
 int? get watchedBy;/// How many members this one watches.
 int? get watching; Map<String, ParseException> get failed;
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCopyWith<User> get copyWith => _$UserCopyWithImpl<User>(this as User, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as User;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is User&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.avatar, _this.avatar) || other.avatar == _this.avatar)&&(identical(other.banner, _this.banner) || other.banner == _this.banner)&&(identical(other.commentsEarned, _this.commentsEarned) || other.commentsEarned == _this.commentsEarned)&&(identical(other.commentsMade, _this.commentsMade) || other.commentsMade == _this.commentsMade)&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.favorites, _this.favorites) || other.favorites == _this.favorites)&&(identical(other.journals, _this.journals) || other.journals == _this.journals)&&(identical(other.profile, _this.profile) || other.profile == _this.profile)&&(identical(other.registered, _this.registered) || other.registered == _this.registered)&&(identical(other.submissions, _this.submissions) || other.submissions == _this.submissions)&&(identical(other.symbol, _this.symbol) || other.symbol == _this.symbol)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.views, _this.views) || other.views == _this.views)&&(identical(other.watchedBy, _this.watchedBy) || other.watchedBy == _this.watchedBy)&&(identical(other.watching, _this.watching) || other.watching == _this.watching)&&const DeepCollectionEquality().equals(other.failed, _this.failed));
}


@override
int get hashCode {
  final _this = this as User;
  return Object.hash(runtimeType,_this.name,_this.avatar,_this.banner,_this.commentsEarned,_this.commentsMade,_this.displayName,_this.favorites,_this.journals,_this.profile,_this.registered,_this.submissions,_this.symbol,_this.title,_this.views,_this.watchedBy,_this.watching,const DeepCollectionEquality().hash(_this.failed));
}

@override
String toString() {
  final _this = this as User;
  return 'User(name: ${_this.name}, avatar: ${_this.avatar}, banner: ${_this.banner}, commentsEarned: ${_this.commentsEarned}, commentsMade: ${_this.commentsMade}, displayName: ${_this.displayName}, favorites: ${_this.favorites}, journals: ${_this.journals}, profile: ${_this.profile}, registered: ${_this.registered}, submissions: ${_this.submissions}, symbol: ${_this.symbol}, title: ${_this.title}, views: ${_this.views}, watchedBy: ${_this.watchedBy}, watching: ${_this.watching}, failed: ${_this.failed})';
}


}

/// @nodoc
abstract mixin class $UserCopyWith<$Res>  {
  factory $UserCopyWith(User value, $Res Function(User) _then) = _$UserCopyWithImpl;
@useResult
$Res call({
 String name, String? avatar, String? banner, int? commentsEarned, int? commentsMade, String? displayName, int? favorites, int? journals, String? profile, DateTime? registered, int? submissions, String? symbol, String? title, int? views, int? watchedBy, int? watching, Map<String, ParseException> failed
});




}
/// @nodoc
class _$UserCopyWithImpl<$Res>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._self, this._then);

  final User _self;
  final $Res Function(User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? avatar = freezed,Object? banner = freezed,Object? commentsEarned = freezed,Object? commentsMade = freezed,Object? displayName = freezed,Object? favorites = freezed,Object? journals = freezed,Object? profile = freezed,Object? registered = freezed,Object? submissions = freezed,Object? symbol = freezed,Object? title = freezed,Object? views = freezed,Object? watchedBy = freezed,Object? watching = freezed,Object? failed = null,}) {
  return _then(User(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,banner: freezed == banner ? _self.banner : banner // ignore: cast_nullable_to_non_nullable
as String?,commentsEarned: freezed == commentsEarned ? _self.commentsEarned : commentsEarned // ignore: cast_nullable_to_non_nullable
as int?,commentsMade: freezed == commentsMade ? _self.commentsMade : commentsMade // ignore: cast_nullable_to_non_nullable
as int?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,favorites: freezed == favorites ? _self.favorites : favorites // ignore: cast_nullable_to_non_nullable
as int?,journals: freezed == journals ? _self.journals : journals // ignore: cast_nullable_to_non_nullable
as int?,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as String?,registered: freezed == registered ? _self.registered : registered // ignore: cast_nullable_to_non_nullable
as DateTime?,submissions: freezed == submissions ? _self.submissions : submissions // ignore: cast_nullable_to_non_nullable
as int?,symbol: freezed == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,views: freezed == views ? _self.views : views // ignore: cast_nullable_to_non_nullable
as int?,watchedBy: freezed == watchedBy ? _self.watchedBy : watchedBy // ignore: cast_nullable_to_non_nullable
as int?,watching: freezed == watching ? _self.watching : watching // ignore: cast_nullable_to_non_nullable
as int?,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as Map<String, ParseException>,
  ));
}

}


/// Adds pattern-matching-related methods to [User].
extension UserPatterns on User {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _User value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _User value)  $default,){
final _that = this;
switch (_that) {
case _User():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _User value)?  $default,){
final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? avatar,  String? banner,  int? commentsEarned,  int? commentsMade,  String? displayName,  int? favorites,  int? journals,  String? profile,  DateTime? registered,  int? submissions,  String? symbol,  String? title,  int? views,  int? watchedBy,  int? watching,  Map<String, ParseException> failed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.name,_that.avatar,_that.banner,_that.commentsEarned,_that.commentsMade,_that.displayName,_that.favorites,_that.journals,_that.profile,_that.registered,_that.submissions,_that.symbol,_that.title,_that.views,_that.watchedBy,_that.watching,_that.failed);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? avatar,  String? banner,  int? commentsEarned,  int? commentsMade,  String? displayName,  int? favorites,  int? journals,  String? profile,  DateTime? registered,  int? submissions,  String? symbol,  String? title,  int? views,  int? watchedBy,  int? watching,  Map<String, ParseException> failed)  $default,) {final _that = this;
switch (_that) {
case _User():
return $default(_that.name,_that.avatar,_that.banner,_that.commentsEarned,_that.commentsMade,_that.displayName,_that.favorites,_that.journals,_that.profile,_that.registered,_that.submissions,_that.symbol,_that.title,_that.views,_that.watchedBy,_that.watching,_that.failed);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? avatar,  String? banner,  int? commentsEarned,  int? commentsMade,  String? displayName,  int? favorites,  int? journals,  String? profile,  DateTime? registered,  int? submissions,  String? symbol,  String? title,  int? views,  int? watchedBy,  int? watching,  Map<String, ParseException> failed)?  $default,) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.name,_that.avatar,_that.banner,_that.commentsEarned,_that.commentsMade,_that.displayName,_that.favorites,_that.journals,_that.profile,_that.registered,_that.submissions,_that.symbol,_that.title,_that.views,_that.watchedBy,_that.watching,_that.failed);case _:
  return null;

}
}

}

/// @nodoc


class _User extends User {
  const _User({required this.name, this.avatar, this.banner, this.commentsEarned, this.commentsMade, this.displayName, this.favorites, this.journals, this.profile, this.registered, this.submissions, this.symbol, this.title, this.views, this.watchedBy, this.watching,  Map<String, ParseException> failed = const {}}): _failed = failed,super._();
  

/// The url form of the name, lowercased and with underscores removed.
@override final  String name;
/// Absolute url of the avatar.
@override final  String? avatar;
/// Absolute url of the banner across the top of the profile.
@override final  String? banner;
/// How many comments the member has received.
@override final  int? commentsEarned;
/// How many comments the member has written.
@override final  int? commentsMade;
/// The name as displayed.
@override final  String? displayName;
/// How many submissions the member has favourited.
@override final  int? favorites;
/// How many journals the member has posted.
@override final  int? journals;
/// The profile text, as markup rather than text.
@override final  String? profile;
/// When the account was made.
@override final  DateTime? registered;
/// How many submissions the member has posted.
@override final  int? submissions;
/// The account class the site marks the name with.
@override final  String? symbol;
/// The one line the member writes under their name.
@override final  String? title;
/// How many times the profile has been viewed.
@override final  int? views;
/// How many members watch this one.
@override final  int? watchedBy;
/// How many members this one watches.
@override final  int? watching;
 final  Map<String, ParseException> _failed;
@override@JsonKey() Map<String, ParseException> get failed {
  if (_failed is EqualUnmodifiableMapView) return _failed;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_failed);
}


/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserCopyWith<_User> get copyWith => __$UserCopyWithImpl<_User>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _User&&(identical(other.name, name) || other.name == name)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.banner, banner) || other.banner == banner)&&(identical(other.commentsEarned, commentsEarned) || other.commentsEarned == commentsEarned)&&(identical(other.commentsMade, commentsMade) || other.commentsMade == commentsMade)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.favorites, favorites) || other.favorites == favorites)&&(identical(other.journals, journals) || other.journals == journals)&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.registered, registered) || other.registered == registered)&&(identical(other.submissions, submissions) || other.submissions == submissions)&&(identical(other.symbol, symbol) || other.symbol == symbol)&&(identical(other.title, title) || other.title == title)&&(identical(other.views, views) || other.views == views)&&(identical(other.watchedBy, watchedBy) || other.watchedBy == watchedBy)&&(identical(other.watching, watching) || other.watching == watching)&&const DeepCollectionEquality().equals(other.failed, _failed));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name,avatar,banner,commentsEarned,commentsMade,displayName,favorites,journals,profile,registered,submissions,symbol,title,views,watchedBy,watching,const DeepCollectionEquality().hash(_failed));
}

@override
String toString() {
    return 'User(name: $name, avatar: $avatar, banner: $banner, commentsEarned: $commentsEarned, commentsMade: $commentsMade, displayName: $displayName, favorites: $favorites, journals: $journals, profile: $profile, registered: $registered, submissions: $submissions, symbol: $symbol, title: $title, views: $views, watchedBy: $watchedBy, watching: $watching, failed: $failed)';
}


}

/// @nodoc
abstract mixin class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) _then) = __$UserCopyWithImpl;
@override @useResult
$Res call({
 String name, String? avatar, String? banner, int? commentsEarned, int? commentsMade, String? displayName, int? favorites, int? journals, String? profile, DateTime? registered, int? submissions, String? symbol, String? title, int? views, int? watchedBy, int? watching, Map<String, ParseException> failed
});




}
/// @nodoc
class __$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(this._self, this._then);

  final _User _self;
  final $Res Function(_User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? avatar = freezed,Object? banner = freezed,Object? commentsEarned = freezed,Object? commentsMade = freezed,Object? displayName = freezed,Object? favorites = freezed,Object? journals = freezed,Object? profile = freezed,Object? registered = freezed,Object? submissions = freezed,Object? symbol = freezed,Object? title = freezed,Object? views = freezed,Object? watchedBy = freezed,Object? watching = freezed,Object? failed = null,}) {
  return _then(_User(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,banner: freezed == banner ? _self.banner : banner // ignore: cast_nullable_to_non_nullable
as String?,commentsEarned: freezed == commentsEarned ? _self.commentsEarned : commentsEarned // ignore: cast_nullable_to_non_nullable
as int?,commentsMade: freezed == commentsMade ? _self.commentsMade : commentsMade // ignore: cast_nullable_to_non_nullable
as int?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,favorites: freezed == favorites ? _self.favorites : favorites // ignore: cast_nullable_to_non_nullable
as int?,journals: freezed == journals ? _self.journals : journals // ignore: cast_nullable_to_non_nullable
as int?,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as String?,registered: freezed == registered ? _self.registered : registered // ignore: cast_nullable_to_non_nullable
as DateTime?,submissions: freezed == submissions ? _self.submissions : submissions // ignore: cast_nullable_to_non_nullable
as int?,symbol: freezed == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,views: freezed == views ? _self.views : views // ignore: cast_nullable_to_non_nullable
as int?,watchedBy: freezed == watchedBy ? _self.watchedBy : watchedBy // ignore: cast_nullable_to_non_nullable
as int?,watching: freezed == watching ? _self.watching : watching // ignore: cast_nullable_to_non_nullable
as int?,failed: null == failed ? _self._failed : failed // ignore: cast_nullable_to_non_nullable
as Map<String, ParseException>,
  ));
}


}

// dart format on
