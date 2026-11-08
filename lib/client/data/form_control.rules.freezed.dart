// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'form_control.rules.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FormControl {

 String get name; bool? get checked; bool? get disabled; String? get label; int? get maxLength; int? get minLength; List<FormOption> get options; bool? get required; String? get type;/// The value a browser submits for the control. A select submits its
/// selected option, or its first when none is selected. A textarea
/// submits its text.
 String? get value; Map<String, ParseException> get failed;
/// Create a copy of FormControl
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FormControlCopyWith<FormControl> get copyWith => _$FormControlCopyWithImpl<FormControl>(this as FormControl, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FormControl;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FormControl&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.checked, _this.checked) || other.checked == _this.checked)&&(identical(other.disabled, _this.disabled) || other.disabled == _this.disabled)&&(identical(other.label, _this.label) || other.label == _this.label)&&(identical(other.maxLength, _this.maxLength) || other.maxLength == _this.maxLength)&&(identical(other.minLength, _this.minLength) || other.minLength == _this.minLength)&&const DeepCollectionEquality().equals(other.options, _this.options)&&(identical(other.required, _this.required) || other.required == _this.required)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.value, _this.value) || other.value == _this.value)&&const DeepCollectionEquality().equals(other.failed, _this.failed));
}


@override
int get hashCode {
  final _this = this as FormControl;
  return Object.hash(runtimeType,_this.name,_this.checked,_this.disabled,_this.label,_this.maxLength,_this.minLength,const DeepCollectionEquality().hash(_this.options),_this.required,_this.type,_this.value,const DeepCollectionEquality().hash(_this.failed));
}

@override
String toString() {
  final _this = this as FormControl;
  return 'FormControl(name: ${_this.name}, checked: ${_this.checked}, disabled: ${_this.disabled}, label: ${_this.label}, maxLength: ${_this.maxLength}, minLength: ${_this.minLength}, options: ${_this.options}, required: ${_this.required}, type: ${_this.type}, value: ${_this.value}, failed: ${_this.failed})';
}


}

/// @nodoc
abstract mixin class $FormControlCopyWith<$Res>  {
  factory $FormControlCopyWith(FormControl value, $Res Function(FormControl) _then) = _$FormControlCopyWithImpl;
@useResult
$Res call({
 String name, bool? checked, bool? disabled, String? label, int? maxLength, int? minLength, List<FormOption> options, bool? required, String? type, String? value, Map<String, ParseException> failed
});




}
/// @nodoc
class _$FormControlCopyWithImpl<$Res>
    implements $FormControlCopyWith<$Res> {
  _$FormControlCopyWithImpl(this._self, this._then);

  final FormControl _self;
  final $Res Function(FormControl) _then;

/// Create a copy of FormControl
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? checked = freezed,Object? disabled = freezed,Object? label = freezed,Object? maxLength = freezed,Object? minLength = freezed,Object? options = null,Object? required = freezed,Object? type = freezed,Object? value = freezed,Object? failed = null,}) {
  return _then(FormControl(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,checked: freezed == checked ? _self.checked : checked // ignore: cast_nullable_to_non_nullable
as bool?,disabled: freezed == disabled ? _self.disabled : disabled // ignore: cast_nullable_to_non_nullable
as bool?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,maxLength: freezed == maxLength ? _self.maxLength : maxLength // ignore: cast_nullable_to_non_nullable
as int?,minLength: freezed == minLength ? _self.minLength : minLength // ignore: cast_nullable_to_non_nullable
as int?,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<FormOption>,required: freezed == required ? _self.required : required // ignore: cast_nullable_to_non_nullable
as bool?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as Map<String, ParseException>,
  ));
}

}


/// Adds pattern-matching-related methods to [FormControl].
extension FormControlPatterns on FormControl {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FormControl value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FormControl() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FormControl value)  $default,){
final _that = this;
switch (_that) {
case _FormControl():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FormControl value)?  $default,){
final _that = this;
switch (_that) {
case _FormControl() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  bool? checked,  bool? disabled,  String? label,  int? maxLength,  int? minLength,  List<FormOption> options,  bool? required,  String? type,  String? value,  Map<String, ParseException> failed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FormControl() when $default != null:
return $default(_that.name,_that.checked,_that.disabled,_that.label,_that.maxLength,_that.minLength,_that.options,_that.required,_that.type,_that.value,_that.failed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  bool? checked,  bool? disabled,  String? label,  int? maxLength,  int? minLength,  List<FormOption> options,  bool? required,  String? type,  String? value,  Map<String, ParseException> failed)  $default,) {final _that = this;
switch (_that) {
case _FormControl():
return $default(_that.name,_that.checked,_that.disabled,_that.label,_that.maxLength,_that.minLength,_that.options,_that.required,_that.type,_that.value,_that.failed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  bool? checked,  bool? disabled,  String? label,  int? maxLength,  int? minLength,  List<FormOption> options,  bool? required,  String? type,  String? value,  Map<String, ParseException> failed)?  $default,) {final _that = this;
switch (_that) {
case _FormControl() when $default != null:
return $default(_that.name,_that.checked,_that.disabled,_that.label,_that.maxLength,_that.minLength,_that.options,_that.required,_that.type,_that.value,_that.failed);case _:
  return null;

}
}

}

/// @nodoc


class _FormControl extends FormControl {
  const _FormControl({required this.name, this.checked, this.disabled, this.label, this.maxLength, this.minLength,  List<FormOption> options = const [], this.required, this.type, this.value,  Map<String, ParseException> failed = const {}}): _options = options,_failed = failed,super._();
  

@override final  String name;
@override final  bool? checked;
@override final  bool? disabled;
@override final  String? label;
@override final  int? maxLength;
@override final  int? minLength;
 final  List<FormOption> _options;
@override@JsonKey() List<FormOption> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}

@override final  bool? required;
@override final  String? type;
/// The value a browser submits for the control. A select submits its
/// selected option, or its first when none is selected. A textarea
/// submits its text.
@override final  String? value;
 final  Map<String, ParseException> _failed;
@override@JsonKey() Map<String, ParseException> get failed {
  if (_failed is EqualUnmodifiableMapView) return _failed;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_failed);
}


/// Create a copy of FormControl
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FormControlCopyWith<_FormControl> get copyWith => __$FormControlCopyWithImpl<_FormControl>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FormControl&&(identical(other.name, name) || other.name == name)&&(identical(other.checked, checked) || other.checked == checked)&&(identical(other.disabled, disabled) || other.disabled == disabled)&&(identical(other.label, label) || other.label == label)&&(identical(other.maxLength, maxLength) || other.maxLength == maxLength)&&(identical(other.minLength, minLength) || other.minLength == minLength)&&const DeepCollectionEquality().equals(other.options, _options)&&(identical(other.required, required) || other.required == required)&&(identical(other.type, type) || other.type == type)&&(identical(other.value, value) || other.value == value)&&const DeepCollectionEquality().equals(other.failed, _failed));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name,checked,disabled,label,maxLength,minLength,const DeepCollectionEquality().hash(_options),required,type,value,const DeepCollectionEquality().hash(_failed));
}

@override
String toString() {
    return 'FormControl(name: $name, checked: $checked, disabled: $disabled, label: $label, maxLength: $maxLength, minLength: $minLength, options: $options, required: $required, type: $type, value: $value, failed: $failed)';
}


}

/// @nodoc
abstract mixin class _$FormControlCopyWith<$Res> implements $FormControlCopyWith<$Res> {
  factory _$FormControlCopyWith(_FormControl value, $Res Function(_FormControl) _then) = __$FormControlCopyWithImpl;
@override @useResult
$Res call({
 String name, bool? checked, bool? disabled, String? label, int? maxLength, int? minLength, List<FormOption> options, bool? required, String? type, String? value, Map<String, ParseException> failed
});




}
/// @nodoc
class __$FormControlCopyWithImpl<$Res>
    implements _$FormControlCopyWith<$Res> {
  __$FormControlCopyWithImpl(this._self, this._then);

  final _FormControl _self;
  final $Res Function(_FormControl) _then;

/// Create a copy of FormControl
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? checked = freezed,Object? disabled = freezed,Object? label = freezed,Object? maxLength = freezed,Object? minLength = freezed,Object? options = null,Object? required = freezed,Object? type = freezed,Object? value = freezed,Object? failed = null,}) {
  return _then(_FormControl(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,checked: freezed == checked ? _self.checked : checked // ignore: cast_nullable_to_non_nullable
as bool?,disabled: freezed == disabled ? _self.disabled : disabled // ignore: cast_nullable_to_non_nullable
as bool?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,maxLength: freezed == maxLength ? _self.maxLength : maxLength // ignore: cast_nullable_to_non_nullable
as int?,minLength: freezed == minLength ? _self.minLength : minLength // ignore: cast_nullable_to_non_nullable
as int?,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<FormOption>,required: freezed == required ? _self.required : required // ignore: cast_nullable_to_non_nullable
as bool?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,failed: null == failed ? _self._failed : failed // ignore: cast_nullable_to_non_nullable
as Map<String, ParseException>,
  ));
}


}

// dart format on
