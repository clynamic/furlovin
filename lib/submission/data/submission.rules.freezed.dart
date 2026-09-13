// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'submission.rules.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Submission {

/// Absolute url of the submitted file at full resolution.
 String get file;/// The submission's numeric identifier.
 int get id;/// The submission's content rating.
 SubmissionRating get rating;/// The submission's title, free of the padding the page markup adds.
 String get title;/// The url form of the name of whoever posted the submission,
/// lowercased and with underscores removed.
 String get uploader;/// The kind of work, as the uploader filed it.
 String? get category;/// How many comments the submission carries.
 int? get comments;/// The rendered description, as markup rather than text.
 String? get description;/// The file's extension, without a leading dot.
 String? get extension;/// How many people have favourited the submission.
 int? get favorites;/// Absolute url that adds or removes the submission from your
/// favourites. The site only writes one of the two, so which it is
/// says whether you have favourited it already. Absent when signed
/// out.
 String? get favouriteLink;/// Absent when signed out.
 bool? get favourited;/// The size of the uploaded file, as FA renders it.
 String? get fileSize;/// Absolute url that opens a new note to whoever posted it. Absent
/// when signed out.
 String? get noteLink;/// When the submission was posted.
 DateTime? get posted;/// Absolute url of a reduced copy of the submitted file.
 String? get preview;/// The image's pixel dimensions, as FA renders them.
 String? get resolution;/// The species the uploader filed the work under.
 String? get species;/// Keywords the uploader attached to the submission.
 List<String>? get tags;/// The subject matter the uploader filed the work under.
 String? get theme;/// The kind of content a submission holds.
 SubmissionType? get type;/// Absolute url of the avatar of whoever posted the submission.
 String? get uploaderAvatar;/// The name of whoever posted the submission, as displayed.
 String? get uploaderName;/// How many times the submission has been viewed.
 int? get views; Map<String, ParseException> get failed;
/// Create a copy of Submission
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubmissionCopyWith<Submission> get copyWith => _$SubmissionCopyWithImpl<Submission>(this as Submission, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Submission;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Submission&&(identical(other.file, _this.file) || other.file == _this.file)&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.rating, _this.rating) || other.rating == _this.rating)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.uploader, _this.uploader) || other.uploader == _this.uploader)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.comments, _this.comments) || other.comments == _this.comments)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.extension, _this.extension) || other.extension == _this.extension)&&(identical(other.favorites, _this.favorites) || other.favorites == _this.favorites)&&(identical(other.favouriteLink, _this.favouriteLink) || other.favouriteLink == _this.favouriteLink)&&(identical(other.favourited, _this.favourited) || other.favourited == _this.favourited)&&(identical(other.fileSize, _this.fileSize) || other.fileSize == _this.fileSize)&&(identical(other.noteLink, _this.noteLink) || other.noteLink == _this.noteLink)&&(identical(other.posted, _this.posted) || other.posted == _this.posted)&&(identical(other.preview, _this.preview) || other.preview == _this.preview)&&(identical(other.resolution, _this.resolution) || other.resolution == _this.resolution)&&(identical(other.species, _this.species) || other.species == _this.species)&&const DeepCollectionEquality().equals(other.tags, _this.tags)&&(identical(other.theme, _this.theme) || other.theme == _this.theme)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.uploaderAvatar, _this.uploaderAvatar) || other.uploaderAvatar == _this.uploaderAvatar)&&(identical(other.uploaderName, _this.uploaderName) || other.uploaderName == _this.uploaderName)&&(identical(other.views, _this.views) || other.views == _this.views)&&const DeepCollectionEquality().equals(other.failed, _this.failed));
}


@override
int get hashCode {
  final _this = this as Submission;
  return Object.hashAll([runtimeType,_this.file,_this.id,_this.rating,_this.title,_this.uploader,_this.category,_this.comments,_this.description,_this.extension,_this.favorites,_this.favouriteLink,_this.favourited,_this.fileSize,_this.noteLink,_this.posted,_this.preview,_this.resolution,_this.species,const DeepCollectionEquality().hash(_this.tags),_this.theme,_this.type,_this.uploaderAvatar,_this.uploaderName,_this.views,const DeepCollectionEquality().hash(_this.failed)]);
}

@override
String toString() {
  final _this = this as Submission;
  return 'Submission(file: ${_this.file}, id: ${_this.id}, rating: ${_this.rating}, title: ${_this.title}, uploader: ${_this.uploader}, category: ${_this.category}, comments: ${_this.comments}, description: ${_this.description}, extension: ${_this.extension}, favorites: ${_this.favorites}, favouriteLink: ${_this.favouriteLink}, favourited: ${_this.favourited}, fileSize: ${_this.fileSize}, noteLink: ${_this.noteLink}, posted: ${_this.posted}, preview: ${_this.preview}, resolution: ${_this.resolution}, species: ${_this.species}, tags: ${_this.tags}, theme: ${_this.theme}, type: ${_this.type}, uploaderAvatar: ${_this.uploaderAvatar}, uploaderName: ${_this.uploaderName}, views: ${_this.views}, failed: ${_this.failed})';
}


}

/// @nodoc
abstract mixin class $SubmissionCopyWith<$Res>  {
  factory $SubmissionCopyWith(Submission value, $Res Function(Submission) _then) = _$SubmissionCopyWithImpl;
@useResult
$Res call({
 String file, int id, SubmissionRating rating, String title, String uploader, String? category, int? comments, String? description, String? extension, int? favorites, String? favouriteLink, bool? favourited, String? fileSize, String? noteLink, DateTime? posted, String? preview, String? resolution, String? species, List<String>? tags, String? theme, SubmissionType? type, String? uploaderAvatar, String? uploaderName, int? views, Map<String, ParseException> failed
});




}
/// @nodoc
class _$SubmissionCopyWithImpl<$Res>
    implements $SubmissionCopyWith<$Res> {
  _$SubmissionCopyWithImpl(this._self, this._then);

  final Submission _self;
  final $Res Function(Submission) _then;

/// Create a copy of Submission
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? file = null,Object? id = null,Object? rating = null,Object? title = null,Object? uploader = null,Object? category = freezed,Object? comments = freezed,Object? description = freezed,Object? extension = freezed,Object? favorites = freezed,Object? favouriteLink = freezed,Object? favourited = freezed,Object? fileSize = freezed,Object? noteLink = freezed,Object? posted = freezed,Object? preview = freezed,Object? resolution = freezed,Object? species = freezed,Object? tags = freezed,Object? theme = freezed,Object? type = freezed,Object? uploaderAvatar = freezed,Object? uploaderName = freezed,Object? views = freezed,Object? failed = null,}) {
  return _then(Submission(
file: null == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as SubmissionRating,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,uploader: null == uploader ? _self.uploader : uploader // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,comments: freezed == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as int?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,extension: freezed == extension ? _self.extension : extension // ignore: cast_nullable_to_non_nullable
as String?,favorites: freezed == favorites ? _self.favorites : favorites // ignore: cast_nullable_to_non_nullable
as int?,favouriteLink: freezed == favouriteLink ? _self.favouriteLink : favouriteLink // ignore: cast_nullable_to_non_nullable
as String?,favourited: freezed == favourited ? _self.favourited : favourited // ignore: cast_nullable_to_non_nullable
as bool?,fileSize: freezed == fileSize ? _self.fileSize : fileSize // ignore: cast_nullable_to_non_nullable
as String?,noteLink: freezed == noteLink ? _self.noteLink : noteLink // ignore: cast_nullable_to_non_nullable
as String?,posted: freezed == posted ? _self.posted : posted // ignore: cast_nullable_to_non_nullable
as DateTime?,preview: freezed == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as String?,resolution: freezed == resolution ? _self.resolution : resolution // ignore: cast_nullable_to_non_nullable
as String?,species: freezed == species ? _self.species : species // ignore: cast_nullable_to_non_nullable
as String?,tags: freezed == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>?,theme: freezed == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as SubmissionType?,uploaderAvatar: freezed == uploaderAvatar ? _self.uploaderAvatar : uploaderAvatar // ignore: cast_nullable_to_non_nullable
as String?,uploaderName: freezed == uploaderName ? _self.uploaderName : uploaderName // ignore: cast_nullable_to_non_nullable
as String?,views: freezed == views ? _self.views : views // ignore: cast_nullable_to_non_nullable
as int?,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as Map<String, ParseException>,
  ));
}

}


/// Adds pattern-matching-related methods to [Submission].
extension SubmissionPatterns on Submission {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Submission value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Submission() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Submission value)  $default,){
final _that = this;
switch (_that) {
case _Submission():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Submission value)?  $default,){
final _that = this;
switch (_that) {
case _Submission() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String file,  int id,  SubmissionRating rating,  String title,  String uploader,  String? category,  int? comments,  String? description,  String? extension,  int? favorites,  String? favouriteLink,  bool? favourited,  String? fileSize,  String? noteLink,  DateTime? posted,  String? preview,  String? resolution,  String? species,  List<String>? tags,  String? theme,  SubmissionType? type,  String? uploaderAvatar,  String? uploaderName,  int? views,  Map<String, ParseException> failed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Submission() when $default != null:
return $default(_that.file,_that.id,_that.rating,_that.title,_that.uploader,_that.category,_that.comments,_that.description,_that.extension,_that.favorites,_that.favouriteLink,_that.favourited,_that.fileSize,_that.noteLink,_that.posted,_that.preview,_that.resolution,_that.species,_that.tags,_that.theme,_that.type,_that.uploaderAvatar,_that.uploaderName,_that.views,_that.failed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String file,  int id,  SubmissionRating rating,  String title,  String uploader,  String? category,  int? comments,  String? description,  String? extension,  int? favorites,  String? favouriteLink,  bool? favourited,  String? fileSize,  String? noteLink,  DateTime? posted,  String? preview,  String? resolution,  String? species,  List<String>? tags,  String? theme,  SubmissionType? type,  String? uploaderAvatar,  String? uploaderName,  int? views,  Map<String, ParseException> failed)  $default,) {final _that = this;
switch (_that) {
case _Submission():
return $default(_that.file,_that.id,_that.rating,_that.title,_that.uploader,_that.category,_that.comments,_that.description,_that.extension,_that.favorites,_that.favouriteLink,_that.favourited,_that.fileSize,_that.noteLink,_that.posted,_that.preview,_that.resolution,_that.species,_that.tags,_that.theme,_that.type,_that.uploaderAvatar,_that.uploaderName,_that.views,_that.failed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String file,  int id,  SubmissionRating rating,  String title,  String uploader,  String? category,  int? comments,  String? description,  String? extension,  int? favorites,  String? favouriteLink,  bool? favourited,  String? fileSize,  String? noteLink,  DateTime? posted,  String? preview,  String? resolution,  String? species,  List<String>? tags,  String? theme,  SubmissionType? type,  String? uploaderAvatar,  String? uploaderName,  int? views,  Map<String, ParseException> failed)?  $default,) {final _that = this;
switch (_that) {
case _Submission() when $default != null:
return $default(_that.file,_that.id,_that.rating,_that.title,_that.uploader,_that.category,_that.comments,_that.description,_that.extension,_that.favorites,_that.favouriteLink,_that.favourited,_that.fileSize,_that.noteLink,_that.posted,_that.preview,_that.resolution,_that.species,_that.tags,_that.theme,_that.type,_that.uploaderAvatar,_that.uploaderName,_that.views,_that.failed);case _:
  return null;

}
}

}

/// @nodoc


class _Submission extends Submission {
  const _Submission({required this.file, required this.id, required this.rating, required this.title, required this.uploader, this.category, this.comments, this.description, this.extension, this.favorites, this.favouriteLink, this.favourited, this.fileSize, this.noteLink, this.posted, this.preview, this.resolution, this.species,  List<String>? tags, this.theme, this.type, this.uploaderAvatar, this.uploaderName, this.views,  Map<String, ParseException> failed = const {}}): _tags = tags,_failed = failed,super._();
  

/// Absolute url of the submitted file at full resolution.
@override final  String file;
/// The submission's numeric identifier.
@override final  int id;
/// The submission's content rating.
@override final  SubmissionRating rating;
/// The submission's title, free of the padding the page markup adds.
@override final  String title;
/// The url form of the name of whoever posted the submission,
/// lowercased and with underscores removed.
@override final  String uploader;
/// The kind of work, as the uploader filed it.
@override final  String? category;
/// How many comments the submission carries.
@override final  int? comments;
/// The rendered description, as markup rather than text.
@override final  String? description;
/// The file's extension, without a leading dot.
@override final  String? extension;
/// How many people have favourited the submission.
@override final  int? favorites;
/// Absolute url that adds or removes the submission from your
/// favourites. The site only writes one of the two, so which it is
/// says whether you have favourited it already. Absent when signed
/// out.
@override final  String? favouriteLink;
/// Absent when signed out.
@override final  bool? favourited;
/// The size of the uploaded file, as FA renders it.
@override final  String? fileSize;
/// Absolute url that opens a new note to whoever posted it. Absent
/// when signed out.
@override final  String? noteLink;
/// When the submission was posted.
@override final  DateTime? posted;
/// Absolute url of a reduced copy of the submitted file.
@override final  String? preview;
/// The image's pixel dimensions, as FA renders them.
@override final  String? resolution;
/// The species the uploader filed the work under.
@override final  String? species;
/// Keywords the uploader attached to the submission.
 final  List<String>? _tags;
/// Keywords the uploader attached to the submission.
@override List<String>? get tags {
  final value = _tags;
  if (value == null) return null;
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

/// The subject matter the uploader filed the work under.
@override final  String? theme;
/// The kind of content a submission holds.
@override final  SubmissionType? type;
/// Absolute url of the avatar of whoever posted the submission.
@override final  String? uploaderAvatar;
/// The name of whoever posted the submission, as displayed.
@override final  String? uploaderName;
/// How many times the submission has been viewed.
@override final  int? views;
 final  Map<String, ParseException> _failed;
@override@JsonKey() Map<String, ParseException> get failed {
  if (_failed is EqualUnmodifiableMapView) return _failed;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_failed);
}


/// Create a copy of Submission
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubmissionCopyWith<_Submission> get copyWith => __$SubmissionCopyWithImpl<_Submission>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Submission&&(identical(other.file, file) || other.file == file)&&(identical(other.id, id) || other.id == id)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.title, title) || other.title == title)&&(identical(other.uploader, uploader) || other.uploader == uploader)&&(identical(other.category, category) || other.category == category)&&(identical(other.comments, comments) || other.comments == comments)&&(identical(other.description, description) || other.description == description)&&(identical(other.extension, extension) || other.extension == extension)&&(identical(other.favorites, favorites) || other.favorites == favorites)&&(identical(other.favouriteLink, favouriteLink) || other.favouriteLink == favouriteLink)&&(identical(other.favourited, favourited) || other.favourited == favourited)&&(identical(other.fileSize, fileSize) || other.fileSize == fileSize)&&(identical(other.noteLink, noteLink) || other.noteLink == noteLink)&&(identical(other.posted, posted) || other.posted == posted)&&(identical(other.preview, preview) || other.preview == preview)&&(identical(other.resolution, resolution) || other.resolution == resolution)&&(identical(other.species, species) || other.species == species)&&const DeepCollectionEquality().equals(other.tags, _tags)&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.type, type) || other.type == type)&&(identical(other.uploaderAvatar, uploaderAvatar) || other.uploaderAvatar == uploaderAvatar)&&(identical(other.uploaderName, uploaderName) || other.uploaderName == uploaderName)&&(identical(other.views, views) || other.views == views)&&const DeepCollectionEquality().equals(other.failed, _failed));
}


@override
int get hashCode {
    return Object.hashAll([runtimeType,file,id,rating,title,uploader,category,comments,description,extension,favorites,favouriteLink,favourited,fileSize,noteLink,posted,preview,resolution,species,const DeepCollectionEquality().hash(_tags),theme,type,uploaderAvatar,uploaderName,views,const DeepCollectionEquality().hash(_failed)]);
}

@override
String toString() {
    return 'Submission(file: $file, id: $id, rating: $rating, title: $title, uploader: $uploader, category: $category, comments: $comments, description: $description, extension: $extension, favorites: $favorites, favouriteLink: $favouriteLink, favourited: $favourited, fileSize: $fileSize, noteLink: $noteLink, posted: $posted, preview: $preview, resolution: $resolution, species: $species, tags: $tags, theme: $theme, type: $type, uploaderAvatar: $uploaderAvatar, uploaderName: $uploaderName, views: $views, failed: $failed)';
}


}

/// @nodoc
abstract mixin class _$SubmissionCopyWith<$Res> implements $SubmissionCopyWith<$Res> {
  factory _$SubmissionCopyWith(_Submission value, $Res Function(_Submission) _then) = __$SubmissionCopyWithImpl;
@override @useResult
$Res call({
 String file, int id, SubmissionRating rating, String title, String uploader, String? category, int? comments, String? description, String? extension, int? favorites, String? favouriteLink, bool? favourited, String? fileSize, String? noteLink, DateTime? posted, String? preview, String? resolution, String? species, List<String>? tags, String? theme, SubmissionType? type, String? uploaderAvatar, String? uploaderName, int? views, Map<String, ParseException> failed
});




}
/// @nodoc
class __$SubmissionCopyWithImpl<$Res>
    implements _$SubmissionCopyWith<$Res> {
  __$SubmissionCopyWithImpl(this._self, this._then);

  final _Submission _self;
  final $Res Function(_Submission) _then;

/// Create a copy of Submission
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? file = null,Object? id = null,Object? rating = null,Object? title = null,Object? uploader = null,Object? category = freezed,Object? comments = freezed,Object? description = freezed,Object? extension = freezed,Object? favorites = freezed,Object? favouriteLink = freezed,Object? favourited = freezed,Object? fileSize = freezed,Object? noteLink = freezed,Object? posted = freezed,Object? preview = freezed,Object? resolution = freezed,Object? species = freezed,Object? tags = freezed,Object? theme = freezed,Object? type = freezed,Object? uploaderAvatar = freezed,Object? uploaderName = freezed,Object? views = freezed,Object? failed = null,}) {
  return _then(_Submission(
file: null == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as SubmissionRating,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,uploader: null == uploader ? _self.uploader : uploader // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,comments: freezed == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as int?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,extension: freezed == extension ? _self.extension : extension // ignore: cast_nullable_to_non_nullable
as String?,favorites: freezed == favorites ? _self.favorites : favorites // ignore: cast_nullable_to_non_nullable
as int?,favouriteLink: freezed == favouriteLink ? _self.favouriteLink : favouriteLink // ignore: cast_nullable_to_non_nullable
as String?,favourited: freezed == favourited ? _self.favourited : favourited // ignore: cast_nullable_to_non_nullable
as bool?,fileSize: freezed == fileSize ? _self.fileSize : fileSize // ignore: cast_nullable_to_non_nullable
as String?,noteLink: freezed == noteLink ? _self.noteLink : noteLink // ignore: cast_nullable_to_non_nullable
as String?,posted: freezed == posted ? _self.posted : posted // ignore: cast_nullable_to_non_nullable
as DateTime?,preview: freezed == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as String?,resolution: freezed == resolution ? _self.resolution : resolution // ignore: cast_nullable_to_non_nullable
as String?,species: freezed == species ? _self.species : species // ignore: cast_nullable_to_non_nullable
as String?,tags: freezed == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>?,theme: freezed == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as SubmissionType?,uploaderAvatar: freezed == uploaderAvatar ? _self.uploaderAvatar : uploaderAvatar // ignore: cast_nullable_to_non_nullable
as String?,uploaderName: freezed == uploaderName ? _self.uploaderName : uploaderName // ignore: cast_nullable_to_non_nullable
as String?,views: freezed == views ? _self.views : views // ignore: cast_nullable_to_non_nullable
as int?,failed: null == failed ? _self._failed : failed // ignore: cast_nullable_to_non_nullable
as Map<String, ParseException>,
  ));
}


}

// dart format on
