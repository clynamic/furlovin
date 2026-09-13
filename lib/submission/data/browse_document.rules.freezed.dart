// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'browse_document.rules.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BrowseDocument {

 List<SubmissionPreview> get submissions; Map<String, ParseException> get failed; DocumentErrors? get errors;
/// Create a copy of BrowseDocument
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BrowseDocumentCopyWith<BrowseDocument> get copyWith => _$BrowseDocumentCopyWithImpl<BrowseDocument>(this as BrowseDocument, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BrowseDocument;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BrowseDocument&&const DeepCollectionEquality().equals(other.submissions, _this.submissions)&&const DeepCollectionEquality().equals(other.failed, _this.failed)&&(identical(other.errors, _this.errors) || other.errors == _this.errors));
}


@override
int get hashCode {
  final _this = this as BrowseDocument;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.submissions),const DeepCollectionEquality().hash(_this.failed),_this.errors);
}

@override
String toString() {
  final _this = this as BrowseDocument;
  return 'BrowseDocument(submissions: ${_this.submissions}, failed: ${_this.failed}, errors: ${_this.errors})';
}


}

/// @nodoc
abstract mixin class $BrowseDocumentCopyWith<$Res>  {
  factory $BrowseDocumentCopyWith(BrowseDocument value, $Res Function(BrowseDocument) _then) = _$BrowseDocumentCopyWithImpl;
@useResult
$Res call({
 List<SubmissionPreview> submissions, Map<String, ParseException> failed, DocumentErrors? errors
});




}
/// @nodoc
class _$BrowseDocumentCopyWithImpl<$Res>
    implements $BrowseDocumentCopyWith<$Res> {
  _$BrowseDocumentCopyWithImpl(this._self, this._then);

  final BrowseDocument _self;
  final $Res Function(BrowseDocument) _then;

/// Create a copy of BrowseDocument
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? submissions = null,Object? failed = null,Object? errors = freezed,}) {
  return _then(BrowseDocument(
submissions: null == submissions ? _self.submissions : submissions // ignore: cast_nullable_to_non_nullable
as List<SubmissionPreview>,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as Map<String, ParseException>,errors: freezed == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as DocumentErrors?,
  ));
}

}


/// Adds pattern-matching-related methods to [BrowseDocument].
extension BrowseDocumentPatterns on BrowseDocument {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BrowseDocument value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BrowseDocument() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BrowseDocument value)  $default,){
final _that = this;
switch (_that) {
case _BrowseDocument():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BrowseDocument value)?  $default,){
final _that = this;
switch (_that) {
case _BrowseDocument() when $default != null:
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
case _BrowseDocument() when $default != null:
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
case _BrowseDocument():
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
case _BrowseDocument() when $default != null:
return $default(_that.submissions,_that.failed,_that.errors);case _:
  return null;

}
}

}

/// @nodoc


class _BrowseDocument extends BrowseDocument {
  const _BrowseDocument({ List<SubmissionPreview> submissions = const [],  Map<String, ParseException> failed = const {}, this.errors}): _submissions = submissions,_failed = failed,super._();
  

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

/// Create a copy of BrowseDocument
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BrowseDocumentCopyWith<_BrowseDocument> get copyWith => __$BrowseDocumentCopyWithImpl<_BrowseDocument>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BrowseDocument&&const DeepCollectionEquality().equals(other.submissions, _submissions)&&const DeepCollectionEquality().equals(other.failed, _failed)&&(identical(other.errors, errors) || other.errors == errors));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_submissions),const DeepCollectionEquality().hash(_failed),errors);
}

@override
String toString() {
    return 'BrowseDocument(submissions: $submissions, failed: $failed, errors: $errors)';
}


}

/// @nodoc
abstract mixin class _$BrowseDocumentCopyWith<$Res> implements $BrowseDocumentCopyWith<$Res> {
  factory _$BrowseDocumentCopyWith(_BrowseDocument value, $Res Function(_BrowseDocument) _then) = __$BrowseDocumentCopyWithImpl;
@override @useResult
$Res call({
 List<SubmissionPreview> submissions, Map<String, ParseException> failed, DocumentErrors? errors
});




}
/// @nodoc
class __$BrowseDocumentCopyWithImpl<$Res>
    implements _$BrowseDocumentCopyWith<$Res> {
  __$BrowseDocumentCopyWithImpl(this._self, this._then);

  final _BrowseDocument _self;
  final $Res Function(_BrowseDocument) _then;

/// Create a copy of BrowseDocument
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? submissions = null,Object? failed = null,Object? errors = freezed,}) {
  return _then(_BrowseDocument(
submissions: null == submissions ? _self._submissions : submissions // ignore: cast_nullable_to_non_nullable
as List<SubmissionPreview>,failed: null == failed ? _self._failed : failed // ignore: cast_nullable_to_non_nullable
as Map<String, ParseException>,errors: freezed == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as DocumentErrors?,
  ));
}


}

// dart format on
