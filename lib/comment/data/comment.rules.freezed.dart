// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comment.rules.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Comment {

/// The comment's numeric identifier.
 int get id;/// The url form of the commenter name, lowercased and with
/// underscores removed.
 String? get author;/// Absolute url of the commenter's avatar.
 String? get authorAvatar;/// The commenter name as displayed.
 String? get authorName;/// The rendered comment, as markup rather than text.
 String? get body;/// FA renders each reply level of div.comment_container three percent
/// narrower, from width:100% at the top level down to 85%.
 int? get depth;/// When the comment was posted.
 DateTime? get posted; Map<String, ParseException> get failed;
/// Create a copy of Comment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommentCopyWith<Comment> get copyWith => _$CommentCopyWithImpl<Comment>(this as Comment, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Comment;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Comment&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.author, _this.author) || other.author == _this.author)&&(identical(other.authorAvatar, _this.authorAvatar) || other.authorAvatar == _this.authorAvatar)&&(identical(other.authorName, _this.authorName) || other.authorName == _this.authorName)&&(identical(other.body, _this.body) || other.body == _this.body)&&(identical(other.depth, _this.depth) || other.depth == _this.depth)&&(identical(other.posted, _this.posted) || other.posted == _this.posted)&&const DeepCollectionEquality().equals(other.failed, _this.failed));
}


@override
int get hashCode {
  final _this = this as Comment;
  return Object.hash(runtimeType,_this.id,_this.author,_this.authorAvatar,_this.authorName,_this.body,_this.depth,_this.posted,const DeepCollectionEquality().hash(_this.failed));
}

@override
String toString() {
  final _this = this as Comment;
  return 'Comment(id: ${_this.id}, author: ${_this.author}, authorAvatar: ${_this.authorAvatar}, authorName: ${_this.authorName}, body: ${_this.body}, depth: ${_this.depth}, posted: ${_this.posted}, failed: ${_this.failed})';
}


}

/// @nodoc
abstract mixin class $CommentCopyWith<$Res>  {
  factory $CommentCopyWith(Comment value, $Res Function(Comment) _then) = _$CommentCopyWithImpl;
@useResult
$Res call({
 int id, String? author, String? authorAvatar, String? authorName, String? body, int? depth, DateTime? posted, Map<String, ParseException> failed
});




}
/// @nodoc
class _$CommentCopyWithImpl<$Res>
    implements $CommentCopyWith<$Res> {
  _$CommentCopyWithImpl(this._self, this._then);

  final Comment _self;
  final $Res Function(Comment) _then;

/// Create a copy of Comment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? author = freezed,Object? authorAvatar = freezed,Object? authorName = freezed,Object? body = freezed,Object? depth = freezed,Object? posted = freezed,Object? failed = null,}) {
  return _then(Comment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,authorAvatar: freezed == authorAvatar ? _self.authorAvatar : authorAvatar // ignore: cast_nullable_to_non_nullable
as String?,authorName: freezed == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,depth: freezed == depth ? _self.depth : depth // ignore: cast_nullable_to_non_nullable
as int?,posted: freezed == posted ? _self.posted : posted // ignore: cast_nullable_to_non_nullable
as DateTime?,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as Map<String, ParseException>,
  ));
}

}


/// Adds pattern-matching-related methods to [Comment].
extension CommentPatterns on Comment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Comment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Comment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Comment value)  $default,){
final _that = this;
switch (_that) {
case _Comment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Comment value)?  $default,){
final _that = this;
switch (_that) {
case _Comment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String? author,  String? authorAvatar,  String? authorName,  String? body,  int? depth,  DateTime? posted,  Map<String, ParseException> failed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Comment() when $default != null:
return $default(_that.id,_that.author,_that.authorAvatar,_that.authorName,_that.body,_that.depth,_that.posted,_that.failed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String? author,  String? authorAvatar,  String? authorName,  String? body,  int? depth,  DateTime? posted,  Map<String, ParseException> failed)  $default,) {final _that = this;
switch (_that) {
case _Comment():
return $default(_that.id,_that.author,_that.authorAvatar,_that.authorName,_that.body,_that.depth,_that.posted,_that.failed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String? author,  String? authorAvatar,  String? authorName,  String? body,  int? depth,  DateTime? posted,  Map<String, ParseException> failed)?  $default,) {final _that = this;
switch (_that) {
case _Comment() when $default != null:
return $default(_that.id,_that.author,_that.authorAvatar,_that.authorName,_that.body,_that.depth,_that.posted,_that.failed);case _:
  return null;

}
}

}

/// @nodoc


class _Comment extends Comment {
  const _Comment({required this.id, this.author, this.authorAvatar, this.authorName, this.body, this.depth, this.posted,  Map<String, ParseException> failed = const {}}): _failed = failed,super._();
  

/// The comment's numeric identifier.
@override final  int id;
/// The url form of the commenter name, lowercased and with
/// underscores removed.
@override final  String? author;
/// Absolute url of the commenter's avatar.
@override final  String? authorAvatar;
/// The commenter name as displayed.
@override final  String? authorName;
/// The rendered comment, as markup rather than text.
@override final  String? body;
/// FA renders each reply level of div.comment_container three percent
/// narrower, from width:100% at the top level down to 85%.
@override final  int? depth;
/// When the comment was posted.
@override final  DateTime? posted;
 final  Map<String, ParseException> _failed;
@override@JsonKey() Map<String, ParseException> get failed {
  if (_failed is EqualUnmodifiableMapView) return _failed;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_failed);
}


/// Create a copy of Comment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommentCopyWith<_Comment> get copyWith => __$CommentCopyWithImpl<_Comment>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Comment&&(identical(other.id, id) || other.id == id)&&(identical(other.author, author) || other.author == author)&&(identical(other.authorAvatar, authorAvatar) || other.authorAvatar == authorAvatar)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.body, body) || other.body == body)&&(identical(other.depth, depth) || other.depth == depth)&&(identical(other.posted, posted) || other.posted == posted)&&const DeepCollectionEquality().equals(other.failed, _failed));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,author,authorAvatar,authorName,body,depth,posted,const DeepCollectionEquality().hash(_failed));
}

@override
String toString() {
    return 'Comment(id: $id, author: $author, authorAvatar: $authorAvatar, authorName: $authorName, body: $body, depth: $depth, posted: $posted, failed: $failed)';
}


}

/// @nodoc
abstract mixin class _$CommentCopyWith<$Res> implements $CommentCopyWith<$Res> {
  factory _$CommentCopyWith(_Comment value, $Res Function(_Comment) _then) = __$CommentCopyWithImpl;
@override @useResult
$Res call({
 int id, String? author, String? authorAvatar, String? authorName, String? body, int? depth, DateTime? posted, Map<String, ParseException> failed
});




}
/// @nodoc
class __$CommentCopyWithImpl<$Res>
    implements _$CommentCopyWith<$Res> {
  __$CommentCopyWithImpl(this._self, this._then);

  final _Comment _self;
  final $Res Function(_Comment) _then;

/// Create a copy of Comment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? author = freezed,Object? authorAvatar = freezed,Object? authorName = freezed,Object? body = freezed,Object? depth = freezed,Object? posted = freezed,Object? failed = null,}) {
  return _then(_Comment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,authorAvatar: freezed == authorAvatar ? _self.authorAvatar : authorAvatar // ignore: cast_nullable_to_non_nullable
as String?,authorName: freezed == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,depth: freezed == depth ? _self.depth : depth // ignore: cast_nullable_to_non_nullable
as int?,posted: freezed == posted ? _self.posted : posted // ignore: cast_nullable_to_non_nullable
as DateTime?,failed: null == failed ? _self._failed : failed // ignore: cast_nullable_to_non_nullable
as Map<String, ParseException>,
  ));
}


}

// dart format on
