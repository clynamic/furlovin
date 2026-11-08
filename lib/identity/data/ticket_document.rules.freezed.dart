// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ticket_document.rules.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TicketDocument {

 TicketForm get ticket; Map<String, ParseException> get failed; DocumentErrors? get errors;
/// Create a copy of TicketDocument
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketDocumentCopyWith<TicketDocument> get copyWith => _$TicketDocumentCopyWithImpl<TicketDocument>(this as TicketDocument, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TicketDocument;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketDocument&&(identical(other.ticket, _this.ticket) || other.ticket == _this.ticket)&&const DeepCollectionEquality().equals(other.failed, _this.failed)&&(identical(other.errors, _this.errors) || other.errors == _this.errors));
}


@override
int get hashCode {
  final _this = this as TicketDocument;
  return Object.hash(runtimeType,_this.ticket,const DeepCollectionEquality().hash(_this.failed),_this.errors);
}

@override
String toString() {
  final _this = this as TicketDocument;
  return 'TicketDocument(ticket: ${_this.ticket}, failed: ${_this.failed}, errors: ${_this.errors})';
}


}

/// @nodoc
abstract mixin class $TicketDocumentCopyWith<$Res>  {
  factory $TicketDocumentCopyWith(TicketDocument value, $Res Function(TicketDocument) _then) = _$TicketDocumentCopyWithImpl;
@useResult
$Res call({
 TicketForm ticket, Map<String, ParseException> failed, DocumentErrors? errors
});


$TicketFormCopyWith<$Res> get ticket;

}
/// @nodoc
class _$TicketDocumentCopyWithImpl<$Res>
    implements $TicketDocumentCopyWith<$Res> {
  _$TicketDocumentCopyWithImpl(this._self, this._then);

  final TicketDocument _self;
  final $Res Function(TicketDocument) _then;

/// Create a copy of TicketDocument
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ticket = null,Object? failed = null,Object? errors = freezed,}) {
  return _then(TicketDocument(
ticket: null == ticket ? _self.ticket : ticket // ignore: cast_nullable_to_non_nullable
as TicketForm,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as Map<String, ParseException>,errors: freezed == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as DocumentErrors?,
  ));
}
/// Create a copy of TicketDocument
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TicketFormCopyWith<$Res> get ticket {
  
  return $TicketFormCopyWith<$Res>(_self.ticket, (value) {
    return _then(_self.copyWith(ticket: value));
  });
}
}


/// Adds pattern-matching-related methods to [TicketDocument].
extension TicketDocumentPatterns on TicketDocument {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TicketDocument value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TicketDocument() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TicketDocument value)  $default,){
final _that = this;
switch (_that) {
case _TicketDocument():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TicketDocument value)?  $default,){
final _that = this;
switch (_that) {
case _TicketDocument() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TicketForm ticket,  Map<String, ParseException> failed,  DocumentErrors? errors)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TicketDocument() when $default != null:
return $default(_that.ticket,_that.failed,_that.errors);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TicketForm ticket,  Map<String, ParseException> failed,  DocumentErrors? errors)  $default,) {final _that = this;
switch (_that) {
case _TicketDocument():
return $default(_that.ticket,_that.failed,_that.errors);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TicketForm ticket,  Map<String, ParseException> failed,  DocumentErrors? errors)?  $default,) {final _that = this;
switch (_that) {
case _TicketDocument() when $default != null:
return $default(_that.ticket,_that.failed,_that.errors);case _:
  return null;

}
}

}

/// @nodoc


class _TicketDocument extends TicketDocument {
  const _TicketDocument({required this.ticket,  Map<String, ParseException> failed = const {}, this.errors}): _failed = failed,super._();
  

@override final  TicketForm ticket;
 final  Map<String, ParseException> _failed;
@override@JsonKey() Map<String, ParseException> get failed {
  if (_failed is EqualUnmodifiableMapView) return _failed;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_failed);
}

@override final  DocumentErrors? errors;

/// Create a copy of TicketDocument
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TicketDocumentCopyWith<_TicketDocument> get copyWith => __$TicketDocumentCopyWithImpl<_TicketDocument>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TicketDocument&&(identical(other.ticket, ticket) || other.ticket == ticket)&&const DeepCollectionEquality().equals(other.failed, _failed)&&(identical(other.errors, errors) || other.errors == errors));
}


@override
int get hashCode {
    return Object.hash(runtimeType,ticket,const DeepCollectionEquality().hash(_failed),errors);
}

@override
String toString() {
    return 'TicketDocument(ticket: $ticket, failed: $failed, errors: $errors)';
}


}

/// @nodoc
abstract mixin class _$TicketDocumentCopyWith<$Res> implements $TicketDocumentCopyWith<$Res> {
  factory _$TicketDocumentCopyWith(_TicketDocument value, $Res Function(_TicketDocument) _then) = __$TicketDocumentCopyWithImpl;
@override @useResult
$Res call({
 TicketForm ticket, Map<String, ParseException> failed, DocumentErrors? errors
});


@override $TicketFormCopyWith<$Res> get ticket;

}
/// @nodoc
class __$TicketDocumentCopyWithImpl<$Res>
    implements _$TicketDocumentCopyWith<$Res> {
  __$TicketDocumentCopyWithImpl(this._self, this._then);

  final _TicketDocument _self;
  final $Res Function(_TicketDocument) _then;

/// Create a copy of TicketDocument
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ticket = null,Object? failed = null,Object? errors = freezed,}) {
  return _then(_TicketDocument(
ticket: null == ticket ? _self.ticket : ticket // ignore: cast_nullable_to_non_nullable
as TicketForm,failed: null == failed ? _self._failed : failed // ignore: cast_nullable_to_non_nullable
as Map<String, ParseException>,errors: freezed == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as DocumentErrors?,
  ));
}

/// Create a copy of TicketDocument
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TicketFormCopyWith<$Res> get ticket {
  
  return $TicketFormCopyWith<$Res>(_self.ticket, (value) {
    return _then(_self.copyWith(ticket: value));
  });
}
}

// dart format on
