// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ticket_form.rules.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TicketForm {

 String get action; FormControl get details; FormControl get issue; List<FormControl> get controls; FormControl? get shareNotes; FormControl? get subject; Map<String, ParseException> get failed;
/// Create a copy of TicketForm
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketFormCopyWith<TicketForm> get copyWith => _$TicketFormCopyWithImpl<TicketForm>(this as TicketForm, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TicketForm;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketForm&&(identical(other.action, _this.action) || other.action == _this.action)&&(identical(other.details, _this.details) || other.details == _this.details)&&(identical(other.issue, _this.issue) || other.issue == _this.issue)&&const DeepCollectionEquality().equals(other.controls, _this.controls)&&(identical(other.shareNotes, _this.shareNotes) || other.shareNotes == _this.shareNotes)&&(identical(other.subject, _this.subject) || other.subject == _this.subject)&&const DeepCollectionEquality().equals(other.failed, _this.failed));
}


@override
int get hashCode {
  final _this = this as TicketForm;
  return Object.hash(runtimeType,_this.action,_this.details,_this.issue,const DeepCollectionEquality().hash(_this.controls),_this.shareNotes,_this.subject,const DeepCollectionEquality().hash(_this.failed));
}

@override
String toString() {
  final _this = this as TicketForm;
  return 'TicketForm(action: ${_this.action}, details: ${_this.details}, issue: ${_this.issue}, controls: ${_this.controls}, shareNotes: ${_this.shareNotes}, subject: ${_this.subject}, failed: ${_this.failed})';
}


}

/// @nodoc
abstract mixin class $TicketFormCopyWith<$Res>  {
  factory $TicketFormCopyWith(TicketForm value, $Res Function(TicketForm) _then) = _$TicketFormCopyWithImpl;
@useResult
$Res call({
 String action, FormControl details, FormControl issue, List<FormControl> controls, FormControl? shareNotes, FormControl? subject, Map<String, ParseException> failed
});


$FormControlCopyWith<$Res> get details;$FormControlCopyWith<$Res> get issue;$FormControlCopyWith<$Res>? get shareNotes;$FormControlCopyWith<$Res>? get subject;

}
/// @nodoc
class _$TicketFormCopyWithImpl<$Res>
    implements $TicketFormCopyWith<$Res> {
  _$TicketFormCopyWithImpl(this._self, this._then);

  final TicketForm _self;
  final $Res Function(TicketForm) _then;

/// Create a copy of TicketForm
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? action = null,Object? details = null,Object? issue = null,Object? controls = null,Object? shareNotes = freezed,Object? subject = freezed,Object? failed = null,}) {
  return _then(TicketForm(
action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,details: null == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as FormControl,issue: null == issue ? _self.issue : issue // ignore: cast_nullable_to_non_nullable
as FormControl,controls: null == controls ? _self.controls : controls // ignore: cast_nullable_to_non_nullable
as List<FormControl>,shareNotes: freezed == shareNotes ? _self.shareNotes : shareNotes // ignore: cast_nullable_to_non_nullable
as FormControl?,subject: freezed == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as FormControl?,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as Map<String, ParseException>,
  ));
}
/// Create a copy of TicketForm
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FormControlCopyWith<$Res> get details {
  
  return $FormControlCopyWith<$Res>(_self.details, (value) {
    return _then(_self.copyWith(details: value));
  });
}/// Create a copy of TicketForm
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FormControlCopyWith<$Res> get issue {
  
  return $FormControlCopyWith<$Res>(_self.issue, (value) {
    return _then(_self.copyWith(issue: value));
  });
}/// Create a copy of TicketForm
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FormControlCopyWith<$Res>? get shareNotes {
    if (_self.shareNotes == null) {
    return null;
  }

  return $FormControlCopyWith<$Res>(_self.shareNotes!, (value) {
    return _then(_self.copyWith(shareNotes: value));
  });
}/// Create a copy of TicketForm
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FormControlCopyWith<$Res>? get subject {
    if (_self.subject == null) {
    return null;
  }

  return $FormControlCopyWith<$Res>(_self.subject!, (value) {
    return _then(_self.copyWith(subject: value));
  });
}
}


/// Adds pattern-matching-related methods to [TicketForm].
extension TicketFormPatterns on TicketForm {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TicketForm value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TicketForm() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TicketForm value)  $default,){
final _that = this;
switch (_that) {
case _TicketForm():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TicketForm value)?  $default,){
final _that = this;
switch (_that) {
case _TicketForm() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String action,  FormControl details,  FormControl issue,  List<FormControl> controls,  FormControl? shareNotes,  FormControl? subject,  Map<String, ParseException> failed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TicketForm() when $default != null:
return $default(_that.action,_that.details,_that.issue,_that.controls,_that.shareNotes,_that.subject,_that.failed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String action,  FormControl details,  FormControl issue,  List<FormControl> controls,  FormControl? shareNotes,  FormControl? subject,  Map<String, ParseException> failed)  $default,) {final _that = this;
switch (_that) {
case _TicketForm():
return $default(_that.action,_that.details,_that.issue,_that.controls,_that.shareNotes,_that.subject,_that.failed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String action,  FormControl details,  FormControl issue,  List<FormControl> controls,  FormControl? shareNotes,  FormControl? subject,  Map<String, ParseException> failed)?  $default,) {final _that = this;
switch (_that) {
case _TicketForm() when $default != null:
return $default(_that.action,_that.details,_that.issue,_that.controls,_that.shareNotes,_that.subject,_that.failed);case _:
  return null;

}
}

}

/// @nodoc


class _TicketForm extends TicketForm {
  const _TicketForm({required this.action, required this.details, required this.issue,  List<FormControl> controls = const [], this.shareNotes, this.subject,  Map<String, ParseException> failed = const {}}): _controls = controls,_failed = failed,super._();
  

@override final  String action;
@override final  FormControl details;
@override final  FormControl issue;
 final  List<FormControl> _controls;
@override@JsonKey() List<FormControl> get controls {
  if (_controls is EqualUnmodifiableListView) return _controls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_controls);
}

@override final  FormControl? shareNotes;
@override final  FormControl? subject;
 final  Map<String, ParseException> _failed;
@override@JsonKey() Map<String, ParseException> get failed {
  if (_failed is EqualUnmodifiableMapView) return _failed;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_failed);
}


/// Create a copy of TicketForm
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TicketFormCopyWith<_TicketForm> get copyWith => __$TicketFormCopyWithImpl<_TicketForm>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TicketForm&&(identical(other.action, action) || other.action == action)&&(identical(other.details, details) || other.details == details)&&(identical(other.issue, issue) || other.issue == issue)&&const DeepCollectionEquality().equals(other.controls, _controls)&&(identical(other.shareNotes, shareNotes) || other.shareNotes == shareNotes)&&(identical(other.subject, subject) || other.subject == subject)&&const DeepCollectionEquality().equals(other.failed, _failed));
}


@override
int get hashCode {
    return Object.hash(runtimeType,action,details,issue,const DeepCollectionEquality().hash(_controls),shareNotes,subject,const DeepCollectionEquality().hash(_failed));
}

@override
String toString() {
    return 'TicketForm(action: $action, details: $details, issue: $issue, controls: $controls, shareNotes: $shareNotes, subject: $subject, failed: $failed)';
}


}

/// @nodoc
abstract mixin class _$TicketFormCopyWith<$Res> implements $TicketFormCopyWith<$Res> {
  factory _$TicketFormCopyWith(_TicketForm value, $Res Function(_TicketForm) _then) = __$TicketFormCopyWithImpl;
@override @useResult
$Res call({
 String action, FormControl details, FormControl issue, List<FormControl> controls, FormControl? shareNotes, FormControl? subject, Map<String, ParseException> failed
});


@override $FormControlCopyWith<$Res> get details;@override $FormControlCopyWith<$Res> get issue;@override $FormControlCopyWith<$Res>? get shareNotes;@override $FormControlCopyWith<$Res>? get subject;

}
/// @nodoc
class __$TicketFormCopyWithImpl<$Res>
    implements _$TicketFormCopyWith<$Res> {
  __$TicketFormCopyWithImpl(this._self, this._then);

  final _TicketForm _self;
  final $Res Function(_TicketForm) _then;

/// Create a copy of TicketForm
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? action = null,Object? details = null,Object? issue = null,Object? controls = null,Object? shareNotes = freezed,Object? subject = freezed,Object? failed = null,}) {
  return _then(_TicketForm(
action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,details: null == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as FormControl,issue: null == issue ? _self.issue : issue // ignore: cast_nullable_to_non_nullable
as FormControl,controls: null == controls ? _self._controls : controls // ignore: cast_nullable_to_non_nullable
as List<FormControl>,shareNotes: freezed == shareNotes ? _self.shareNotes : shareNotes // ignore: cast_nullable_to_non_nullable
as FormControl?,subject: freezed == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as FormControl?,failed: null == failed ? _self._failed : failed // ignore: cast_nullable_to_non_nullable
as Map<String, ParseException>,
  ));
}

/// Create a copy of TicketForm
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FormControlCopyWith<$Res> get details {
  
  return $FormControlCopyWith<$Res>(_self.details, (value) {
    return _then(_self.copyWith(details: value));
  });
}/// Create a copy of TicketForm
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FormControlCopyWith<$Res> get issue {
  
  return $FormControlCopyWith<$Res>(_self.issue, (value) {
    return _then(_self.copyWith(issue: value));
  });
}/// Create a copy of TicketForm
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FormControlCopyWith<$Res>? get shareNotes {
    if (_self.shareNotes == null) {
    return null;
  }

  return $FormControlCopyWith<$Res>(_self.shareNotes!, (value) {
    return _then(_self.copyWith(shareNotes: value));
  });
}/// Create a copy of TicketForm
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FormControlCopyWith<$Res>? get subject {
    if (_self.subject == null) {
    return null;
  }

  return $FormControlCopyWith<$Res>(_self.subject!, (value) {
    return _then(_self.copyWith(subject: value));
  });
}
}

// dart format on
