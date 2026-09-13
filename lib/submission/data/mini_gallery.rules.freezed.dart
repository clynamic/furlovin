// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mini_gallery.rules.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MiniGallery {

 String get link;/// Which listing the neighbours come from, such as the main gallery.
 String get name;/// Scraps carry no count.
 int? get count; List<SubmissionPreview> get newer; List<SubmissionPreview> get older; Map<String, ParseException> get failed;
/// Create a copy of MiniGallery
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MiniGalleryCopyWith<MiniGallery> get copyWith => _$MiniGalleryCopyWithImpl<MiniGallery>(this as MiniGallery, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MiniGallery;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MiniGallery&&(identical(other.link, _this.link) || other.link == _this.link)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.count, _this.count) || other.count == _this.count)&&const DeepCollectionEquality().equals(other.newer, _this.newer)&&const DeepCollectionEquality().equals(other.older, _this.older)&&const DeepCollectionEquality().equals(other.failed, _this.failed));
}


@override
int get hashCode {
  final _this = this as MiniGallery;
  return Object.hash(runtimeType,_this.link,_this.name,_this.count,const DeepCollectionEquality().hash(_this.newer),const DeepCollectionEquality().hash(_this.older),const DeepCollectionEquality().hash(_this.failed));
}

@override
String toString() {
  final _this = this as MiniGallery;
  return 'MiniGallery(link: ${_this.link}, name: ${_this.name}, count: ${_this.count}, newer: ${_this.newer}, older: ${_this.older}, failed: ${_this.failed})';
}


}

/// @nodoc
abstract mixin class $MiniGalleryCopyWith<$Res>  {
  factory $MiniGalleryCopyWith(MiniGallery value, $Res Function(MiniGallery) _then) = _$MiniGalleryCopyWithImpl;
@useResult
$Res call({
 String link, String name, int? count, List<SubmissionPreview> newer, List<SubmissionPreview> older, Map<String, ParseException> failed
});




}
/// @nodoc
class _$MiniGalleryCopyWithImpl<$Res>
    implements $MiniGalleryCopyWith<$Res> {
  _$MiniGalleryCopyWithImpl(this._self, this._then);

  final MiniGallery _self;
  final $Res Function(MiniGallery) _then;

/// Create a copy of MiniGallery
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? link = null,Object? name = null,Object? count = freezed,Object? newer = null,Object? older = null,Object? failed = null,}) {
  return _then(MiniGallery(
link: null == link ? _self.link : link // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,newer: null == newer ? _self.newer : newer // ignore: cast_nullable_to_non_nullable
as List<SubmissionPreview>,older: null == older ? _self.older : older // ignore: cast_nullable_to_non_nullable
as List<SubmissionPreview>,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as Map<String, ParseException>,
  ));
}

}


/// Adds pattern-matching-related methods to [MiniGallery].
extension MiniGalleryPatterns on MiniGallery {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MiniGallery value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MiniGallery() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MiniGallery value)  $default,){
final _that = this;
switch (_that) {
case _MiniGallery():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MiniGallery value)?  $default,){
final _that = this;
switch (_that) {
case _MiniGallery() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String link,  String name,  int? count,  List<SubmissionPreview> newer,  List<SubmissionPreview> older,  Map<String, ParseException> failed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MiniGallery() when $default != null:
return $default(_that.link,_that.name,_that.count,_that.newer,_that.older,_that.failed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String link,  String name,  int? count,  List<SubmissionPreview> newer,  List<SubmissionPreview> older,  Map<String, ParseException> failed)  $default,) {final _that = this;
switch (_that) {
case _MiniGallery():
return $default(_that.link,_that.name,_that.count,_that.newer,_that.older,_that.failed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String link,  String name,  int? count,  List<SubmissionPreview> newer,  List<SubmissionPreview> older,  Map<String, ParseException> failed)?  $default,) {final _that = this;
switch (_that) {
case _MiniGallery() when $default != null:
return $default(_that.link,_that.name,_that.count,_that.newer,_that.older,_that.failed);case _:
  return null;

}
}

}

/// @nodoc


class _MiniGallery extends MiniGallery {
  const _MiniGallery({required this.link, required this.name, this.count,  List<SubmissionPreview> newer = const [],  List<SubmissionPreview> older = const [],  Map<String, ParseException> failed = const {}}): _newer = newer,_older = older,_failed = failed,super._();
  

@override final  String link;
/// Which listing the neighbours come from, such as the main gallery.
@override final  String name;
/// Scraps carry no count.
@override final  int? count;
 final  List<SubmissionPreview> _newer;
@override@JsonKey() List<SubmissionPreview> get newer {
  if (_newer is EqualUnmodifiableListView) return _newer;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_newer);
}

 final  List<SubmissionPreview> _older;
@override@JsonKey() List<SubmissionPreview> get older {
  if (_older is EqualUnmodifiableListView) return _older;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_older);
}

 final  Map<String, ParseException> _failed;
@override@JsonKey() Map<String, ParseException> get failed {
  if (_failed is EqualUnmodifiableMapView) return _failed;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_failed);
}


/// Create a copy of MiniGallery
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MiniGalleryCopyWith<_MiniGallery> get copyWith => __$MiniGalleryCopyWithImpl<_MiniGallery>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MiniGallery&&(identical(other.link, link) || other.link == link)&&(identical(other.name, name) || other.name == name)&&(identical(other.count, count) || other.count == count)&&const DeepCollectionEquality().equals(other.newer, _newer)&&const DeepCollectionEquality().equals(other.older, _older)&&const DeepCollectionEquality().equals(other.failed, _failed));
}


@override
int get hashCode {
    return Object.hash(runtimeType,link,name,count,const DeepCollectionEquality().hash(_newer),const DeepCollectionEquality().hash(_older),const DeepCollectionEquality().hash(_failed));
}

@override
String toString() {
    return 'MiniGallery(link: $link, name: $name, count: $count, newer: $newer, older: $older, failed: $failed)';
}


}

/// @nodoc
abstract mixin class _$MiniGalleryCopyWith<$Res> implements $MiniGalleryCopyWith<$Res> {
  factory _$MiniGalleryCopyWith(_MiniGallery value, $Res Function(_MiniGallery) _then) = __$MiniGalleryCopyWithImpl;
@override @useResult
$Res call({
 String link, String name, int? count, List<SubmissionPreview> newer, List<SubmissionPreview> older, Map<String, ParseException> failed
});




}
/// @nodoc
class __$MiniGalleryCopyWithImpl<$Res>
    implements _$MiniGalleryCopyWith<$Res> {
  __$MiniGalleryCopyWithImpl(this._self, this._then);

  final _MiniGallery _self;
  final $Res Function(_MiniGallery) _then;

/// Create a copy of MiniGallery
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? link = null,Object? name = null,Object? count = freezed,Object? newer = null,Object? older = null,Object? failed = null,}) {
  return _then(_MiniGallery(
link: null == link ? _self.link : link // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,newer: null == newer ? _self._newer : newer // ignore: cast_nullable_to_non_nullable
as List<SubmissionPreview>,older: null == older ? _self._older : older // ignore: cast_nullable_to_non_nullable
as List<SubmissionPreview>,failed: null == failed ? _self._failed : failed // ignore: cast_nullable_to_non_nullable
as Map<String, ParseException>,
  ));
}


}

// dart format on
