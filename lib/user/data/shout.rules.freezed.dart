// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shout.rules.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Shout {

/// The message's numeric identifier.
 int get id;/// The url form of the writer name.
 String? get author;/// Absolute url of the writer's avatar.
 String? get authorAvatar;/// The writer name as displayed.
 String? get authorName;/// The message, as markup rather than text.
 String? get body;/// When the message was left.
 DateTime? get posted; Map<String, String> get failed;
/// Create a copy of Shout
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShoutCopyWith<Shout> get copyWith => _$ShoutCopyWithImpl<Shout>(this as Shout, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Shout;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Shout&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.author, _this.author) || other.author == _this.author)&&(identical(other.authorAvatar, _this.authorAvatar) || other.authorAvatar == _this.authorAvatar)&&(identical(other.authorName, _this.authorName) || other.authorName == _this.authorName)&&(identical(other.body, _this.body) || other.body == _this.body)&&(identical(other.posted, _this.posted) || other.posted == _this.posted)&&const DeepCollectionEquality().equals(other.failed, _this.failed));
}


@override
int get hashCode {
  final _this = this as Shout;
  return Object.hash(runtimeType,_this.id,_this.author,_this.authorAvatar,_this.authorName,_this.body,_this.posted,const DeepCollectionEquality().hash(_this.failed));
}

@override
String toString() {
  final _this = this as Shout;
  return 'Shout(id: ${_this.id}, author: ${_this.author}, authorAvatar: ${_this.authorAvatar}, authorName: ${_this.authorName}, body: ${_this.body}, posted: ${_this.posted}, failed: ${_this.failed})';
}


}

/// @nodoc
abstract mixin class $ShoutCopyWith<$Res>  {
  factory $ShoutCopyWith(Shout value, $Res Function(Shout) _then) = _$ShoutCopyWithImpl;
@useResult
$Res call({
 int id, String? author, String? authorAvatar, String? authorName, String? body, DateTime? posted, Map<String, String> failed
});




}
/// @nodoc
class _$ShoutCopyWithImpl<$Res>
    implements $ShoutCopyWith<$Res> {
  _$ShoutCopyWithImpl(this._self, this._then);

  final Shout _self;
  final $Res Function(Shout) _then;

/// Create a copy of Shout
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? author = freezed,Object? authorAvatar = freezed,Object? authorName = freezed,Object? body = freezed,Object? posted = freezed,Object? failed = null,}) {
  return _then(Shout(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,authorAvatar: freezed == authorAvatar ? _self.authorAvatar : authorAvatar // ignore: cast_nullable_to_non_nullable
as String?,authorName: freezed == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,posted: freezed == posted ? _self.posted : posted // ignore: cast_nullable_to_non_nullable
as DateTime?,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [Shout].
extension ShoutPatterns on Shout {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Shout value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Shout() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Shout value)  $default,){
final _that = this;
switch (_that) {
case _Shout():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Shout value)?  $default,){
final _that = this;
switch (_that) {
case _Shout() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String? author,  String? authorAvatar,  String? authorName,  String? body,  DateTime? posted,  Map<String, String> failed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Shout() when $default != null:
return $default(_that.id,_that.author,_that.authorAvatar,_that.authorName,_that.body,_that.posted,_that.failed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String? author,  String? authorAvatar,  String? authorName,  String? body,  DateTime? posted,  Map<String, String> failed)  $default,) {final _that = this;
switch (_that) {
case _Shout():
return $default(_that.id,_that.author,_that.authorAvatar,_that.authorName,_that.body,_that.posted,_that.failed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String? author,  String? authorAvatar,  String? authorName,  String? body,  DateTime? posted,  Map<String, String> failed)?  $default,) {final _that = this;
switch (_that) {
case _Shout() when $default != null:
return $default(_that.id,_that.author,_that.authorAvatar,_that.authorName,_that.body,_that.posted,_that.failed);case _:
  return null;

}
}

}

/// @nodoc


class _Shout extends Shout {
  const _Shout({required this.id, this.author, this.authorAvatar, this.authorName, this.body, this.posted,  Map<String, String> failed = const {}}): _failed = failed,super._();
  

/// The message's numeric identifier.
@override final  int id;
/// The url form of the writer name.
@override final  String? author;
/// Absolute url of the writer's avatar.
@override final  String? authorAvatar;
/// The writer name as displayed.
@override final  String? authorName;
/// The message, as markup rather than text.
@override final  String? body;
/// When the message was left.
@override final  DateTime? posted;
 final  Map<String, String> _failed;
@override@JsonKey() Map<String, String> get failed {
  if (_failed is EqualUnmodifiableMapView) return _failed;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_failed);
}


/// Create a copy of Shout
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShoutCopyWith<_Shout> get copyWith => __$ShoutCopyWithImpl<_Shout>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Shout&&(identical(other.id, id) || other.id == id)&&(identical(other.author, author) || other.author == author)&&(identical(other.authorAvatar, authorAvatar) || other.authorAvatar == authorAvatar)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.body, body) || other.body == body)&&(identical(other.posted, posted) || other.posted == posted)&&const DeepCollectionEquality().equals(other.failed, _failed));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,author,authorAvatar,authorName,body,posted,const DeepCollectionEquality().hash(_failed));
}

@override
String toString() {
    return 'Shout(id: $id, author: $author, authorAvatar: $authorAvatar, authorName: $authorName, body: $body, posted: $posted, failed: $failed)';
}


}

/// @nodoc
abstract mixin class _$ShoutCopyWith<$Res> implements $ShoutCopyWith<$Res> {
  factory _$ShoutCopyWith(_Shout value, $Res Function(_Shout) _then) = __$ShoutCopyWithImpl;
@override @useResult
$Res call({
 int id, String? author, String? authorAvatar, String? authorName, String? body, DateTime? posted, Map<String, String> failed
});




}
/// @nodoc
class __$ShoutCopyWithImpl<$Res>
    implements _$ShoutCopyWith<$Res> {
  __$ShoutCopyWithImpl(this._self, this._then);

  final _Shout _self;
  final $Res Function(_Shout) _then;

/// Create a copy of Shout
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? author = freezed,Object? authorAvatar = freezed,Object? authorName = freezed,Object? body = freezed,Object? posted = freezed,Object? failed = null,}) {
  return _then(_Shout(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,authorAvatar: freezed == authorAvatar ? _self.authorAvatar : authorAvatar // ignore: cast_nullable_to_non_nullable
as String?,authorName: freezed == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,posted: freezed == posted ? _self.posted : posted // ignore: cast_nullable_to_non_nullable
as DateTime?,failed: null == failed ? _self._failed : failed // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

// dart format on
