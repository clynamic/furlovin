// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'form_option.rules.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FormOption {

 String get value; String? get group; String? get label;/// Marks the prompt option, such as --Select an Option--, which the site
/// lists first.
 bool? get placeholder; bool? get selected; Map<String, ParseException> get failed;
/// Create a copy of FormOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FormOptionCopyWith<FormOption> get copyWith => _$FormOptionCopyWithImpl<FormOption>(this as FormOption, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FormOption;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FormOption&&(identical(other.value, _this.value) || other.value == _this.value)&&(identical(other.group, _this.group) || other.group == _this.group)&&(identical(other.label, _this.label) || other.label == _this.label)&&(identical(other.placeholder, _this.placeholder) || other.placeholder == _this.placeholder)&&(identical(other.selected, _this.selected) || other.selected == _this.selected)&&const DeepCollectionEquality().equals(other.failed, _this.failed));
}


@override
int get hashCode {
  final _this = this as FormOption;
  return Object.hash(runtimeType,_this.value,_this.group,_this.label,_this.placeholder,_this.selected,const DeepCollectionEquality().hash(_this.failed));
}

@override
String toString() {
  final _this = this as FormOption;
  return 'FormOption(value: ${_this.value}, group: ${_this.group}, label: ${_this.label}, placeholder: ${_this.placeholder}, selected: ${_this.selected}, failed: ${_this.failed})';
}


}

/// @nodoc
abstract mixin class $FormOptionCopyWith<$Res>  {
  factory $FormOptionCopyWith(FormOption value, $Res Function(FormOption) _then) = _$FormOptionCopyWithImpl;
@useResult
$Res call({
 String value, String? group, String? label, bool? placeholder, bool? selected, Map<String, ParseException> failed
});




}
/// @nodoc
class _$FormOptionCopyWithImpl<$Res>
    implements $FormOptionCopyWith<$Res> {
  _$FormOptionCopyWithImpl(this._self, this._then);

  final FormOption _self;
  final $Res Function(FormOption) _then;

/// Create a copy of FormOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? value = null,Object? group = freezed,Object? label = freezed,Object? placeholder = freezed,Object? selected = freezed,Object? failed = null,}) {
  return _then(FormOption(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,group: freezed == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,placeholder: freezed == placeholder ? _self.placeholder : placeholder // ignore: cast_nullable_to_non_nullable
as bool?,selected: freezed == selected ? _self.selected : selected // ignore: cast_nullable_to_non_nullable
as bool?,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as Map<String, ParseException>,
  ));
}

}


/// Adds pattern-matching-related methods to [FormOption].
extension FormOptionPatterns on FormOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FormOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FormOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FormOption value)  $default,){
final _that = this;
switch (_that) {
case _FormOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FormOption value)?  $default,){
final _that = this;
switch (_that) {
case _FormOption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String value,  String? group,  String? label,  bool? placeholder,  bool? selected,  Map<String, ParseException> failed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FormOption() when $default != null:
return $default(_that.value,_that.group,_that.label,_that.placeholder,_that.selected,_that.failed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String value,  String? group,  String? label,  bool? placeholder,  bool? selected,  Map<String, ParseException> failed)  $default,) {final _that = this;
switch (_that) {
case _FormOption():
return $default(_that.value,_that.group,_that.label,_that.placeholder,_that.selected,_that.failed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String value,  String? group,  String? label,  bool? placeholder,  bool? selected,  Map<String, ParseException> failed)?  $default,) {final _that = this;
switch (_that) {
case _FormOption() when $default != null:
return $default(_that.value,_that.group,_that.label,_that.placeholder,_that.selected,_that.failed);case _:
  return null;

}
}

}

/// @nodoc


class _FormOption extends FormOption {
  const _FormOption({required this.value, this.group, this.label, this.placeholder, this.selected,  Map<String, ParseException> failed = const {}}): _failed = failed,super._();
  

@override final  String value;
@override final  String? group;
@override final  String? label;
/// Marks the prompt option, such as --Select an Option--, which the site
/// lists first.
@override final  bool? placeholder;
@override final  bool? selected;
 final  Map<String, ParseException> _failed;
@override@JsonKey() Map<String, ParseException> get failed {
  if (_failed is EqualUnmodifiableMapView) return _failed;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_failed);
}


/// Create a copy of FormOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FormOptionCopyWith<_FormOption> get copyWith => __$FormOptionCopyWithImpl<_FormOption>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FormOption&&(identical(other.value, value) || other.value == value)&&(identical(other.group, group) || other.group == group)&&(identical(other.label, label) || other.label == label)&&(identical(other.placeholder, placeholder) || other.placeholder == placeholder)&&(identical(other.selected, selected) || other.selected == selected)&&const DeepCollectionEquality().equals(other.failed, _failed));
}


@override
int get hashCode {
    return Object.hash(runtimeType,value,group,label,placeholder,selected,const DeepCollectionEquality().hash(_failed));
}

@override
String toString() {
    return 'FormOption(value: $value, group: $group, label: $label, placeholder: $placeholder, selected: $selected, failed: $failed)';
}


}

/// @nodoc
abstract mixin class _$FormOptionCopyWith<$Res> implements $FormOptionCopyWith<$Res> {
  factory _$FormOptionCopyWith(_FormOption value, $Res Function(_FormOption) _then) = __$FormOptionCopyWithImpl;
@override @useResult
$Res call({
 String value, String? group, String? label, bool? placeholder, bool? selected, Map<String, ParseException> failed
});




}
/// @nodoc
class __$FormOptionCopyWithImpl<$Res>
    implements _$FormOptionCopyWith<$Res> {
  __$FormOptionCopyWithImpl(this._self, this._then);

  final _FormOption _self;
  final $Res Function(_FormOption) _then;

/// Create a copy of FormOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? value = null,Object? group = freezed,Object? label = freezed,Object? placeholder = freezed,Object? selected = freezed,Object? failed = null,}) {
  return _then(_FormOption(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,group: freezed == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,placeholder: freezed == placeholder ? _self.placeholder : placeholder // ignore: cast_nullable_to_non_nullable
as bool?,selected: freezed == selected ? _self.selected : selected // ignore: cast_nullable_to_non_nullable
as bool?,failed: null == failed ? _self._failed : failed // ignore: cast_nullable_to_non_nullable
as Map<String, ParseException>,
  ));
}


}

// dart format on
