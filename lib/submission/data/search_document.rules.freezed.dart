// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_document.rules.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SearchDocument {

 List<SubmissionPreview> get submissions; Map<String, ParseException> get failed; DocumentErrors? get errors;
/// Create a copy of SearchDocument
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchDocumentCopyWith<SearchDocument> get copyWith => _$SearchDocumentCopyWithImpl<SearchDocument>(this as SearchDocument, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SearchDocument;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchDocument&&const DeepCollectionEquality().equals(other.submissions, _this.submissions)&&const DeepCollectionEquality().equals(other.failed, _this.failed)&&(identical(other.errors, _this.errors) || other.errors == _this.errors));
}


@override
int get hashCode {
  final _this = this as SearchDocument;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.submissions),const DeepCollectionEquality().hash(_this.failed),_this.errors);
}

@override
String toString() {
  final _this = this as SearchDocument;
  return 'SearchDocument(submissions: ${_this.submissions}, failed: ${_this.failed}, errors: ${_this.errors})';
}


}

/// @nodoc
abstract mixin class $SearchDocumentCopyWith<$Res>  {
  factory $SearchDocumentCopyWith(SearchDocument value, $Res Function(SearchDocument) _then) = _$SearchDocumentCopyWithImpl;
@useResult
$Res call({
 List<SubmissionPreview> submissions, Map<String, ParseException> failed, DocumentErrors? errors
});




}
/// @nodoc
class _$SearchDocumentCopyWithImpl<$Res>
    implements $SearchDocumentCopyWith<$Res> {
  _$SearchDocumentCopyWithImpl(this._self, this._then);

  final SearchDocument _self;
  final $Res Function(SearchDocument) _then;

/// Create a copy of SearchDocument
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? submissions = null,Object? failed = null,Object? errors = freezed,}) {
  return _then(SearchDocument(
submissions: null == submissions ? _self.submissions : submissions // ignore: cast_nullable_to_non_nullable
as List<SubmissionPreview>,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as Map<String, ParseException>,errors: freezed == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as DocumentErrors?,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchDocument].
extension SearchDocumentPatterns on SearchDocument {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchDocument value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchDocument() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchDocument value)  $default,){
final _that = this;
switch (_that) {
case _SearchDocument():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchDocument value)?  $default,){
final _that = this;
switch (_that) {
case _SearchDocument() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SubmissionPreview> submissions,  Map<String, ParseException> failed,  DocumentErrors? errors)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchDocument() when $default != null:
return $default(_that.submissions,_that.failed,_that.errors);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SubmissionPreview> submissions,  Map<String, ParseException> failed,  DocumentErrors? errors)  $default,) {final _that = this;
switch (_that) {
case _SearchDocument():
return $default(_that.submissions,_that.failed,_that.errors);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SubmissionPreview> submissions,  Map<String, ParseException> failed,  DocumentErrors? errors)?  $default,) {final _that = this;
switch (_that) {
case _SearchDocument() when $default != null:
return $default(_that.submissions,_that.failed,_that.errors);case _:
  return null;

}
}

}

/// @nodoc


class _SearchDocument extends SearchDocument {
  const _SearchDocument({ List<SubmissionPreview> submissions = const [],  Map<String, ParseException> failed = const {}, this.errors}): _submissions = submissions,_failed = failed,super._();
  

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

@override final  DocumentErrors? errors;

/// Create a copy of SearchDocument
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchDocumentCopyWith<_SearchDocument> get copyWith => __$SearchDocumentCopyWithImpl<_SearchDocument>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchDocument&&const DeepCollectionEquality().equals(other.submissions, _submissions)&&const DeepCollectionEquality().equals(other.failed, _failed)&&(identical(other.errors, errors) || other.errors == errors));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_submissions),const DeepCollectionEquality().hash(_failed),errors);
}

@override
String toString() {
    return 'SearchDocument(submissions: $submissions, failed: $failed, errors: $errors)';
}


}

/// @nodoc
abstract mixin class _$SearchDocumentCopyWith<$Res> implements $SearchDocumentCopyWith<$Res> {
  factory _$SearchDocumentCopyWith(_SearchDocument value, $Res Function(_SearchDocument) _then) = __$SearchDocumentCopyWithImpl;
@override @useResult
$Res call({
 List<SubmissionPreview> submissions, Map<String, ParseException> failed, DocumentErrors? errors
});




}
/// @nodoc
class __$SearchDocumentCopyWithImpl<$Res>
    implements _$SearchDocumentCopyWith<$Res> {
  __$SearchDocumentCopyWithImpl(this._self, this._then);

  final _SearchDocument _self;
  final $Res Function(_SearchDocument) _then;

/// Create a copy of SearchDocument
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? submissions = null,Object? failed = null,Object? errors = freezed,}) {
  return _then(_SearchDocument(
submissions: null == submissions ? _self._submissions : submissions // ignore: cast_nullable_to_non_nullable
as List<SubmissionPreview>,failed: null == failed ? _self._failed : failed // ignore: cast_nullable_to_non_nullable
as Map<String, ParseException>,errors: freezed == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as DocumentErrors?,
  ));
}


}

// dart format on
