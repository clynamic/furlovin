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
 String? get avatar;/// How many new comments are waiting.
 int? get commentAlerts;/// The name as displayed.
 String? get displayName;/// How many new favourites are waiting.
 int? get favouriteAlerts; String? get logoutKey;/// How many new submissions are waiting.
 int? get submissionAlerts;/// How many new watchers are waiting.
 int? get watchAlerts; Map<String, ParseException> get failed;
/// Create a copy of Viewer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ViewerCopyWith<Viewer> get copyWith => _$ViewerCopyWithImpl<Viewer>(this as Viewer, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Viewer;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Viewer&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.avatar, _this.avatar) || other.avatar == _this.avatar)&&(identical(other.commentAlerts, _this.commentAlerts) || other.commentAlerts == _this.commentAlerts)&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.favouriteAlerts, _this.favouriteAlerts) || other.favouriteAlerts == _this.favouriteAlerts)&&(identical(other.logoutKey, _this.logoutKey) || other.logoutKey == _this.logoutKey)&&(identical(other.submissionAlerts, _this.submissionAlerts) || other.submissionAlerts == _this.submissionAlerts)&&(identical(other.watchAlerts, _this.watchAlerts) || other.watchAlerts == _this.watchAlerts)&&const DeepCollectionEquality().equals(other.failed, _this.failed));
}


@override
int get hashCode {
  final _this = this as Viewer;
  return Object.hash(runtimeType,_this.name,_this.avatar,_this.commentAlerts,_this.displayName,_this.favouriteAlerts,_this.logoutKey,_this.submissionAlerts,_this.watchAlerts,const DeepCollectionEquality().hash(_this.failed));
}

@override
String toString() {
  final _this = this as Viewer;
  return 'Viewer(name: ${_this.name}, avatar: ${_this.avatar}, commentAlerts: ${_this.commentAlerts}, displayName: ${_this.displayName}, favouriteAlerts: ${_this.favouriteAlerts}, logoutKey: ${_this.logoutKey}, submissionAlerts: ${_this.submissionAlerts}, watchAlerts: ${_this.watchAlerts}, failed: ${_this.failed})';
}


}

/// @nodoc
abstract mixin class $ViewerCopyWith<$Res>  {
  factory $ViewerCopyWith(Viewer value, $Res Function(Viewer) _then) = _$ViewerCopyWithImpl;
@useResult
$Res call({
 String name, String? avatar, int? commentAlerts, String? displayName, int? favouriteAlerts, String? logoutKey, int? submissionAlerts, int? watchAlerts, Map<String, ParseException> failed
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
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? avatar = freezed,Object? commentAlerts = freezed,Object? displayName = freezed,Object? favouriteAlerts = freezed,Object? logoutKey = freezed,Object? submissionAlerts = freezed,Object? watchAlerts = freezed,Object? failed = null,}) {
  return _then(Viewer(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,commentAlerts: freezed == commentAlerts ? _self.commentAlerts : commentAlerts // ignore: cast_nullable_to_non_nullable
as int?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,favouriteAlerts: freezed == favouriteAlerts ? _self.favouriteAlerts : favouriteAlerts // ignore: cast_nullable_to_non_nullable
as int?,logoutKey: freezed == logoutKey ? _self.logoutKey : logoutKey // ignore: cast_nullable_to_non_nullable
as String?,submissionAlerts: freezed == submissionAlerts ? _self.submissionAlerts : submissionAlerts // ignore: cast_nullable_to_non_nullable
as int?,watchAlerts: freezed == watchAlerts ? _self.watchAlerts : watchAlerts // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? avatar,  int? commentAlerts,  String? displayName,  int? favouriteAlerts,  String? logoutKey,  int? submissionAlerts,  int? watchAlerts,  Map<String, ParseException> failed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Viewer() when $default != null:
return $default(_that.name,_that.avatar,_that.commentAlerts,_that.displayName,_that.favouriteAlerts,_that.logoutKey,_that.submissionAlerts,_that.watchAlerts,_that.failed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? avatar,  int? commentAlerts,  String? displayName,  int? favouriteAlerts,  String? logoutKey,  int? submissionAlerts,  int? watchAlerts,  Map<String, ParseException> failed)  $default,) {final _that = this;
switch (_that) {
case _Viewer():
return $default(_that.name,_that.avatar,_that.commentAlerts,_that.displayName,_that.favouriteAlerts,_that.logoutKey,_that.submissionAlerts,_that.watchAlerts,_that.failed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? avatar,  int? commentAlerts,  String? displayName,  int? favouriteAlerts,  String? logoutKey,  int? submissionAlerts,  int? watchAlerts,  Map<String, ParseException> failed)?  $default,) {final _that = this;
switch (_that) {
case _Viewer() when $default != null:
return $default(_that.name,_that.avatar,_that.commentAlerts,_that.displayName,_that.favouriteAlerts,_that.logoutKey,_that.submissionAlerts,_that.watchAlerts,_that.failed);case _:
  return null;

}
}

}

/// @nodoc


class _Viewer extends Viewer {
  const _Viewer({required this.name, this.avatar, this.commentAlerts, this.displayName, this.favouriteAlerts, this.logoutKey, this.submissionAlerts, this.watchAlerts,  Map<String, ParseException> failed = const {}}): _failed = failed,super._();
  

/// The url form of the name, lowercased and with underscores
/// removed.
@override final  String name;
/// Absolute url of the avatar.
@override final  String? avatar;
/// How many new comments are waiting.
@override final  int? commentAlerts;
/// The name as displayed.
@override final  String? displayName;
/// How many new favourites are waiting.
@override final  int? favouriteAlerts;
@override final  String? logoutKey;
/// How many new submissions are waiting.
@override final  int? submissionAlerts;
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
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Viewer&&(identical(other.name, name) || other.name == name)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.commentAlerts, commentAlerts) || other.commentAlerts == commentAlerts)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.favouriteAlerts, favouriteAlerts) || other.favouriteAlerts == favouriteAlerts)&&(identical(other.logoutKey, logoutKey) || other.logoutKey == logoutKey)&&(identical(other.submissionAlerts, submissionAlerts) || other.submissionAlerts == submissionAlerts)&&(identical(other.watchAlerts, watchAlerts) || other.watchAlerts == watchAlerts)&&const DeepCollectionEquality().equals(other.failed, _failed));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name,avatar,commentAlerts,displayName,favouriteAlerts,logoutKey,submissionAlerts,watchAlerts,const DeepCollectionEquality().hash(_failed));
}

@override
String toString() {
    return 'Viewer(name: $name, avatar: $avatar, commentAlerts: $commentAlerts, displayName: $displayName, favouriteAlerts: $favouriteAlerts, logoutKey: $logoutKey, submissionAlerts: $submissionAlerts, watchAlerts: $watchAlerts, failed: $failed)';
}


}

/// @nodoc
abstract mixin class _$ViewerCopyWith<$Res> implements $ViewerCopyWith<$Res> {
  factory _$ViewerCopyWith(_Viewer value, $Res Function(_Viewer) _then) = __$ViewerCopyWithImpl;
@override @useResult
$Res call({
 String name, String? avatar, int? commentAlerts, String? displayName, int? favouriteAlerts, String? logoutKey, int? submissionAlerts, int? watchAlerts, Map<String, ParseException> failed
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
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? avatar = freezed,Object? commentAlerts = freezed,Object? displayName = freezed,Object? favouriteAlerts = freezed,Object? logoutKey = freezed,Object? submissionAlerts = freezed,Object? watchAlerts = freezed,Object? failed = null,}) {
  return _then(_Viewer(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,commentAlerts: freezed == commentAlerts ? _self.commentAlerts : commentAlerts // ignore: cast_nullable_to_non_nullable
as int?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,favouriteAlerts: freezed == favouriteAlerts ? _self.favouriteAlerts : favouriteAlerts // ignore: cast_nullable_to_non_nullable
as int?,logoutKey: freezed == logoutKey ? _self.logoutKey : logoutKey // ignore: cast_nullable_to_non_nullable
as String?,submissionAlerts: freezed == submissionAlerts ? _self.submissionAlerts : submissionAlerts // ignore: cast_nullable_to_non_nullable
as int?,watchAlerts: freezed == watchAlerts ? _self.watchAlerts : watchAlerts // ignore: cast_nullable_to_non_nullable
as int?,failed: null == failed ? _self._failed : failed // ignore: cast_nullable_to_non_nullable
as Map<String, ParseException>,
  ));
}


}

// dart format on
