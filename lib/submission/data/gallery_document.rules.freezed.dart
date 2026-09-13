// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gallery_document.rules.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GalleryDocument {

 List<SubmissionPreview> get submissions; List<FolderRow> get folders; Map<String, ParseException> get failed; ReadReport? get report;
/// Create a copy of GalleryDocument
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GalleryDocumentCopyWith<GalleryDocument> get copyWith => _$GalleryDocumentCopyWithImpl<GalleryDocument>(this as GalleryDocument, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as GalleryDocument;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GalleryDocument&&const DeepCollectionEquality().equals(other.submissions, _this.submissions)&&const DeepCollectionEquality().equals(other.folders, _this.folders)&&const DeepCollectionEquality().equals(other.failed, _this.failed)&&(identical(other.report, _this.report) || other.report == _this.report));
}


@override
int get hashCode {
  final _this = this as GalleryDocument;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.submissions),const DeepCollectionEquality().hash(_this.folders),const DeepCollectionEquality().hash(_this.failed),_this.report);
}

@override
String toString() {
  final _this = this as GalleryDocument;
  return 'GalleryDocument(submissions: ${_this.submissions}, folders: ${_this.folders}, failed: ${_this.failed}, report: ${_this.report})';
}


}

/// @nodoc
abstract mixin class $GalleryDocumentCopyWith<$Res>  {
  factory $GalleryDocumentCopyWith(GalleryDocument value, $Res Function(GalleryDocument) _then) = _$GalleryDocumentCopyWithImpl;
@useResult
$Res call({
 List<SubmissionPreview> submissions, List<FolderRow> folders, Map<String, ParseException> failed, ReadReport? report
});




}
/// @nodoc
class _$GalleryDocumentCopyWithImpl<$Res>
    implements $GalleryDocumentCopyWith<$Res> {
  _$GalleryDocumentCopyWithImpl(this._self, this._then);

  final GalleryDocument _self;
  final $Res Function(GalleryDocument) _then;

/// Create a copy of GalleryDocument
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? submissions = null,Object? folders = null,Object? failed = null,Object? report = freezed,}) {
  return _then(GalleryDocument(
submissions: null == submissions ? _self.submissions : submissions // ignore: cast_nullable_to_non_nullable
as List<SubmissionPreview>,folders: null == folders ? _self.folders : folders // ignore: cast_nullable_to_non_nullable
as List<FolderRow>,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as Map<String, ParseException>,report: freezed == report ? _self.report : report // ignore: cast_nullable_to_non_nullable
as ReadReport?,
  ));
}

}


/// Adds pattern-matching-related methods to [GalleryDocument].
extension GalleryDocumentPatterns on GalleryDocument {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GalleryDocument value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GalleryDocument() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GalleryDocument value)  $default,){
final _that = this;
switch (_that) {
case _GalleryDocument():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GalleryDocument value)?  $default,){
final _that = this;
switch (_that) {
case _GalleryDocument() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SubmissionPreview> submissions,  List<FolderRow> folders,  Map<String, ParseException> failed,  ReadReport? report)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GalleryDocument() when $default != null:
return $default(_that.submissions,_that.folders,_that.failed,_that.report);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SubmissionPreview> submissions,  List<FolderRow> folders,  Map<String, ParseException> failed,  ReadReport? report)  $default,) {final _that = this;
switch (_that) {
case _GalleryDocument():
return $default(_that.submissions,_that.folders,_that.failed,_that.report);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SubmissionPreview> submissions,  List<FolderRow> folders,  Map<String, ParseException> failed,  ReadReport? report)?  $default,) {final _that = this;
switch (_that) {
case _GalleryDocument() when $default != null:
return $default(_that.submissions,_that.folders,_that.failed,_that.report);case _:
  return null;

}
}

}

/// @nodoc


class _GalleryDocument extends GalleryDocument {
  const _GalleryDocument({ List<SubmissionPreview> submissions = const [],  List<FolderRow> folders = const [],  Map<String, ParseException> failed = const {}, this.report}): _submissions = submissions,_folders = folders,_failed = failed,super._();
  

 final  List<SubmissionPreview> _submissions;
@override@JsonKey() List<SubmissionPreview> get submissions {
  if (_submissions is EqualUnmodifiableListView) return _submissions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_submissions);
}

 final  List<FolderRow> _folders;
@override@JsonKey() List<FolderRow> get folders {
  if (_folders is EqualUnmodifiableListView) return _folders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_folders);
}

 final  Map<String, ParseException> _failed;
@override@JsonKey() Map<String, ParseException> get failed {
  if (_failed is EqualUnmodifiableMapView) return _failed;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_failed);
}

@override final  ReadReport? report;

/// Create a copy of GalleryDocument
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GalleryDocumentCopyWith<_GalleryDocument> get copyWith => __$GalleryDocumentCopyWithImpl<_GalleryDocument>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GalleryDocument&&const DeepCollectionEquality().equals(other.submissions, _submissions)&&const DeepCollectionEquality().equals(other.folders, _folders)&&const DeepCollectionEquality().equals(other.failed, _failed)&&(identical(other.report, report) || other.report == report));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_submissions),const DeepCollectionEquality().hash(_folders),const DeepCollectionEquality().hash(_failed),report);
}

@override
String toString() {
    return 'GalleryDocument(submissions: $submissions, folders: $folders, failed: $failed, report: $report)';
}


}

/// @nodoc
abstract mixin class _$GalleryDocumentCopyWith<$Res> implements $GalleryDocumentCopyWith<$Res> {
  factory _$GalleryDocumentCopyWith(_GalleryDocument value, $Res Function(_GalleryDocument) _then) = __$GalleryDocumentCopyWithImpl;
@override @useResult
$Res call({
 List<SubmissionPreview> submissions, List<FolderRow> folders, Map<String, ParseException> failed, ReadReport? report
});




}
/// @nodoc
class __$GalleryDocumentCopyWithImpl<$Res>
    implements _$GalleryDocumentCopyWith<$Res> {
  __$GalleryDocumentCopyWithImpl(this._self, this._then);

  final _GalleryDocument _self;
  final $Res Function(_GalleryDocument) _then;

/// Create a copy of GalleryDocument
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? submissions = null,Object? folders = null,Object? failed = null,Object? report = freezed,}) {
  return _then(_GalleryDocument(
submissions: null == submissions ? _self._submissions : submissions // ignore: cast_nullable_to_non_nullable
as List<SubmissionPreview>,folders: null == folders ? _self._folders : folders // ignore: cast_nullable_to_non_nullable
as List<FolderRow>,failed: null == failed ? _self._failed : failed // ignore: cast_nullable_to_non_nullable
as Map<String, ParseException>,report: freezed == report ? _self.report : report // ignore: cast_nullable_to_non_nullable
as ReadReport?,
  ));
}


}

// dart format on
