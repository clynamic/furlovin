// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'folder_row.rules.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FolderRow {

 String get name; int? get count; String? get group; int? get id; String? get slug; String? get user; Map<String, ParseException> get failed;
/// Create a copy of FolderRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FolderRowCopyWith<FolderRow> get copyWith => _$FolderRowCopyWithImpl<FolderRow>(this as FolderRow, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FolderRow;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FolderRow&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.count, _this.count) || other.count == _this.count)&&(identical(other.group, _this.group) || other.group == _this.group)&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&(identical(other.user, _this.user) || other.user == _this.user)&&const DeepCollectionEquality().equals(other.failed, _this.failed));
}


@override
int get hashCode {
  final _this = this as FolderRow;
  return Object.hash(runtimeType,_this.name,_this.count,_this.group,_this.id,_this.slug,_this.user,const DeepCollectionEquality().hash(_this.failed));
}

@override
String toString() {
  final _this = this as FolderRow;
  return 'FolderRow(name: ${_this.name}, count: ${_this.count}, group: ${_this.group}, id: ${_this.id}, slug: ${_this.slug}, user: ${_this.user}, failed: ${_this.failed})';
}


}

/// @nodoc
abstract mixin class $FolderRowCopyWith<$Res>  {
  factory $FolderRowCopyWith(FolderRow value, $Res Function(FolderRow) _then) = _$FolderRowCopyWithImpl;
@useResult
$Res call({
 String name, int? count, String? group, int? id, String? slug, String? user, Map<String, ParseException> failed
});




}
/// @nodoc
class _$FolderRowCopyWithImpl<$Res>
    implements $FolderRowCopyWith<$Res> {
  _$FolderRowCopyWithImpl(this._self, this._then);

  final FolderRow _self;
  final $Res Function(FolderRow) _then;

/// Create a copy of FolderRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? count = freezed,Object? group = freezed,Object? id = freezed,Object? slug = freezed,Object? user = freezed,Object? failed = null,}) {
  return _then(FolderRow(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,group: freezed == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String?,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as String?,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as Map<String, ParseException>,
  ));
}

}


/// Adds pattern-matching-related methods to [FolderRow].
extension FolderRowPatterns on FolderRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FolderRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FolderRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FolderRow value)  $default,){
final _that = this;
switch (_that) {
case _FolderRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FolderRow value)?  $default,){
final _that = this;
switch (_that) {
case _FolderRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  int? count,  String? group,  int? id,  String? slug,  String? user,  Map<String, ParseException> failed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FolderRow() when $default != null:
return $default(_that.name,_that.count,_that.group,_that.id,_that.slug,_that.user,_that.failed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  int? count,  String? group,  int? id,  String? slug,  String? user,  Map<String, ParseException> failed)  $default,) {final _that = this;
switch (_that) {
case _FolderRow():
return $default(_that.name,_that.count,_that.group,_that.id,_that.slug,_that.user,_that.failed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  int? count,  String? group,  int? id,  String? slug,  String? user,  Map<String, ParseException> failed)?  $default,) {final _that = this;
switch (_that) {
case _FolderRow() when $default != null:
return $default(_that.name,_that.count,_that.group,_that.id,_that.slug,_that.user,_that.failed);case _:
  return null;

}
}

}

/// @nodoc


class _FolderRow extends FolderRow {
  const _FolderRow({required this.name, this.count, this.group, this.id, this.slug, this.user,  Map<String, ParseException> failed = const {}}): _failed = failed,super._();
  

@override final  String name;
@override final  int? count;
@override final  String? group;
@override final  int? id;
@override final  String? slug;
@override final  String? user;
 final  Map<String, ParseException> _failed;
@override@JsonKey() Map<String, ParseException> get failed {
  if (_failed is EqualUnmodifiableMapView) return _failed;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_failed);
}


/// Create a copy of FolderRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FolderRowCopyWith<_FolderRow> get copyWith => __$FolderRowCopyWithImpl<_FolderRow>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FolderRow&&(identical(other.name, name) || other.name == name)&&(identical(other.count, count) || other.count == count)&&(identical(other.group, group) || other.group == group)&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.user, user) || other.user == user)&&const DeepCollectionEquality().equals(other.failed, _failed));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name,count,group,id,slug,user,const DeepCollectionEquality().hash(_failed));
}

@override
String toString() {
    return 'FolderRow(name: $name, count: $count, group: $group, id: $id, slug: $slug, user: $user, failed: $failed)';
}


}

/// @nodoc
abstract mixin class _$FolderRowCopyWith<$Res> implements $FolderRowCopyWith<$Res> {
  factory _$FolderRowCopyWith(_FolderRow value, $Res Function(_FolderRow) _then) = __$FolderRowCopyWithImpl;
@override @useResult
$Res call({
 String name, int? count, String? group, int? id, String? slug, String? user, Map<String, ParseException> failed
});




}
/// @nodoc
class __$FolderRowCopyWithImpl<$Res>
    implements _$FolderRowCopyWith<$Res> {
  __$FolderRowCopyWithImpl(this._self, this._then);

  final _FolderRow _self;
  final $Res Function(_FolderRow) _then;

/// Create a copy of FolderRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? count = freezed,Object? group = freezed,Object? id = freezed,Object? slug = freezed,Object? user = freezed,Object? failed = null,}) {
  return _then(_FolderRow(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,group: freezed == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String?,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as String?,failed: null == failed ? _self._failed : failed // ignore: cast_nullable_to_non_nullable
as Map<String, ParseException>,
  ));
}


}

// dart format on
