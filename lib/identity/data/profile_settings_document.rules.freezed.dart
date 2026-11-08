// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_settings_document.rules.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfileSettingsDocument {

/// Blocked member names, one per line.
 String get blockedUsers;/// Whether the account hides blocked members' work outside their
/// profiles. With it off, the data-user-blocklist attribute on pages is
/// empty.
 bool? get hideBlockedContent; Map<String, ParseException> get failed; DocumentErrors? get errors;
/// Create a copy of ProfileSettingsDocument
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileSettingsDocumentCopyWith<ProfileSettingsDocument> get copyWith => _$ProfileSettingsDocumentCopyWithImpl<ProfileSettingsDocument>(this as ProfileSettingsDocument, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ProfileSettingsDocument;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileSettingsDocument&&(identical(other.blockedUsers, _this.blockedUsers) || other.blockedUsers == _this.blockedUsers)&&(identical(other.hideBlockedContent, _this.hideBlockedContent) || other.hideBlockedContent == _this.hideBlockedContent)&&const DeepCollectionEquality().equals(other.failed, _this.failed)&&(identical(other.errors, _this.errors) || other.errors == _this.errors));
}


@override
int get hashCode {
  final _this = this as ProfileSettingsDocument;
  return Object.hash(runtimeType,_this.blockedUsers,_this.hideBlockedContent,const DeepCollectionEquality().hash(_this.failed),_this.errors);
}

@override
String toString() {
  final _this = this as ProfileSettingsDocument;
  return 'ProfileSettingsDocument(blockedUsers: ${_this.blockedUsers}, hideBlockedContent: ${_this.hideBlockedContent}, failed: ${_this.failed}, errors: ${_this.errors})';
}


}

/// @nodoc
abstract mixin class $ProfileSettingsDocumentCopyWith<$Res>  {
  factory $ProfileSettingsDocumentCopyWith(ProfileSettingsDocument value, $Res Function(ProfileSettingsDocument) _then) = _$ProfileSettingsDocumentCopyWithImpl;
@useResult
$Res call({
 String blockedUsers, bool? hideBlockedContent, Map<String, ParseException> failed, DocumentErrors? errors
});




}
/// @nodoc
class _$ProfileSettingsDocumentCopyWithImpl<$Res>
    implements $ProfileSettingsDocumentCopyWith<$Res> {
  _$ProfileSettingsDocumentCopyWithImpl(this._self, this._then);

  final ProfileSettingsDocument _self;
  final $Res Function(ProfileSettingsDocument) _then;

/// Create a copy of ProfileSettingsDocument
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? blockedUsers = null,Object? hideBlockedContent = freezed,Object? failed = null,Object? errors = freezed,}) {
  return _then(ProfileSettingsDocument(
blockedUsers: null == blockedUsers ? _self.blockedUsers : blockedUsers // ignore: cast_nullable_to_non_nullable
as String,hideBlockedContent: freezed == hideBlockedContent ? _self.hideBlockedContent : hideBlockedContent // ignore: cast_nullable_to_non_nullable
as bool?,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as Map<String, ParseException>,errors: freezed == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as DocumentErrors?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileSettingsDocument].
extension ProfileSettingsDocumentPatterns on ProfileSettingsDocument {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileSettingsDocument value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileSettingsDocument() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileSettingsDocument value)  $default,){
final _that = this;
switch (_that) {
case _ProfileSettingsDocument():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileSettingsDocument value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileSettingsDocument() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String blockedUsers,  bool? hideBlockedContent,  Map<String, ParseException> failed,  DocumentErrors? errors)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileSettingsDocument() when $default != null:
return $default(_that.blockedUsers,_that.hideBlockedContent,_that.failed,_that.errors);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String blockedUsers,  bool? hideBlockedContent,  Map<String, ParseException> failed,  DocumentErrors? errors)  $default,) {final _that = this;
switch (_that) {
case _ProfileSettingsDocument():
return $default(_that.blockedUsers,_that.hideBlockedContent,_that.failed,_that.errors);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String blockedUsers,  bool? hideBlockedContent,  Map<String, ParseException> failed,  DocumentErrors? errors)?  $default,) {final _that = this;
switch (_that) {
case _ProfileSettingsDocument() when $default != null:
return $default(_that.blockedUsers,_that.hideBlockedContent,_that.failed,_that.errors);case _:
  return null;

}
}

}

/// @nodoc


class _ProfileSettingsDocument extends ProfileSettingsDocument {
  const _ProfileSettingsDocument({required this.blockedUsers, this.hideBlockedContent,  Map<String, ParseException> failed = const {}, this.errors}): _failed = failed,super._();
  

/// Blocked member names, one per line.
@override final  String blockedUsers;
/// Whether the account hides blocked members' work outside their
/// profiles. With it off, the data-user-blocklist attribute on pages is
/// empty.
@override final  bool? hideBlockedContent;
 final  Map<String, ParseException> _failed;
@override@JsonKey() Map<String, ParseException> get failed {
  if (_failed is EqualUnmodifiableMapView) return _failed;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_failed);
}

@override final  DocumentErrors? errors;

/// Create a copy of ProfileSettingsDocument
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileSettingsDocumentCopyWith<_ProfileSettingsDocument> get copyWith => __$ProfileSettingsDocumentCopyWithImpl<_ProfileSettingsDocument>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileSettingsDocument&&(identical(other.blockedUsers, blockedUsers) || other.blockedUsers == blockedUsers)&&(identical(other.hideBlockedContent, hideBlockedContent) || other.hideBlockedContent == hideBlockedContent)&&const DeepCollectionEquality().equals(other.failed, _failed)&&(identical(other.errors, errors) || other.errors == errors));
}


@override
int get hashCode {
    return Object.hash(runtimeType,blockedUsers,hideBlockedContent,const DeepCollectionEquality().hash(_failed),errors);
}

@override
String toString() {
    return 'ProfileSettingsDocument(blockedUsers: $blockedUsers, hideBlockedContent: $hideBlockedContent, failed: $failed, errors: $errors)';
}


}

/// @nodoc
abstract mixin class _$ProfileSettingsDocumentCopyWith<$Res> implements $ProfileSettingsDocumentCopyWith<$Res> {
  factory _$ProfileSettingsDocumentCopyWith(_ProfileSettingsDocument value, $Res Function(_ProfileSettingsDocument) _then) = __$ProfileSettingsDocumentCopyWithImpl;
@override @useResult
$Res call({
 String blockedUsers, bool? hideBlockedContent, Map<String, ParseException> failed, DocumentErrors? errors
});




}
/// @nodoc
class __$ProfileSettingsDocumentCopyWithImpl<$Res>
    implements _$ProfileSettingsDocumentCopyWith<$Res> {
  __$ProfileSettingsDocumentCopyWithImpl(this._self, this._then);

  final _ProfileSettingsDocument _self;
  final $Res Function(_ProfileSettingsDocument) _then;

/// Create a copy of ProfileSettingsDocument
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? blockedUsers = null,Object? hideBlockedContent = freezed,Object? failed = null,Object? errors = freezed,}) {
  return _then(_ProfileSettingsDocument(
blockedUsers: null == blockedUsers ? _self.blockedUsers : blockedUsers // ignore: cast_nullable_to_non_nullable
as String,hideBlockedContent: freezed == hideBlockedContent ? _self.hideBlockedContent : hideBlockedContent // ignore: cast_nullable_to_non_nullable
as bool?,failed: null == failed ? _self._failed : failed // ignore: cast_nullable_to_non_nullable
as Map<String, ParseException>,errors: freezed == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as DocumentErrors?,
  ));
}


}

// dart format on
