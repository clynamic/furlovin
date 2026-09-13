// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'submission_document.rules.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SubmissionDocument {

 Submission get submission; List<Comment> get comments; List<Folder> get folders; MiniGallery? get miniGallery; Map<String, ParseException> get failed; ReadReport? get report;
/// Create a copy of SubmissionDocument
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubmissionDocumentCopyWith<SubmissionDocument> get copyWith => _$SubmissionDocumentCopyWithImpl<SubmissionDocument>(this as SubmissionDocument, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SubmissionDocument;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubmissionDocument&&(identical(other.submission, _this.submission) || other.submission == _this.submission)&&const DeepCollectionEquality().equals(other.comments, _this.comments)&&const DeepCollectionEquality().equals(other.folders, _this.folders)&&(identical(other.miniGallery, _this.miniGallery) || other.miniGallery == _this.miniGallery)&&const DeepCollectionEquality().equals(other.failed, _this.failed)&&(identical(other.report, _this.report) || other.report == _this.report));
}


@override
int get hashCode {
  final _this = this as SubmissionDocument;
  return Object.hash(runtimeType,_this.submission,const DeepCollectionEquality().hash(_this.comments),const DeepCollectionEquality().hash(_this.folders),_this.miniGallery,const DeepCollectionEquality().hash(_this.failed),_this.report);
}

@override
String toString() {
  final _this = this as SubmissionDocument;
  return 'SubmissionDocument(submission: ${_this.submission}, comments: ${_this.comments}, folders: ${_this.folders}, miniGallery: ${_this.miniGallery}, failed: ${_this.failed}, report: ${_this.report})';
}


}

/// @nodoc
abstract mixin class $SubmissionDocumentCopyWith<$Res>  {
  factory $SubmissionDocumentCopyWith(SubmissionDocument value, $Res Function(SubmissionDocument) _then) = _$SubmissionDocumentCopyWithImpl;
@useResult
$Res call({
 Submission submission, List<Comment> comments, List<Folder> folders, MiniGallery? miniGallery, Map<String, ParseException> failed, ReadReport? report
});


$SubmissionCopyWith<$Res> get submission;$MiniGalleryCopyWith<$Res>? get miniGallery;

}
/// @nodoc
class _$SubmissionDocumentCopyWithImpl<$Res>
    implements $SubmissionDocumentCopyWith<$Res> {
  _$SubmissionDocumentCopyWithImpl(this._self, this._then);

  final SubmissionDocument _self;
  final $Res Function(SubmissionDocument) _then;

/// Create a copy of SubmissionDocument
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? submission = null,Object? comments = null,Object? folders = null,Object? miniGallery = freezed,Object? failed = null,Object? report = freezed,}) {
  return _then(SubmissionDocument(
submission: null == submission ? _self.submission : submission // ignore: cast_nullable_to_non_nullable
as Submission,comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as List<Comment>,folders: null == folders ? _self.folders : folders // ignore: cast_nullable_to_non_nullable
as List<Folder>,miniGallery: freezed == miniGallery ? _self.miniGallery : miniGallery // ignore: cast_nullable_to_non_nullable
as MiniGallery?,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as Map<String, ParseException>,report: freezed == report ? _self.report : report // ignore: cast_nullable_to_non_nullable
as ReadReport?,
  ));
}
/// Create a copy of SubmissionDocument
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SubmissionCopyWith<$Res> get submission {
  
  return $SubmissionCopyWith<$Res>(_self.submission, (value) {
    return _then(_self.copyWith(submission: value));
  });
}/// Create a copy of SubmissionDocument
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MiniGalleryCopyWith<$Res>? get miniGallery {
    if (_self.miniGallery == null) {
    return null;
  }

  return $MiniGalleryCopyWith<$Res>(_self.miniGallery!, (value) {
    return _then(_self.copyWith(miniGallery: value));
  });
}
}


/// Adds pattern-matching-related methods to [SubmissionDocument].
extension SubmissionDocumentPatterns on SubmissionDocument {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubmissionDocument value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubmissionDocument() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubmissionDocument value)  $default,){
final _that = this;
switch (_that) {
case _SubmissionDocument():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubmissionDocument value)?  $default,){
final _that = this;
switch (_that) {
case _SubmissionDocument() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Submission submission,  List<Comment> comments,  List<Folder> folders,  MiniGallery? miniGallery,  Map<String, ParseException> failed,  ReadReport? report)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubmissionDocument() when $default != null:
return $default(_that.submission,_that.comments,_that.folders,_that.miniGallery,_that.failed,_that.report);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Submission submission,  List<Comment> comments,  List<Folder> folders,  MiniGallery? miniGallery,  Map<String, ParseException> failed,  ReadReport? report)  $default,) {final _that = this;
switch (_that) {
case _SubmissionDocument():
return $default(_that.submission,_that.comments,_that.folders,_that.miniGallery,_that.failed,_that.report);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Submission submission,  List<Comment> comments,  List<Folder> folders,  MiniGallery? miniGallery,  Map<String, ParseException> failed,  ReadReport? report)?  $default,) {final _that = this;
switch (_that) {
case _SubmissionDocument() when $default != null:
return $default(_that.submission,_that.comments,_that.folders,_that.miniGallery,_that.failed,_that.report);case _:
  return null;

}
}

}

/// @nodoc


class _SubmissionDocument extends SubmissionDocument {
  const _SubmissionDocument({required this.submission,  List<Comment> comments = const [],  List<Folder> folders = const [], this.miniGallery,  Map<String, ParseException> failed = const {}, this.report}): _comments = comments,_folders = folders,_failed = failed,super._();
  

@override final  Submission submission;
 final  List<Comment> _comments;
@override@JsonKey() List<Comment> get comments {
  if (_comments is EqualUnmodifiableListView) return _comments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_comments);
}

 final  List<Folder> _folders;
@override@JsonKey() List<Folder> get folders {
  if (_folders is EqualUnmodifiableListView) return _folders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_folders);
}

@override final  MiniGallery? miniGallery;
 final  Map<String, ParseException> _failed;
@override@JsonKey() Map<String, ParseException> get failed {
  if (_failed is EqualUnmodifiableMapView) return _failed;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_failed);
}

@override final  ReadReport? report;

/// Create a copy of SubmissionDocument
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubmissionDocumentCopyWith<_SubmissionDocument> get copyWith => __$SubmissionDocumentCopyWithImpl<_SubmissionDocument>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubmissionDocument&&(identical(other.submission, submission) || other.submission == submission)&&const DeepCollectionEquality().equals(other.comments, _comments)&&const DeepCollectionEquality().equals(other.folders, _folders)&&(identical(other.miniGallery, miniGallery) || other.miniGallery == miniGallery)&&const DeepCollectionEquality().equals(other.failed, _failed)&&(identical(other.report, report) || other.report == report));
}


@override
int get hashCode {
    return Object.hash(runtimeType,submission,const DeepCollectionEquality().hash(_comments),const DeepCollectionEquality().hash(_folders),miniGallery,const DeepCollectionEquality().hash(_failed),report);
}

@override
String toString() {
    return 'SubmissionDocument(submission: $submission, comments: $comments, folders: $folders, miniGallery: $miniGallery, failed: $failed, report: $report)';
}


}

/// @nodoc
abstract mixin class _$SubmissionDocumentCopyWith<$Res> implements $SubmissionDocumentCopyWith<$Res> {
  factory _$SubmissionDocumentCopyWith(_SubmissionDocument value, $Res Function(_SubmissionDocument) _then) = __$SubmissionDocumentCopyWithImpl;
@override @useResult
$Res call({
 Submission submission, List<Comment> comments, List<Folder> folders, MiniGallery? miniGallery, Map<String, ParseException> failed, ReadReport? report
});


@override $SubmissionCopyWith<$Res> get submission;@override $MiniGalleryCopyWith<$Res>? get miniGallery;

}
/// @nodoc
class __$SubmissionDocumentCopyWithImpl<$Res>
    implements _$SubmissionDocumentCopyWith<$Res> {
  __$SubmissionDocumentCopyWithImpl(this._self, this._then);

  final _SubmissionDocument _self;
  final $Res Function(_SubmissionDocument) _then;

/// Create a copy of SubmissionDocument
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? submission = null,Object? comments = null,Object? folders = null,Object? miniGallery = freezed,Object? failed = null,Object? report = freezed,}) {
  return _then(_SubmissionDocument(
submission: null == submission ? _self.submission : submission // ignore: cast_nullable_to_non_nullable
as Submission,comments: null == comments ? _self._comments : comments // ignore: cast_nullable_to_non_nullable
as List<Comment>,folders: null == folders ? _self._folders : folders // ignore: cast_nullable_to_non_nullable
as List<Folder>,miniGallery: freezed == miniGallery ? _self.miniGallery : miniGallery // ignore: cast_nullable_to_non_nullable
as MiniGallery?,failed: null == failed ? _self._failed : failed // ignore: cast_nullable_to_non_nullable
as Map<String, ParseException>,report: freezed == report ? _self.report : report // ignore: cast_nullable_to_non_nullable
as ReadReport?,
  ));
}

/// Create a copy of SubmissionDocument
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SubmissionCopyWith<$Res> get submission {
  
  return $SubmissionCopyWith<$Res>(_self.submission, (value) {
    return _then(_self.copyWith(submission: value));
  });
}/// Create a copy of SubmissionDocument
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MiniGalleryCopyWith<$Res>? get miniGallery {
    if (_self.miniGallery == null) {
    return null;
  }

  return $MiniGalleryCopyWith<$Res>(_self.miniGallery!, (value) {
    return _then(_self.copyWith(miniGallery: value));
  });
}
}

// dart format on
