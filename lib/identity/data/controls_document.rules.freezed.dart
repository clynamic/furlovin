// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'controls_document.rules.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ControlsDocument {

 Viewer? get viewer; Map<String, ParseException> get failed; DocumentErrors? get errors;
/// Create a copy of ControlsDocument
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ControlsDocumentCopyWith<ControlsDocument> get copyWith => _$ControlsDocumentCopyWithImpl<ControlsDocument>(this as ControlsDocument, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ControlsDocument;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ControlsDocument&&(identical(other.viewer, _this.viewer) || other.viewer == _this.viewer)&&const DeepCollectionEquality().equals(other.failed, _this.failed)&&(identical(other.errors, _this.errors) || other.errors == _this.errors));
}


@override
int get hashCode {
  final _this = this as ControlsDocument;
  return Object.hash(runtimeType,_this.viewer,const DeepCollectionEquality().hash(_this.failed),_this.errors);
}

@override
String toString() {
  final _this = this as ControlsDocument;
  return 'ControlsDocument(viewer: ${_this.viewer}, failed: ${_this.failed}, errors: ${_this.errors})';
}


}

/// @nodoc
abstract mixin class $ControlsDocumentCopyWith<$Res>  {
  factory $ControlsDocumentCopyWith(ControlsDocument value, $Res Function(ControlsDocument) _then) = _$ControlsDocumentCopyWithImpl;
@useResult
$Res call({
 Viewer? viewer, Map<String, ParseException> failed, DocumentErrors? errors
});


$ViewerCopyWith<$Res>? get viewer;

}
/// @nodoc
class _$ControlsDocumentCopyWithImpl<$Res>
    implements $ControlsDocumentCopyWith<$Res> {
  _$ControlsDocumentCopyWithImpl(this._self, this._then);

  final ControlsDocument _self;
  final $Res Function(ControlsDocument) _then;

/// Create a copy of ControlsDocument
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? viewer = freezed,Object? failed = null,Object? errors = freezed,}) {
  return _then(ControlsDocument(
viewer: freezed == viewer ? _self.viewer : viewer // ignore: cast_nullable_to_non_nullable
as Viewer?,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as Map<String, ParseException>,errors: freezed == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as DocumentErrors?,
  ));
}
/// Create a copy of ControlsDocument
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ViewerCopyWith<$Res>? get viewer {
    if (_self.viewer == null) {
    return null;
  }

  return $ViewerCopyWith<$Res>(_self.viewer!, (value) {
    return _then(_self.copyWith(viewer: value));
  });
}
}


/// Adds pattern-matching-related methods to [ControlsDocument].
extension ControlsDocumentPatterns on ControlsDocument {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ControlsDocument value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ControlsDocument() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ControlsDocument value)  $default,){
final _that = this;
switch (_that) {
case _ControlsDocument():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ControlsDocument value)?  $default,){
final _that = this;
switch (_that) {
case _ControlsDocument() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Viewer? viewer,  Map<String, ParseException> failed,  DocumentErrors? errors)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ControlsDocument() when $default != null:
return $default(_that.viewer,_that.failed,_that.errors);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Viewer? viewer,  Map<String, ParseException> failed,  DocumentErrors? errors)  $default,) {final _that = this;
switch (_that) {
case _ControlsDocument():
return $default(_that.viewer,_that.failed,_that.errors);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Viewer? viewer,  Map<String, ParseException> failed,  DocumentErrors? errors)?  $default,) {final _that = this;
switch (_that) {
case _ControlsDocument() when $default != null:
return $default(_that.viewer,_that.failed,_that.errors);case _:
  return null;

}
}

}

/// @nodoc


class _ControlsDocument extends ControlsDocument {
  const _ControlsDocument({this.viewer,  Map<String, ParseException> failed = const {}, this.errors}): _failed = failed,super._();
  

@override final  Viewer? viewer;
 final  Map<String, ParseException> _failed;
@override@JsonKey() Map<String, ParseException> get failed {
  if (_failed is EqualUnmodifiableMapView) return _failed;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_failed);
}

@override final  DocumentErrors? errors;

/// Create a copy of ControlsDocument
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ControlsDocumentCopyWith<_ControlsDocument> get copyWith => __$ControlsDocumentCopyWithImpl<_ControlsDocument>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ControlsDocument&&(identical(other.viewer, viewer) || other.viewer == viewer)&&const DeepCollectionEquality().equals(other.failed, _failed)&&(identical(other.errors, errors) || other.errors == errors));
}


@override
int get hashCode {
    return Object.hash(runtimeType,viewer,const DeepCollectionEquality().hash(_failed),errors);
}

@override
String toString() {
    return 'ControlsDocument(viewer: $viewer, failed: $failed, errors: $errors)';
}


}

/// @nodoc
abstract mixin class _$ControlsDocumentCopyWith<$Res> implements $ControlsDocumentCopyWith<$Res> {
  factory _$ControlsDocumentCopyWith(_ControlsDocument value, $Res Function(_ControlsDocument) _then) = __$ControlsDocumentCopyWithImpl;
@override @useResult
$Res call({
 Viewer? viewer, Map<String, ParseException> failed, DocumentErrors? errors
});


@override $ViewerCopyWith<$Res>? get viewer;

}
/// @nodoc
class __$ControlsDocumentCopyWithImpl<$Res>
    implements _$ControlsDocumentCopyWith<$Res> {
  __$ControlsDocumentCopyWithImpl(this._self, this._then);

  final _ControlsDocument _self;
  final $Res Function(_ControlsDocument) _then;

/// Create a copy of ControlsDocument
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? viewer = freezed,Object? failed = null,Object? errors = freezed,}) {
  return _then(_ControlsDocument(
viewer: freezed == viewer ? _self.viewer : viewer // ignore: cast_nullable_to_non_nullable
as Viewer?,failed: null == failed ? _self._failed : failed // ignore: cast_nullable_to_non_nullable
as Map<String, ParseException>,errors: freezed == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as DocumentErrors?,
  ));
}

/// Create a copy of ControlsDocument
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ViewerCopyWith<$Res>? get viewer {
    if (_self.viewer == null) {
    return null;
  }

  return $ViewerCopyWith<$Res>(_self.viewer!, (value) {
    return _then(_self.copyWith(viewer: value));
  });
}
}

// dart format on
