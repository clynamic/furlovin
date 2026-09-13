// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_document.rules.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserDocument {

 User get user; List<Contact> get contacts; List<Fact> get facts; List<SubmissionPreview> get favorites; List<SubmissionPreview> get gallery; List<Shout> get shouts; Map<String, ParseException> get failed; DocumentErrors? get errors;
/// Create a copy of UserDocument
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserDocumentCopyWith<UserDocument> get copyWith => _$UserDocumentCopyWithImpl<UserDocument>(this as UserDocument, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as UserDocument;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserDocument&&(identical(other.user, _this.user) || other.user == _this.user)&&const DeepCollectionEquality().equals(other.contacts, _this.contacts)&&const DeepCollectionEquality().equals(other.facts, _this.facts)&&const DeepCollectionEquality().equals(other.favorites, _this.favorites)&&const DeepCollectionEquality().equals(other.gallery, _this.gallery)&&const DeepCollectionEquality().equals(other.shouts, _this.shouts)&&const DeepCollectionEquality().equals(other.failed, _this.failed)&&(identical(other.errors, _this.errors) || other.errors == _this.errors));
}


@override
int get hashCode {
  final _this = this as UserDocument;
  return Object.hash(runtimeType,_this.user,const DeepCollectionEquality().hash(_this.contacts),const DeepCollectionEquality().hash(_this.facts),const DeepCollectionEquality().hash(_this.favorites),const DeepCollectionEquality().hash(_this.gallery),const DeepCollectionEquality().hash(_this.shouts),const DeepCollectionEquality().hash(_this.failed),_this.errors);
}

@override
String toString() {
  final _this = this as UserDocument;
  return 'UserDocument(user: ${_this.user}, contacts: ${_this.contacts}, facts: ${_this.facts}, favorites: ${_this.favorites}, gallery: ${_this.gallery}, shouts: ${_this.shouts}, failed: ${_this.failed}, errors: ${_this.errors})';
}


}

/// @nodoc
abstract mixin class $UserDocumentCopyWith<$Res>  {
  factory $UserDocumentCopyWith(UserDocument value, $Res Function(UserDocument) _then) = _$UserDocumentCopyWithImpl;
@useResult
$Res call({
 User user, List<Contact> contacts, List<Fact> facts, List<SubmissionPreview> favorites, List<SubmissionPreview> gallery, List<Shout> shouts, Map<String, ParseException> failed, DocumentErrors? errors
});


$UserCopyWith<$Res> get user;

}
/// @nodoc
class _$UserDocumentCopyWithImpl<$Res>
    implements $UserDocumentCopyWith<$Res> {
  _$UserDocumentCopyWithImpl(this._self, this._then);

  final UserDocument _self;
  final $Res Function(UserDocument) _then;

/// Create a copy of UserDocument
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? user = null,Object? contacts = null,Object? facts = null,Object? favorites = null,Object? gallery = null,Object? shouts = null,Object? failed = null,Object? errors = freezed,}) {
  return _then(UserDocument(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User,contacts: null == contacts ? _self.contacts : contacts // ignore: cast_nullable_to_non_nullable
as List<Contact>,facts: null == facts ? _self.facts : facts // ignore: cast_nullable_to_non_nullable
as List<Fact>,favorites: null == favorites ? _self.favorites : favorites // ignore: cast_nullable_to_non_nullable
as List<SubmissionPreview>,gallery: null == gallery ? _self.gallery : gallery // ignore: cast_nullable_to_non_nullable
as List<SubmissionPreview>,shouts: null == shouts ? _self.shouts : shouts // ignore: cast_nullable_to_non_nullable
as List<Shout>,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as Map<String, ParseException>,errors: freezed == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as DocumentErrors?,
  ));
}
/// Create a copy of UserDocument
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get user {
  
  return $UserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [UserDocument].
extension UserDocumentPatterns on UserDocument {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserDocument value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserDocument() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserDocument value)  $default,){
final _that = this;
switch (_that) {
case _UserDocument():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserDocument value)?  $default,){
final _that = this;
switch (_that) {
case _UserDocument() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( User user,  List<Contact> contacts,  List<Fact> facts,  List<SubmissionPreview> favorites,  List<SubmissionPreview> gallery,  List<Shout> shouts,  Map<String, ParseException> failed,  DocumentErrors? errors)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserDocument() when $default != null:
return $default(_that.user,_that.contacts,_that.facts,_that.favorites,_that.gallery,_that.shouts,_that.failed,_that.errors);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( User user,  List<Contact> contacts,  List<Fact> facts,  List<SubmissionPreview> favorites,  List<SubmissionPreview> gallery,  List<Shout> shouts,  Map<String, ParseException> failed,  DocumentErrors? errors)  $default,) {final _that = this;
switch (_that) {
case _UserDocument():
return $default(_that.user,_that.contacts,_that.facts,_that.favorites,_that.gallery,_that.shouts,_that.failed,_that.errors);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( User user,  List<Contact> contacts,  List<Fact> facts,  List<SubmissionPreview> favorites,  List<SubmissionPreview> gallery,  List<Shout> shouts,  Map<String, ParseException> failed,  DocumentErrors? errors)?  $default,) {final _that = this;
switch (_that) {
case _UserDocument() when $default != null:
return $default(_that.user,_that.contacts,_that.facts,_that.favorites,_that.gallery,_that.shouts,_that.failed,_that.errors);case _:
  return null;

}
}

}

/// @nodoc


class _UserDocument extends UserDocument {
  const _UserDocument({required this.user,  List<Contact> contacts = const [],  List<Fact> facts = const [],  List<SubmissionPreview> favorites = const [],  List<SubmissionPreview> gallery = const [],  List<Shout> shouts = const [],  Map<String, ParseException> failed = const {}, this.errors}): _contacts = contacts,_facts = facts,_favorites = favorites,_gallery = gallery,_shouts = shouts,_failed = failed,super._();
  

@override final  User user;
 final  List<Contact> _contacts;
@override@JsonKey() List<Contact> get contacts {
  if (_contacts is EqualUnmodifiableListView) return _contacts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_contacts);
}

 final  List<Fact> _facts;
@override@JsonKey() List<Fact> get facts {
  if (_facts is EqualUnmodifiableListView) return _facts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_facts);
}

 final  List<SubmissionPreview> _favorites;
@override@JsonKey() List<SubmissionPreview> get favorites {
  if (_favorites is EqualUnmodifiableListView) return _favorites;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_favorites);
}

 final  List<SubmissionPreview> _gallery;
@override@JsonKey() List<SubmissionPreview> get gallery {
  if (_gallery is EqualUnmodifiableListView) return _gallery;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_gallery);
}

 final  List<Shout> _shouts;
@override@JsonKey() List<Shout> get shouts {
  if (_shouts is EqualUnmodifiableListView) return _shouts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_shouts);
}

 final  Map<String, ParseException> _failed;
@override@JsonKey() Map<String, ParseException> get failed {
  if (_failed is EqualUnmodifiableMapView) return _failed;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_failed);
}

@override final  DocumentErrors? errors;

/// Create a copy of UserDocument
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserDocumentCopyWith<_UserDocument> get copyWith => __$UserDocumentCopyWithImpl<_UserDocument>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserDocument&&(identical(other.user, user) || other.user == user)&&const DeepCollectionEquality().equals(other.contacts, _contacts)&&const DeepCollectionEquality().equals(other.facts, _facts)&&const DeepCollectionEquality().equals(other.favorites, _favorites)&&const DeepCollectionEquality().equals(other.gallery, _gallery)&&const DeepCollectionEquality().equals(other.shouts, _shouts)&&const DeepCollectionEquality().equals(other.failed, _failed)&&(identical(other.errors, errors) || other.errors == errors));
}


@override
int get hashCode {
    return Object.hash(runtimeType,user,const DeepCollectionEquality().hash(_contacts),const DeepCollectionEquality().hash(_facts),const DeepCollectionEquality().hash(_favorites),const DeepCollectionEquality().hash(_gallery),const DeepCollectionEquality().hash(_shouts),const DeepCollectionEquality().hash(_failed),errors);
}

@override
String toString() {
    return 'UserDocument(user: $user, contacts: $contacts, facts: $facts, favorites: $favorites, gallery: $gallery, shouts: $shouts, failed: $failed, errors: $errors)';
}


}

/// @nodoc
abstract mixin class _$UserDocumentCopyWith<$Res> implements $UserDocumentCopyWith<$Res> {
  factory _$UserDocumentCopyWith(_UserDocument value, $Res Function(_UserDocument) _then) = __$UserDocumentCopyWithImpl;
@override @useResult
$Res call({
 User user, List<Contact> contacts, List<Fact> facts, List<SubmissionPreview> favorites, List<SubmissionPreview> gallery, List<Shout> shouts, Map<String, ParseException> failed, DocumentErrors? errors
});


@override $UserCopyWith<$Res> get user;

}
/// @nodoc
class __$UserDocumentCopyWithImpl<$Res>
    implements _$UserDocumentCopyWith<$Res> {
  __$UserDocumentCopyWithImpl(this._self, this._then);

  final _UserDocument _self;
  final $Res Function(_UserDocument) _then;

/// Create a copy of UserDocument
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? user = null,Object? contacts = null,Object? facts = null,Object? favorites = null,Object? gallery = null,Object? shouts = null,Object? failed = null,Object? errors = freezed,}) {
  return _then(_UserDocument(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User,contacts: null == contacts ? _self._contacts : contacts // ignore: cast_nullable_to_non_nullable
as List<Contact>,facts: null == facts ? _self._facts : facts // ignore: cast_nullable_to_non_nullable
as List<Fact>,favorites: null == favorites ? _self._favorites : favorites // ignore: cast_nullable_to_non_nullable
as List<SubmissionPreview>,gallery: null == gallery ? _self._gallery : gallery // ignore: cast_nullable_to_non_nullable
as List<SubmissionPreview>,shouts: null == shouts ? _self._shouts : shouts // ignore: cast_nullable_to_non_nullable
as List<Shout>,failed: null == failed ? _self._failed : failed // ignore: cast_nullable_to_non_nullable
as Map<String, ParseException>,errors: freezed == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as DocumentErrors?,
  ));
}

/// Create a copy of UserDocument
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get user {
  
  return $UserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

// dart format on
