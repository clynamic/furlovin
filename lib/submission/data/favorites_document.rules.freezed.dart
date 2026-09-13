// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favorites_document.rules.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FavoritesDocument {

 List<Favorite> get favorites; Map<String, ParseException> get failed; ReadReport? get report;
/// Create a copy of FavoritesDocument
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FavoritesDocumentCopyWith<FavoritesDocument> get copyWith => _$FavoritesDocumentCopyWithImpl<FavoritesDocument>(this as FavoritesDocument, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FavoritesDocument;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavoritesDocument&&const DeepCollectionEquality().equals(other.favorites, _this.favorites)&&const DeepCollectionEquality().equals(other.failed, _this.failed)&&(identical(other.report, _this.report) || other.report == _this.report));
}


@override
int get hashCode {
  final _this = this as FavoritesDocument;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.favorites),const DeepCollectionEquality().hash(_this.failed),_this.report);
}

@override
String toString() {
  final _this = this as FavoritesDocument;
  return 'FavoritesDocument(favorites: ${_this.favorites}, failed: ${_this.failed}, report: ${_this.report})';
}


}

/// @nodoc
abstract mixin class $FavoritesDocumentCopyWith<$Res>  {
  factory $FavoritesDocumentCopyWith(FavoritesDocument value, $Res Function(FavoritesDocument) _then) = _$FavoritesDocumentCopyWithImpl;
@useResult
$Res call({
 List<Favorite> favorites, Map<String, ParseException> failed, ReadReport? report
});




}
/// @nodoc
class _$FavoritesDocumentCopyWithImpl<$Res>
    implements $FavoritesDocumentCopyWith<$Res> {
  _$FavoritesDocumentCopyWithImpl(this._self, this._then);

  final FavoritesDocument _self;
  final $Res Function(FavoritesDocument) _then;

/// Create a copy of FavoritesDocument
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? favorites = null,Object? failed = null,Object? report = freezed,}) {
  return _then(FavoritesDocument(
favorites: null == favorites ? _self.favorites : favorites // ignore: cast_nullable_to_non_nullable
as List<Favorite>,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as Map<String, ParseException>,report: freezed == report ? _self.report : report // ignore: cast_nullable_to_non_nullable
as ReadReport?,
  ));
}

}


/// Adds pattern-matching-related methods to [FavoritesDocument].
extension FavoritesDocumentPatterns on FavoritesDocument {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FavoritesDocument value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FavoritesDocument() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FavoritesDocument value)  $default,){
final _that = this;
switch (_that) {
case _FavoritesDocument():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FavoritesDocument value)?  $default,){
final _that = this;
switch (_that) {
case _FavoritesDocument() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Favorite> favorites,  Map<String, ParseException> failed,  ReadReport? report)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FavoritesDocument() when $default != null:
return $default(_that.favorites,_that.failed,_that.report);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Favorite> favorites,  Map<String, ParseException> failed,  ReadReport? report)  $default,) {final _that = this;
switch (_that) {
case _FavoritesDocument():
return $default(_that.favorites,_that.failed,_that.report);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Favorite> favorites,  Map<String, ParseException> failed,  ReadReport? report)?  $default,) {final _that = this;
switch (_that) {
case _FavoritesDocument() when $default != null:
return $default(_that.favorites,_that.failed,_that.report);case _:
  return null;

}
}

}

/// @nodoc


class _FavoritesDocument extends FavoritesDocument {
  const _FavoritesDocument({ List<Favorite> favorites = const [],  Map<String, ParseException> failed = const {}, this.report}): _favorites = favorites,_failed = failed,super._();
  

 final  List<Favorite> _favorites;
@override@JsonKey() List<Favorite> get favorites {
  if (_favorites is EqualUnmodifiableListView) return _favorites;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_favorites);
}

 final  Map<String, ParseException> _failed;
@override@JsonKey() Map<String, ParseException> get failed {
  if (_failed is EqualUnmodifiableMapView) return _failed;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_failed);
}

@override final  ReadReport? report;

/// Create a copy of FavoritesDocument
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FavoritesDocumentCopyWith<_FavoritesDocument> get copyWith => __$FavoritesDocumentCopyWithImpl<_FavoritesDocument>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FavoritesDocument&&const DeepCollectionEquality().equals(other.favorites, _favorites)&&const DeepCollectionEquality().equals(other.failed, _failed)&&(identical(other.report, report) || other.report == report));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_favorites),const DeepCollectionEquality().hash(_failed),report);
}

@override
String toString() {
    return 'FavoritesDocument(favorites: $favorites, failed: $failed, report: $report)';
}


}

/// @nodoc
abstract mixin class _$FavoritesDocumentCopyWith<$Res> implements $FavoritesDocumentCopyWith<$Res> {
  factory _$FavoritesDocumentCopyWith(_FavoritesDocument value, $Res Function(_FavoritesDocument) _then) = __$FavoritesDocumentCopyWithImpl;
@override @useResult
$Res call({
 List<Favorite> favorites, Map<String, ParseException> failed, ReadReport? report
});




}
/// @nodoc
class __$FavoritesDocumentCopyWithImpl<$Res>
    implements _$FavoritesDocumentCopyWith<$Res> {
  __$FavoritesDocumentCopyWithImpl(this._self, this._then);

  final _FavoritesDocument _self;
  final $Res Function(_FavoritesDocument) _then;

/// Create a copy of FavoritesDocument
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? favorites = null,Object? failed = null,Object? report = freezed,}) {
  return _then(_FavoritesDocument(
favorites: null == favorites ? _self._favorites : favorites // ignore: cast_nullable_to_non_nullable
as List<Favorite>,failed: null == failed ? _self._failed : failed // ignore: cast_nullable_to_non_nullable
as Map<String, ParseException>,report: freezed == report ? _self.report : report // ignore: cast_nullable_to_non_nullable
as ReadReport?,
  ));
}


}

// dart format on
