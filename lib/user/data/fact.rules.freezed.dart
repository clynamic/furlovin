// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fact.rules.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Fact {

/// The question, as the site words it.
 String get label;/// The answer the member gave.
 String get value;/// Which block of questions the row sits in. The site separates the
/// availability answers from the rest and renders the rest smaller.
 String? get group; Map<String, String> get failed;
/// Create a copy of Fact
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FactCopyWith<Fact> get copyWith => _$FactCopyWithImpl<Fact>(this as Fact, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Fact;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Fact&&(identical(other.label, _this.label) || other.label == _this.label)&&(identical(other.value, _this.value) || other.value == _this.value)&&(identical(other.group, _this.group) || other.group == _this.group)&&const DeepCollectionEquality().equals(other.failed, _this.failed));
}


@override
int get hashCode {
  final _this = this as Fact;
  return Object.hash(runtimeType,_this.label,_this.value,_this.group,const DeepCollectionEquality().hash(_this.failed));
}

@override
String toString() {
  final _this = this as Fact;
  return 'Fact(label: ${_this.label}, value: ${_this.value}, group: ${_this.group}, failed: ${_this.failed})';
}


}

/// @nodoc
abstract mixin class $FactCopyWith<$Res>  {
  factory $FactCopyWith(Fact value, $Res Function(Fact) _then) = _$FactCopyWithImpl;
@useResult
$Res call({
 String label, String value, String? group, Map<String, String> failed
});




}
/// @nodoc
class _$FactCopyWithImpl<$Res>
    implements $FactCopyWith<$Res> {
  _$FactCopyWithImpl(this._self, this._then);

  final Fact _self;
  final $Res Function(Fact) _then;

/// Create a copy of Fact
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? value = null,Object? group = freezed,Object? failed = null,}) {
  return _then(Fact(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,group: freezed == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String?,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [Fact].
extension FactPatterns on Fact {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Fact value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Fact() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Fact value)  $default,){
final _that = this;
switch (_that) {
case _Fact():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Fact value)?  $default,){
final _that = this;
switch (_that) {
case _Fact() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  String value,  String? group,  Map<String, String> failed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Fact() when $default != null:
return $default(_that.label,_that.value,_that.group,_that.failed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  String value,  String? group,  Map<String, String> failed)  $default,) {final _that = this;
switch (_that) {
case _Fact():
return $default(_that.label,_that.value,_that.group,_that.failed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  String value,  String? group,  Map<String, String> failed)?  $default,) {final _that = this;
switch (_that) {
case _Fact() when $default != null:
return $default(_that.label,_that.value,_that.group,_that.failed);case _:
  return null;

}
}

}

/// @nodoc


class _Fact extends Fact {
  const _Fact({required this.label, required this.value, this.group,  Map<String, String> failed = const {}}): _failed = failed,super._();
  

/// The question, as the site words it.
@override final  String label;
/// The answer the member gave.
@override final  String value;
/// Which block of questions the row sits in. The site separates the
/// availability answers from the rest and renders the rest smaller.
@override final  String? group;
 final  Map<String, String> _failed;
@override@JsonKey() Map<String, String> get failed {
  if (_failed is EqualUnmodifiableMapView) return _failed;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_failed);
}


/// Create a copy of Fact
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FactCopyWith<_Fact> get copyWith => __$FactCopyWithImpl<_Fact>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Fact&&(identical(other.label, label) || other.label == label)&&(identical(other.value, value) || other.value == value)&&(identical(other.group, group) || other.group == group)&&const DeepCollectionEquality().equals(other.failed, _failed));
}


@override
int get hashCode {
    return Object.hash(runtimeType,label,value,group,const DeepCollectionEquality().hash(_failed));
}

@override
String toString() {
    return 'Fact(label: $label, value: $value, group: $group, failed: $failed)';
}


}

/// @nodoc
abstract mixin class _$FactCopyWith<$Res> implements $FactCopyWith<$Res> {
  factory _$FactCopyWith(_Fact value, $Res Function(_Fact) _then) = __$FactCopyWithImpl;
@override @useResult
$Res call({
 String label, String value, String? group, Map<String, String> failed
});




}
/// @nodoc
class __$FactCopyWithImpl<$Res>
    implements _$FactCopyWith<$Res> {
  __$FactCopyWithImpl(this._self, this._then);

  final _Fact _self;
  final $Res Function(_Fact) _then;

/// Create a copy of Fact
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? value = null,Object? group = freezed,Object? failed = null,}) {
  return _then(_Fact(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,group: freezed == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String?,failed: null == failed ? _self._failed : failed // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

// dart format on
