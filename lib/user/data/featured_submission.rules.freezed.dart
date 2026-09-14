// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'featured_submission.rules.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FeaturedSubmission {

 int get id; String get link; SubmissionRating get rating; String get thumbnail; String? get title; Map<String, ParseException> get failed;
/// Create a copy of FeaturedSubmission
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeaturedSubmissionCopyWith<FeaturedSubmission> get copyWith => _$FeaturedSubmissionCopyWithImpl<FeaturedSubmission>(this as FeaturedSubmission, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FeaturedSubmission;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeaturedSubmission&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.link, _this.link) || other.link == _this.link)&&(identical(other.rating, _this.rating) || other.rating == _this.rating)&&(identical(other.thumbnail, _this.thumbnail) || other.thumbnail == _this.thumbnail)&&(identical(other.title, _this.title) || other.title == _this.title)&&const DeepCollectionEquality().equals(other.failed, _this.failed));
}


@override
int get hashCode {
  final _this = this as FeaturedSubmission;
  return Object.hash(runtimeType,_this.id,_this.link,_this.rating,_this.thumbnail,_this.title,const DeepCollectionEquality().hash(_this.failed));
}

@override
String toString() {
  final _this = this as FeaturedSubmission;
  return 'FeaturedSubmission(id: ${_this.id}, link: ${_this.link}, rating: ${_this.rating}, thumbnail: ${_this.thumbnail}, title: ${_this.title}, failed: ${_this.failed})';
}


}

/// @nodoc
abstract mixin class $FeaturedSubmissionCopyWith<$Res>  {
  factory $FeaturedSubmissionCopyWith(FeaturedSubmission value, $Res Function(FeaturedSubmission) _then) = _$FeaturedSubmissionCopyWithImpl;
@useResult
$Res call({
 int id, String link, SubmissionRating rating, String thumbnail, String? title, Map<String, ParseException> failed
});




}
/// @nodoc
class _$FeaturedSubmissionCopyWithImpl<$Res>
    implements $FeaturedSubmissionCopyWith<$Res> {
  _$FeaturedSubmissionCopyWithImpl(this._self, this._then);

  final FeaturedSubmission _self;
  final $Res Function(FeaturedSubmission) _then;

/// Create a copy of FeaturedSubmission
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? link = null,Object? rating = null,Object? thumbnail = null,Object? title = freezed,Object? failed = null,}) {
  return _then(FeaturedSubmission(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,link: null == link ? _self.link : link // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as SubmissionRating,thumbnail: null == thumbnail ? _self.thumbnail : thumbnail // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as Map<String, ParseException>,
  ));
}

}


/// Adds pattern-matching-related methods to [FeaturedSubmission].
extension FeaturedSubmissionPatterns on FeaturedSubmission {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeaturedSubmission value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeaturedSubmission() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeaturedSubmission value)  $default,){
final _that = this;
switch (_that) {
case _FeaturedSubmission():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeaturedSubmission value)?  $default,){
final _that = this;
switch (_that) {
case _FeaturedSubmission() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String link,  SubmissionRating rating,  String thumbnail,  String? title,  Map<String, ParseException> failed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeaturedSubmission() when $default != null:
return $default(_that.id,_that.link,_that.rating,_that.thumbnail,_that.title,_that.failed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String link,  SubmissionRating rating,  String thumbnail,  String? title,  Map<String, ParseException> failed)  $default,) {final _that = this;
switch (_that) {
case _FeaturedSubmission():
return $default(_that.id,_that.link,_that.rating,_that.thumbnail,_that.title,_that.failed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String link,  SubmissionRating rating,  String thumbnail,  String? title,  Map<String, ParseException> failed)?  $default,) {final _that = this;
switch (_that) {
case _FeaturedSubmission() when $default != null:
return $default(_that.id,_that.link,_that.rating,_that.thumbnail,_that.title,_that.failed);case _:
  return null;

}
}

}

/// @nodoc


class _FeaturedSubmission extends FeaturedSubmission {
  const _FeaturedSubmission({required this.id, required this.link, required this.rating, required this.thumbnail, this.title,  Map<String, ParseException> failed = const {}}): _failed = failed,super._();
  

@override final  int id;
@override final  String link;
@override final  SubmissionRating rating;
@override final  String thumbnail;
@override final  String? title;
 final  Map<String, ParseException> _failed;
@override@JsonKey() Map<String, ParseException> get failed {
  if (_failed is EqualUnmodifiableMapView) return _failed;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_failed);
}


/// Create a copy of FeaturedSubmission
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeaturedSubmissionCopyWith<_FeaturedSubmission> get copyWith => __$FeaturedSubmissionCopyWithImpl<_FeaturedSubmission>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeaturedSubmission&&(identical(other.id, id) || other.id == id)&&(identical(other.link, link) || other.link == link)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.thumbnail, thumbnail) || other.thumbnail == thumbnail)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.failed, _failed));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,link,rating,thumbnail,title,const DeepCollectionEquality().hash(_failed));
}

@override
String toString() {
    return 'FeaturedSubmission(id: $id, link: $link, rating: $rating, thumbnail: $thumbnail, title: $title, failed: $failed)';
}


}

/// @nodoc
abstract mixin class _$FeaturedSubmissionCopyWith<$Res> implements $FeaturedSubmissionCopyWith<$Res> {
  factory _$FeaturedSubmissionCopyWith(_FeaturedSubmission value, $Res Function(_FeaturedSubmission) _then) = __$FeaturedSubmissionCopyWithImpl;
@override @useResult
$Res call({
 int id, String link, SubmissionRating rating, String thumbnail, String? title, Map<String, ParseException> failed
});




}
/// @nodoc
class __$FeaturedSubmissionCopyWithImpl<$Res>
    implements _$FeaturedSubmissionCopyWith<$Res> {
  __$FeaturedSubmissionCopyWithImpl(this._self, this._then);

  final _FeaturedSubmission _self;
  final $Res Function(_FeaturedSubmission) _then;

/// Create a copy of FeaturedSubmission
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? link = null,Object? rating = null,Object? thumbnail = null,Object? title = freezed,Object? failed = null,}) {
  return _then(_FeaturedSubmission(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,link: null == link ? _self.link : link // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as SubmissionRating,thumbnail: null == thumbnail ? _self.thumbnail : thumbnail // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,failed: null == failed ? _self._failed : failed // ignore: cast_nullable_to_non_nullable
as Map<String, ParseException>,
  ));
}


}

// dart format on
