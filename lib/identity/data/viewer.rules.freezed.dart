// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'viewer.rules.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Viewer {

/// The url form of the name, lowercased and with underscores
/// removed.
 String get name;/// Absolute url of the avatar.
 String? get avatar; String? get blocklistKey;/// How many new comments are waiting.
 int? get commentAlerts;/// The name as displayed.
 String? get displayName;/// How many new favourites are waiting.
 int? get favouriteAlerts;/// Whether the account hides work that carries no tags besides the four
/// meta tags the site adds.
 bool? get hideTagless; String? get logoutKey;/// How many new submissions are waiting.
 int? get submissionAlerts; String? get tagBlocklist;/// Blocked member names, separated by spaces. Empty while
/// hideBlockedContent is off.
 String? get userBlocklist;/// How many new watchers are waiting.
 int? get watchAlerts; Map<String, ParseException> get failed;
/// Create a copy of Viewer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ViewerCopyWith<Viewer> get copyWith => _$ViewerCopyWithImpl<Viewer>(this as Viewer, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Viewer;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Viewer&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.avatar, _this.avatar) || other.avatar == _this.avatar)&&(identical(other.blocklistKey, _this.blocklistKey) || other.blocklistKey == _this.blocklistKey)&&(identical(other.commentAlerts, _this.commentAlerts) || other.commentAlerts == _this.commentAlerts)&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.favouriteAlerts, _this.favouriteAlerts) || other.favouriteAlerts == _this.favouriteAlerts)&&(identical(other.hideTagless, _this.hideTagless) || other.hideTagless == _this.hideTagless)&&(identical(other.logoutKey, _this.logoutKey) || other.logoutKey == _this.logoutKey)&&(identical(other.submissionAlerts, _this.submissionAlerts) || other.submissionAlerts == _this.submissionAlerts)&&(identical(other.tagBlocklist, _this.tagBlocklist) || other.tagBlocklist == _this.tagBlocklist)&&(identical(other.userBlocklist, _this.userBlocklist) || other.userBlocklist == _this.userBlocklist)&&(identical(other.watchAlerts, _this.watchAlerts) || other.watchAlerts == _this.watchAlerts)&&const DeepCollectionEquality().equals(other.failed, _this.failed));
}


@override
int get hashCode {
  final _this = this as Viewer;
  return Object.hash(runtimeType,_this.name,_this.avatar,_this.blocklistKey,_this.commentAlerts,_this.displayName,_this.favouriteAlerts,_this.hideTagless,_this.logoutKey,_this.submissionAlerts,_this.tagBlocklist,_this.userBlocklist,_this.watchAlerts,const DeepCollectionEquality().hash(_this.failed));
}

@override
String toString() {
  final _this = this as Viewer;
  return 'Viewer(name: ${_this.name}, avatar: ${_this.avatar}, blocklistKey: ${_this.blocklistKey}, commentAlerts: ${_this.commentAlerts}, displayName: ${_this.displayName}, favouriteAlerts: ${_this.favouriteAlerts}, hideTagless: ${_this.hideTagless}, logoutKey: ${_this.logoutKey}, submissionAlerts: ${_this.submissionAlerts}, tagBlocklist: ${_this.tagBlocklist}, userBlocklist: ${_this.userBlocklist}, watchAlerts: ${_this.watchAlerts}, failed: ${_this.failed})';
}


}

/// @nodoc
abstract mixin class $ViewerCopyWith<$Res>  {
  factory $ViewerCopyWith(Viewer value, $Res Function(Viewer) _then) = _$ViewerCopyWithImpl;
@useResult
$Res call({
 String name, String? avatar, String? blocklistKey, int? commentAlerts, String? displayName, int? favouriteAlerts, bool? hideTagless, String? logoutKey, int? submissionAlerts, String? tagBlocklist, String? userBlocklist, int? watchAlerts, Map<String, ParseException> failed
});




}
/// @nodoc
class _$ViewerCopyWithImpl<$Res>
    implements $ViewerCopyWith<$Res> {
  _$ViewerCopyWithImpl(this._self, this._then);

  final Viewer _self;
  final $Res Function(Viewer) _then;

/// Create a copy of Viewer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? avatar = freezed,Object? blocklistKey = freezed,Object? commentAlerts = freezed,Object? displayName = freezed,Object? favouriteAlerts = freezed,Object? hideTagless = freezed,Object? logoutKey = freezed,Object? submissionAlerts = freezed,Object? tagBlocklist = freezed,Object? userBlocklist = freezed,Object? watchAlerts = freezed,Object? failed = null,}) {
  return _then(Viewer(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,blocklistKey: freezed == blocklistKey ? _self.blocklistKey : blocklistKey // ignore: cast_nullable_to_non_nullable
as String?,commentAlerts: freezed == commentAlerts ? _self.commentAlerts : commentAlerts // ignore: cast_nullable_to_non_nullable
as int?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,favouriteAlerts: freezed == favouriteAlerts ? _self.favouriteAlerts : favouriteAlerts // ignore: cast_nullable_to_non_nullable
as int?,hideTagless: freezed == hideTagless ? _self.hideTagless : hideTagless // ignore: cast_nullable_to_non_nullable
as bool?,logoutKey: freezed == logoutKey ? _self.logoutKey : logoutKey // ignore: cast_nullable_to_non_nullable
as String?,submissionAlerts: freezed == submissionAlerts ? _self.submissionAlerts : submissionAlerts // ignore: cast_nullable_to_non_nullable
as int?,tagBlocklist: freezed == tagBlocklist ? _self.tagBlocklist : tagBlocklist // ignore: cast_nullable_to_non_nullable
as String?,userBlocklist: freezed == userBlocklist ? _self.userBlocklist : userBlocklist // ignore: cast_nullable_to_non_nullable
as String?,watchAlerts: freezed == watchAlerts ? _self.watchAlerts : watchAlerts // ignore: cast_nullable_to_non_nullable
as int?,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as Map<String, ParseException>,
  ));
}

}


/// Adds pattern-matching-related methods to [Viewer].
extension ViewerPatterns on Viewer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Viewer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Viewer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Viewer value)  $default,){
final _that = this;
switch (_that) {
case _Viewer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Viewer value)?  $default,){
final _that = this;
switch (_that) {
case _Viewer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? avatar,  String? blocklistKey,  int? commentAlerts,  String? displayName,  int? favouriteAlerts,  bool? hideTagless,  String? logoutKey,  int? submissionAlerts,  String? tagBlocklist,  String? userBlocklist,  int? watchAlerts,  Map<String, ParseException> failed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Viewer() when $default != null:
return $default(_that.name,_that.avatar,_that.blocklistKey,_that.commentAlerts,_that.displayName,_that.favouriteAlerts,_that.hideTagless,_that.logoutKey,_that.submissionAlerts,_that.tagBlocklist,_that.userBlocklist,_that.watchAlerts,_that.failed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? avatar,  String? blocklistKey,  int? commentAlerts,  String? displayName,  int? favouriteAlerts,  bool? hideTagless,  String? logoutKey,  int? submissionAlerts,  String? tagBlocklist,  String? userBlocklist,  int? watchAlerts,  Map<String, ParseException> failed)  $default,) {final _that = this;
switch (_that) {
case _Viewer():
return $default(_that.name,_that.avatar,_that.blocklistKey,_that.commentAlerts,_that.displayName,_that.favouriteAlerts,_that.hideTagless,_that.logoutKey,_that.submissionAlerts,_that.tagBlocklist,_that.userBlocklist,_that.watchAlerts,_that.failed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? avatar,  String? blocklistKey,  int? commentAlerts,  String? displayName,  int? favouriteAlerts,  bool? hideTagless,  String? logoutKey,  int? submissionAlerts,  String? tagBlocklist,  String? userBlocklist,  int? watchAlerts,  Map<String, ParseException> failed)?  $default,) {final _that = this;
switch (_that) {
case _Viewer() when $default != null:
return $default(_that.name,_that.avatar,_that.blocklistKey,_that.commentAlerts,_that.displayName,_that.favouriteAlerts,_that.hideTagless,_that.logoutKey,_that.submissionAlerts,_that.tagBlocklist,_that.userBlocklist,_that.watchAlerts,_that.failed);case _:
  return null;

}
}

}

/// @nodoc


class _Viewer extends Viewer {
  const _Viewer({required this.name, this.avatar, this.blocklistKey, this.commentAlerts, this.displayName, this.favouriteAlerts, this.hideTagless, this.logoutKey, this.submissionAlerts, this.tagBlocklist, this.userBlocklist, this.watchAlerts,  Map<String, ParseException> failed = const {}}): _failed = failed,super._();
  

/// The url form of the name, lowercased and with underscores
/// removed.
@override final  String name;
/// Absolute url of the avatar.
@override final  String? avatar;
@override final  String? blocklistKey;
/// How many new comments are waiting.
@override final  int? commentAlerts;
/// The name as displayed.
@override final  String? displayName;
/// How many new favourites are waiting.
@override final  int? favouriteAlerts;
/// Whether the account hides work that carries no tags besides the four
/// meta tags the site adds.
@override final  bool? hideTagless;
@override final  String? logoutKey;
/// How many new submissions are waiting.
@override final  int? submissionAlerts;
@override final  String? tagBlocklist;
/// Blocked member names, separated by spaces. Empty while
/// hideBlockedContent is off.
@override final  String? userBlocklist;
/// How many new watchers are waiting.
@override final  int? watchAlerts;
 final  Map<String, ParseException> _failed;
@override@JsonKey() Map<String, ParseException> get failed {
  if (_failed is EqualUnmodifiableMapView) return _failed;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_failed);
}


/// Create a copy of Viewer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ViewerCopyWith<_Viewer> get copyWith => __$ViewerCopyWithImpl<_Viewer>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Viewer&&(identical(other.name, name) || other.name == name)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.blocklistKey, blocklistKey) || other.blocklistKey == blocklistKey)&&(identical(other.commentAlerts, commentAlerts) || other.commentAlerts == commentAlerts)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.favouriteAlerts, favouriteAlerts) || other.favouriteAlerts == favouriteAlerts)&&(identical(other.hideTagless, hideTagless) || other.hideTagless == hideTagless)&&(identical(other.logoutKey, logoutKey) || other.logoutKey == logoutKey)&&(identical(other.submissionAlerts, submissionAlerts) || other.submissionAlerts == submissionAlerts)&&(identical(other.tagBlocklist, tagBlocklist) || other.tagBlocklist == tagBlocklist)&&(identical(other.userBlocklist, userBlocklist) || other.userBlocklist == userBlocklist)&&(identical(other.watchAlerts, watchAlerts) || other.watchAlerts == watchAlerts)&&const DeepCollectionEquality().equals(other.failed, _failed));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name,avatar,blocklistKey,commentAlerts,displayName,favouriteAlerts,hideTagless,logoutKey,submissionAlerts,tagBlocklist,userBlocklist,watchAlerts,const DeepCollectionEquality().hash(_failed));
}

@override
String toString() {
    return 'Viewer(name: $name, avatar: $avatar, blocklistKey: $blocklistKey, commentAlerts: $commentAlerts, displayName: $displayName, favouriteAlerts: $favouriteAlerts, hideTagless: $hideTagless, logoutKey: $logoutKey, submissionAlerts: $submissionAlerts, tagBlocklist: $tagBlocklist, userBlocklist: $userBlocklist, watchAlerts: $watchAlerts, failed: $failed)';
}


}

/// @nodoc
abstract mixin class _$ViewerCopyWith<$Res> implements $ViewerCopyWith<$Res> {
  factory _$ViewerCopyWith(_Viewer value, $Res Function(_Viewer) _then) = __$ViewerCopyWithImpl;
@override @useResult
$Res call({
 String name, String? avatar, String? blocklistKey, int? commentAlerts, String? displayName, int? favouriteAlerts, bool? hideTagless, String? logoutKey, int? submissionAlerts, String? tagBlocklist, String? userBlocklist, int? watchAlerts, Map<String, ParseException> failed
});




}
/// @nodoc
class __$ViewerCopyWithImpl<$Res>
    implements _$ViewerCopyWith<$Res> {
  __$ViewerCopyWithImpl(this._self, this._then);

  final _Viewer _self;
  final $Res Function(_Viewer) _then;

/// Create a copy of Viewer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? avatar = freezed,Object? blocklistKey = freezed,Object? commentAlerts = freezed,Object? displayName = freezed,Object? favouriteAlerts = freezed,Object? hideTagless = freezed,Object? logoutKey = freezed,Object? submissionAlerts = freezed,Object? tagBlocklist = freezed,Object? userBlocklist = freezed,Object? watchAlerts = freezed,Object? failed = null,}) {
  return _then(_Viewer(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,blocklistKey: freezed == blocklistKey ? _self.blocklistKey : blocklistKey // ignore: cast_nullable_to_non_nullable
as String?,commentAlerts: freezed == commentAlerts ? _self.commentAlerts : commentAlerts // ignore: cast_nullable_to_non_nullable
as int?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,favouriteAlerts: freezed == favouriteAlerts ? _self.favouriteAlerts : favouriteAlerts // ignore: cast_nullable_to_non_nullable
as int?,hideTagless: freezed == hideTagless ? _self.hideTagless : hideTagless // ignore: cast_nullable_to_non_nullable
as bool?,logoutKey: freezed == logoutKey ? _self.logoutKey : logoutKey // ignore: cast_nullable_to_non_nullable
as String?,submissionAlerts: freezed == submissionAlerts ? _self.submissionAlerts : submissionAlerts // ignore: cast_nullable_to_non_nullable
as int?,tagBlocklist: freezed == tagBlocklist ? _self.tagBlocklist : tagBlocklist // ignore: cast_nullable_to_non_nullable
as String?,userBlocklist: freezed == userBlocklist ? _self.userBlocklist : userBlocklist // ignore: cast_nullable_to_non_nullable
as String?,watchAlerts: freezed == watchAlerts ? _self.watchAlerts : watchAlerts // ignore: cast_nullable_to_non_nullable
as int?,failed: null == failed ? _self._failed : failed // ignore: cast_nullable_to_non_nullable
as Map<String, ParseException>,
  ));
}


}

// dart format on
