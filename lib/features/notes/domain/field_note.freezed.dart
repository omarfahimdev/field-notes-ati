// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'field_note.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FieldNote {

 int get id; Site get site; String get title; String get description; Location? get location; DateTime? get occurredAt; NoteStatus get status; String? get photoUrl;
/// Create a copy of FieldNote
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FieldNoteCopyWith<FieldNote> get copyWith => _$FieldNoteCopyWithImpl<FieldNote>(this as FieldNote, _$identity);

  /// Serializes this FieldNote to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FieldNote;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FieldNote&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.site, _this.site) || other.site == _this.site)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.location, _this.location) || other.location == _this.location)&&(identical(other.occurredAt, _this.occurredAt) || other.occurredAt == _this.occurredAt)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.photoUrl, _this.photoUrl) || other.photoUrl == _this.photoUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FieldNote;
  return Object.hash(runtimeType,_this.id,_this.site,_this.title,_this.description,_this.location,_this.occurredAt,_this.status,_this.photoUrl);
}

@override
String toString() {
  final _this = this as FieldNote;
  return 'FieldNote(id: ${_this.id}, site: ${_this.site}, title: ${_this.title}, description: ${_this.description}, location: ${_this.location}, occurredAt: ${_this.occurredAt}, status: ${_this.status}, photoUrl: ${_this.photoUrl})';
}


}

/// @nodoc
abstract mixin class $FieldNoteCopyWith<$Res>  {
  factory $FieldNoteCopyWith(FieldNote value, $Res Function(FieldNote) _then) = _$FieldNoteCopyWithImpl;
@useResult
$Res call({
 int id, Site site, String title, String description, Location? location, DateTime? occurredAt, NoteStatus status, String? photoUrl
});


$SiteCopyWith<$Res> get site;$LocationCopyWith<$Res>? get location;

}
/// @nodoc
class _$FieldNoteCopyWithImpl<$Res>
    implements $FieldNoteCopyWith<$Res> {
  _$FieldNoteCopyWithImpl(this._self, this._then);

  final FieldNote _self;
  final $Res Function(FieldNote) _then;

/// Create a copy of FieldNote
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? site = null,Object? title = null,Object? description = null,Object? location = freezed,Object? occurredAt = freezed,Object? status = null,Object? photoUrl = freezed,}) {
  return _then(FieldNote(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as Site,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as Location?,occurredAt: freezed == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as NoteStatus,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of FieldNote
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SiteCopyWith<$Res> get site {
  
  return $SiteCopyWith<$Res>(_self.site, (value) {
    return _then(_self.copyWith(site: value));
  });
}/// Create a copy of FieldNote
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocationCopyWith<$Res>? get location {
    if (_self.location == null) {
    return null;
  }

  return $LocationCopyWith<$Res>(_self.location!, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}


/// Adds pattern-matching-related methods to [FieldNote].
extension FieldNotePatterns on FieldNote {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FieldNote value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FieldNote() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FieldNote value)  $default,){
final _that = this;
switch (_that) {
case _FieldNote():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FieldNote value)?  $default,){
final _that = this;
switch (_that) {
case _FieldNote() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  Site site,  String title,  String description,  Location? location,  DateTime? occurredAt,  NoteStatus status,  String? photoUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FieldNote() when $default != null:
return $default(_that.id,_that.site,_that.title,_that.description,_that.location,_that.occurredAt,_that.status,_that.photoUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  Site site,  String title,  String description,  Location? location,  DateTime? occurredAt,  NoteStatus status,  String? photoUrl)  $default,) {final _that = this;
switch (_that) {
case _FieldNote():
return $default(_that.id,_that.site,_that.title,_that.description,_that.location,_that.occurredAt,_that.status,_that.photoUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  Site site,  String title,  String description,  Location? location,  DateTime? occurredAt,  NoteStatus status,  String? photoUrl)?  $default,) {final _that = this;
switch (_that) {
case _FieldNote() when $default != null:
return $default(_that.id,_that.site,_that.title,_that.description,_that.location,_that.occurredAt,_that.status,_that.photoUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FieldNote extends FieldNote {
   _FieldNote({required this.id, required this.site, required this.title, required this.description, this.location, this.occurredAt, this.status = NoteStatus.draft, this.photoUrl}): super._();
  factory _FieldNote.fromJson(Map<String, dynamic> json) => _$FieldNoteFromJson(json);

@override final  int id;
@override final  Site site;
@override final  String title;
@override final  String description;
@override final  Location? location;
@override final  DateTime? occurredAt;
@override@JsonKey() final  NoteStatus status;
@override final  String? photoUrl;

/// Create a copy of FieldNote
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FieldNoteCopyWith<_FieldNote> get copyWith => __$FieldNoteCopyWithImpl<_FieldNote>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FieldNoteToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FieldNote&&(identical(other.id, id) || other.id == id)&&(identical(other.site, site) || other.site == site)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.location, location) || other.location == location)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,site,title,description,location,occurredAt,status,photoUrl);
}

@override
String toString() {
    return 'FieldNote(id: $id, site: $site, title: $title, description: $description, location: $location, occurredAt: $occurredAt, status: $status, photoUrl: $photoUrl)';
}


}

/// @nodoc
abstract mixin class _$FieldNoteCopyWith<$Res> implements $FieldNoteCopyWith<$Res> {
  factory _$FieldNoteCopyWith(_FieldNote value, $Res Function(_FieldNote) _then) = __$FieldNoteCopyWithImpl;
@override @useResult
$Res call({
 int id, Site site, String title, String description, Location? location, DateTime? occurredAt, NoteStatus status, String? photoUrl
});


@override $SiteCopyWith<$Res> get site;@override $LocationCopyWith<$Res>? get location;

}
/// @nodoc
class __$FieldNoteCopyWithImpl<$Res>
    implements _$FieldNoteCopyWith<$Res> {
  __$FieldNoteCopyWithImpl(this._self, this._then);

  final _FieldNote _self;
  final $Res Function(_FieldNote) _then;

/// Create a copy of FieldNote
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? site = null,Object? title = null,Object? description = null,Object? location = freezed,Object? occurredAt = freezed,Object? status = null,Object? photoUrl = freezed,}) {
  return _then(_FieldNote(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as Site,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as Location?,occurredAt: freezed == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as NoteStatus,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of FieldNote
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SiteCopyWith<$Res> get site {
  
  return $SiteCopyWith<$Res>(_self.site, (value) {
    return _then(_self.copyWith(site: value));
  });
}/// Create a copy of FieldNote
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocationCopyWith<$Res>? get location {
    if (_self.location == null) {
    return null;
  }

  return $LocationCopyWith<$Res>(_self.location!, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}

// dart format on
