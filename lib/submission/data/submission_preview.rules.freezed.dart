// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'submission_preview.rules.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SubmissionPreview {

/// The submission's numeric identifier.
 int get id;/// Absolute url of the submission page.
 String get link;/// The submission's content rating.
 SubmissionRating get rating;/// Absolute url of the thumbnail. The size segment constrains the
/// longest edge to that many pixels.
 String get thumbnail;/// The url form of the name of whoever posted the submission,
/// lowercased and with underscores removed.
 String get uploader;/// Thumbnail height in pixels, which the site fixes at 200.
 double? get thumbnailHeight;/// Thumbnail width in pixels, as declared by the site rather than
/// measured from the image.
 double? get thumbnailWidth;/// Listing titles are sanitised by the site and may lose leading
/// punctuation. The submission page carries the canonical title.
 String? get title;/// Content type, such as image, text, music or flash.
 SubmissionType? get type;/// The name of whoever posted the submission, as displayed.
 String? get uploaderName; Map<String, ParseException> get failed;
/// Create a copy of SubmissionPreview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubmissionPreviewCopyWith<SubmissionPreview> get copyWith => _$SubmissionPreviewCopyWithImpl<SubmissionPreview>(this as SubmissionPreview, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SubmissionPreview;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubmissionPreview&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.link, _this.link) || other.link == _this.link)&&(identical(other.rating, _this.rating) || other.rating == _this.rating)&&(identical(other.thumbnail, _this.thumbnail) || other.thumbnail == _this.thumbnail)&&(identical(other.uploader, _this.uploader) || other.uploader == _this.uploader)&&(identical(other.thumbnailHeight, _this.thumbnailHeight) || other.thumbnailHeight == _this.thumbnailHeight)&&(identical(other.thumbnailWidth, _this.thumbnailWidth) || other.thumbnailWidth == _this.thumbnailWidth)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.uploaderName, _this.uploaderName) || other.uploaderName == _this.uploaderName)&&const DeepCollectionEquality().equals(other.failed, _this.failed));
}


@override
int get hashCode {
  final _this = this as SubmissionPreview;
  return Object.hash(runtimeType,_this.id,_this.link,_this.rating,_this.thumbnail,_this.uploader,_this.thumbnailHeight,_this.thumbnailWidth,_this.title,_this.type,_this.uploaderName,const DeepCollectionEquality().hash(_this.failed));
}

@override
String toString() {
  final _this = this as SubmissionPreview;
  return 'SubmissionPreview(id: ${_this.id}, link: ${_this.link}, rating: ${_this.rating}, thumbnail: ${_this.thumbnail}, uploader: ${_this.uploader}, thumbnailHeight: ${_this.thumbnailHeight}, thumbnailWidth: ${_this.thumbnailWidth}, title: ${_this.title}, type: ${_this.type}, uploaderName: ${_this.uploaderName}, failed: ${_this.failed})';
}


}

/// @nodoc
abstract mixin class $SubmissionPreviewCopyWith<$Res>  {
  factory $SubmissionPreviewCopyWith(SubmissionPreview value, $Res Function(SubmissionPreview) _then) = _$SubmissionPreviewCopyWithImpl;
@useResult
$Res call({
 int id, String link, SubmissionRating rating, String thumbnail, String uploader, double? thumbnailHeight, double? thumbnailWidth, String? title, SubmissionType? type, String? uploaderName, Map<String, ParseException> failed
});




}
/// @nodoc
class _$SubmissionPreviewCopyWithImpl<$Res>
    implements $SubmissionPreviewCopyWith<$Res> {
  _$SubmissionPreviewCopyWithImpl(this._self, this._then);

  final SubmissionPreview _self;
  final $Res Function(SubmissionPreview) _then;

/// Create a copy of SubmissionPreview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? link = null,Object? rating = null,Object? thumbnail = null,Object? uploader = null,Object? thumbnailHeight = freezed,Object? thumbnailWidth = freezed,Object? title = freezed,Object? type = freezed,Object? uploaderName = freezed,Object? failed = null,}) {
  return _then(SubmissionPreview(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,link: null == link ? _self.link : link // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as SubmissionRating,thumbnail: null == thumbnail ? _self.thumbnail : thumbnail // ignore: cast_nullable_to_non_nullable
as String,uploader: null == uploader ? _self.uploader : uploader // ignore: cast_nullable_to_non_nullable
as String,thumbnailHeight: freezed == thumbnailHeight ? _self.thumbnailHeight : thumbnailHeight // ignore: cast_nullable_to_non_nullable
as double?,thumbnailWidth: freezed == thumbnailWidth ? _self.thumbnailWidth : thumbnailWidth // ignore: cast_nullable_to_non_nullable
as double?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as SubmissionType?,uploaderName: freezed == uploaderName ? _self.uploaderName : uploaderName // ignore: cast_nullable_to_non_nullable
as String?,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as Map<String, ParseException>,
  ));
}

}


/// Adds pattern-matching-related methods to [SubmissionPreview].
extension SubmissionPreviewPatterns on SubmissionPreview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubmissionPreview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubmissionPreview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubmissionPreview value)  $default,){
final _that = this;
switch (_that) {
case _SubmissionPreview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubmissionPreview value)?  $default,){
final _that = this;
switch (_that) {
case _SubmissionPreview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String link,  SubmissionRating rating,  String thumbnail,  String uploader,  double? thumbnailHeight,  double? thumbnailWidth,  String? title,  SubmissionType? type,  String? uploaderName,  Map<String, ParseException> failed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubmissionPreview() when $default != null:
return $default(_that.id,_that.link,_that.rating,_that.thumbnail,_that.uploader,_that.thumbnailHeight,_that.thumbnailWidth,_that.title,_that.type,_that.uploaderName,_that.failed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String link,  SubmissionRating rating,  String thumbnail,  String uploader,  double? thumbnailHeight,  double? thumbnailWidth,  String? title,  SubmissionType? type,  String? uploaderName,  Map<String, ParseException> failed)  $default,) {final _that = this;
switch (_that) {
case _SubmissionPreview():
return $default(_that.id,_that.link,_that.rating,_that.thumbnail,_that.uploader,_that.thumbnailHeight,_that.thumbnailWidth,_that.title,_that.type,_that.uploaderName,_that.failed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String link,  SubmissionRating rating,  String thumbnail,  String uploader,  double? thumbnailHeight,  double? thumbnailWidth,  String? title,  SubmissionType? type,  String? uploaderName,  Map<String, ParseException> failed)?  $default,) {final _that = this;
switch (_that) {
case _SubmissionPreview() when $default != null:
return $default(_that.id,_that.link,_that.rating,_that.thumbnail,_that.uploader,_that.thumbnailHeight,_that.thumbnailWidth,_that.title,_that.type,_that.uploaderName,_that.failed);case _:
  return null;

}
}

}

/// @nodoc


class _SubmissionPreview extends SubmissionPreview {
  const _SubmissionPreview({required this.id, required this.link, required this.rating, required this.thumbnail, required this.uploader, this.thumbnailHeight, this.thumbnailWidth, this.title, this.type, this.uploaderName,  Map<String, ParseException> failed = const {}}): _failed = failed,super._();
  

/// The submission's numeric identifier.
@override final  int id;
/// Absolute url of the submission page.
@override final  String link;
/// The submission's content rating.
@override final  SubmissionRating rating;
/// Absolute url of the thumbnail. The size segment constrains the
/// longest edge to that many pixels.
@override final  String thumbnail;
/// The url form of the name of whoever posted the submission,
/// lowercased and with underscores removed.
@override final  String uploader;
/// Thumbnail height in pixels, which the site fixes at 200.
@override final  double? thumbnailHeight;
/// Thumbnail width in pixels, as declared by the site rather than
/// measured from the image.
@override final  double? thumbnailWidth;
/// Listing titles are sanitised by the site and may lose leading
/// punctuation. The submission page carries the canonical title.
@override final  String? title;
/// Content type, such as image, text, music or flash.
@override final  SubmissionType? type;
/// The name of whoever posted the submission, as displayed.
@override final  String? uploaderName;
 final  Map<String, ParseException> _failed;
@override@JsonKey() Map<String, ParseException> get failed {
  if (_failed is EqualUnmodifiableMapView) return _failed;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_failed);
}


/// Create a copy of SubmissionPreview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubmissionPreviewCopyWith<_SubmissionPreview> get copyWith => __$SubmissionPreviewCopyWithImpl<_SubmissionPreview>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubmissionPreview&&(identical(other.id, id) || other.id == id)&&(identical(other.link, link) || other.link == link)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.thumbnail, thumbnail) || other.thumbnail == thumbnail)&&(identical(other.uploader, uploader) || other.uploader == uploader)&&(identical(other.thumbnailHeight, thumbnailHeight) || other.thumbnailHeight == thumbnailHeight)&&(identical(other.thumbnailWidth, thumbnailWidth) || other.thumbnailWidth == thumbnailWidth)&&(identical(other.title, title) || other.title == title)&&(identical(other.type, type) || other.type == type)&&(identical(other.uploaderName, uploaderName) || other.uploaderName == uploaderName)&&const DeepCollectionEquality().equals(other.failed, _failed));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,link,rating,thumbnail,uploader,thumbnailHeight,thumbnailWidth,title,type,uploaderName,const DeepCollectionEquality().hash(_failed));
}

@override
String toString() {
    return 'SubmissionPreview(id: $id, link: $link, rating: $rating, thumbnail: $thumbnail, uploader: $uploader, thumbnailHeight: $thumbnailHeight, thumbnailWidth: $thumbnailWidth, title: $title, type: $type, uploaderName: $uploaderName, failed: $failed)';
}


}

/// @nodoc
abstract mixin class _$SubmissionPreviewCopyWith<$Res> implements $SubmissionPreviewCopyWith<$Res> {
  factory _$SubmissionPreviewCopyWith(_SubmissionPreview value, $Res Function(_SubmissionPreview) _then) = __$SubmissionPreviewCopyWithImpl;
@override @useResult
$Res call({
 int id, String link, SubmissionRating rating, String thumbnail, String uploader, double? thumbnailHeight, double? thumbnailWidth, String? title, SubmissionType? type, String? uploaderName, Map<String, ParseException> failed
});




}
/// @nodoc
class __$SubmissionPreviewCopyWithImpl<$Res>
    implements _$SubmissionPreviewCopyWith<$Res> {
  __$SubmissionPreviewCopyWithImpl(this._self, this._then);

  final _SubmissionPreview _self;
  final $Res Function(_SubmissionPreview) _then;

/// Create a copy of SubmissionPreview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? link = null,Object? rating = null,Object? thumbnail = null,Object? uploader = null,Object? thumbnailHeight = freezed,Object? thumbnailWidth = freezed,Object? title = freezed,Object? type = freezed,Object? uploaderName = freezed,Object? failed = null,}) {
  return _then(_SubmissionPreview(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,link: null == link ? _self.link : link // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as SubmissionRating,thumbnail: null == thumbnail ? _self.thumbnail : thumbnail // ignore: cast_nullable_to_non_nullable
as String,uploader: null == uploader ? _self.uploader : uploader // ignore: cast_nullable_to_non_nullable
as String,thumbnailHeight: freezed == thumbnailHeight ? _self.thumbnailHeight : thumbnailHeight // ignore: cast_nullable_to_non_nullable
as double?,thumbnailWidth: freezed == thumbnailWidth ? _self.thumbnailWidth : thumbnailWidth // ignore: cast_nullable_to_non_nullable
as double?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as SubmissionType?,uploaderName: freezed == uploaderName ? _self.uploaderName : uploaderName // ignore: cast_nullable_to_non_nullable
as String?,failed: null == failed ? _self._failed : failed // ignore: cast_nullable_to_non_nullable
as Map<String, ParseException>,
  ));
}


}

// dart format on
