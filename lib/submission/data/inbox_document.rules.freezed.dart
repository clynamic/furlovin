// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inbox_document.rules.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$InboxDocument {

 List<SubmissionPreview> get submissions; Map<String, ParseException> get failed; ReadReport? get report;
/// Create a copy of InboxDocument
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InboxDocumentCopyWith<InboxDocument> get copyWith => _$InboxDocumentCopyWithImpl<InboxDocument>(this as InboxDocument, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as InboxDocument;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InboxDocument&&const DeepCollectionEquality().equals(other.submissions, _this.submissions)&&const DeepCollectionEquality().equals(other.failed, _this.failed)&&(identical(other.report, _this.report) || other.report == _this.report));
}


@override
int get hashCode {
  final _this = this as InboxDocument;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.submissions),const DeepCollectionEquality().hash(_this.failed),_this.report);
}

@override
String toString() {
  final _this = this as InboxDocument;
  return 'InboxDocument(submissions: ${_this.submissions}, failed: ${_this.failed}, report: ${_this.report})';
}


}

/// @nodoc
abstract mixin class $InboxDocumentCopyWith<$Res>  {
  factory $InboxDocumentCopyWith(InboxDocument value, $Res Function(InboxDocument) _then) = _$InboxDocumentCopyWithImpl;
@useResult
$Res call({
 List<SubmissionPreview> submissions, Map<String, ParseException> failed, ReadReport? report
});




}
/// @nodoc
class _$InboxDocumentCopyWithImpl<$Res>
    implements $InboxDocumentCopyWith<$Res> {
  _$InboxDocumentCopyWithImpl(this._self, this._then);

  final InboxDocument _self;
  final $Res Function(InboxDocument) _then;

/// Create a copy of InboxDocument
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? submissions = null,Object? failed = null,Object? report = freezed,}) {
  return _then(InboxDocument(
submissions: null == submissions ? _self.submissions : submissions // ignore: cast_nullable_to_non_nullable
as List<SubmissionPreview>,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as Map<String, ParseException>,report: freezed == report ? _self.report : report // ignore: cast_nullable_to_non_nullable
as ReadReport?,
  ));
}

}


/// Adds pattern-matching-related methods to [InboxDocument].
extension InboxDocumentPatterns on InboxDocument {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InboxDocument value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InboxDocument() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InboxDocument value)  $default,){
final _that = this;
switch (_that) {
case _InboxDocument():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InboxDocument value)?  $default,){
final _that = this;
switch (_that) {
case _InboxDocument() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SubmissionPreview> submissions,  Map<String, ParseException> failed,  ReadReport? report)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InboxDocument() when $default != null:
return $default(_that.submissions,_that.failed,_that.report);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SubmissionPreview> submissions,  Map<String, ParseException> failed,  ReadReport? report)  $default,) {final _that = this;
switch (_that) {
case _InboxDocument():
return $default(_that.submissions,_that.failed,_that.report);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SubmissionPreview> submissions,  Map<String, ParseException> failed,  ReadReport? report)?  $default,) {final _that = this;
switch (_that) {
case _InboxDocument() when $default != null:
return $default(_that.submissions,_that.failed,_that.report);case _:
  return null;

}
}

}

/// @nodoc


class _InboxDocument extends InboxDocument {
  const _InboxDocument({ List<SubmissionPreview> submissions = const [],  Map<String, ParseException> failed = const {}, this.report}): _submissions = submissions,_failed = failed,super._();
  

 final  List<SubmissionPreview> _submissions;
@override@JsonKey() List<SubmissionPreview> get submissions {
  if (_submissions is EqualUnmodifiableListView) return _submissions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_submissions);
}

 final  Map<String, ParseException> _failed;
@override@JsonKey() Map<String, ParseException> get failed {
  if (_failed is EqualUnmodifiableMapView) return _failed;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_failed);
}

@override final  ReadReport? report;

/// Create a copy of InboxDocument
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InboxDocumentCopyWith<_InboxDocument> get copyWith => __$InboxDocumentCopyWithImpl<_InboxDocument>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _InboxDocument&&const DeepCollectionEquality().equals(other.submissions, _submissions)&&const DeepCollectionEquality().equals(other.failed, _failed)&&(identical(other.report, report) || other.report == report));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_submissions),const DeepCollectionEquality().hash(_failed),report);
}

@override
String toString() {
    return 'InboxDocument(submissions: $submissions, failed: $failed, report: $report)';
}


}

/// @nodoc
abstract mixin class _$InboxDocumentCopyWith<$Res> implements $InboxDocumentCopyWith<$Res> {
  factory _$InboxDocumentCopyWith(_InboxDocument value, $Res Function(_InboxDocument) _then) = __$InboxDocumentCopyWithImpl;
@override @useResult
$Res call({
 List<SubmissionPreview> submissions, Map<String, ParseException> failed, ReadReport? report
});




}
/// @nodoc
class __$InboxDocumentCopyWithImpl<$Res>
    implements _$InboxDocumentCopyWith<$Res> {
  __$InboxDocumentCopyWithImpl(this._self, this._then);

  final _InboxDocument _self;
  final $Res Function(_InboxDocument) _then;

/// Create a copy of InboxDocument
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? submissions = null,Object? failed = null,Object? report = freezed,}) {
  return _then(_InboxDocument(
submissions: null == submissions ? _self._submissions : submissions // ignore: cast_nullable_to_non_nullable
as List<SubmissionPreview>,failed: null == failed ? _self._failed : failed // ignore: cast_nullable_to_non_nullable
as Map<String, ParseException>,report: freezed == report ? _self.report : report // ignore: cast_nullable_to_non_nullable
as ReadReport?,
  ));
}


}

// dart format on
