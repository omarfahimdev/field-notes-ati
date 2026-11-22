// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'site.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Site {

 int get id; String get siteName; String get address; Customer get customer;
/// Create a copy of Site
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SiteCopyWith<Site> get copyWith => _$SiteCopyWithImpl<Site>(this as Site, _$identity);

  /// Serializes this Site to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Site;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Site&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.siteName, _this.siteName) || other.siteName == _this.siteName)&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.customer, _this.customer) || other.customer == _this.customer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Site;
  return Object.hash(runtimeType,_this.id,_this.siteName,_this.address,_this.customer);
}

@override
String toString() {
  final _this = this as Site;
  return 'Site(id: ${_this.id}, siteName: ${_this.siteName}, address: ${_this.address}, customer: ${_this.customer})';
}


}

/// @nodoc
abstract mixin class $SiteCopyWith<$Res>  {
  factory $SiteCopyWith(Site value, $Res Function(Site) _then) = _$SiteCopyWithImpl;
@useResult
$Res call({
 int id, String siteName, String address, Customer customer
});


$CustomerCopyWith<$Res> get customer;

}
/// @nodoc
class _$SiteCopyWithImpl<$Res>
    implements $SiteCopyWith<$Res> {
  _$SiteCopyWithImpl(this._self, this._then);

  final Site _self;
  final $Res Function(Site) _then;

/// Create a copy of Site
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? siteName = null,Object? address = null,Object? customer = null,}) {
  return _then(Site(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,siteName: null == siteName ? _self.siteName : siteName // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,customer: null == customer ? _self.customer : customer // ignore: cast_nullable_to_non_nullable
as Customer,
  ));
}
/// Create a copy of Site
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CustomerCopyWith<$Res> get customer {
  
  return $CustomerCopyWith<$Res>(_self.customer, (value) {
    return _then(_self.copyWith(customer: value));
  });
}
}


/// Adds pattern-matching-related methods to [Site].
extension SitePatterns on Site {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Site value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Site() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Site value)  $default,){
final _that = this;
switch (_that) {
case _Site():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Site value)?  $default,){
final _that = this;
switch (_that) {
case _Site() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String siteName,  String address,  Customer customer)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Site() when $default != null:
return $default(_that.id,_that.siteName,_that.address,_that.customer);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String siteName,  String address,  Customer customer)  $default,) {final _that = this;
switch (_that) {
case _Site():
return $default(_that.id,_that.siteName,_that.address,_that.customer);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String siteName,  String address,  Customer customer)?  $default,) {final _that = this;
switch (_that) {
case _Site() when $default != null:
return $default(_that.id,_that.siteName,_that.address,_that.customer);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Site extends Site {
   _Site({required this.id, required this.siteName, required this.address, required this.customer}): super._();
  factory _Site.fromJson(Map<String, dynamic> json) => _$SiteFromJson(json);

@override final  int id;
@override final  String siteName;
@override final  String address;
@override final  Customer customer;

/// Create a copy of Site
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SiteCopyWith<_Site> get copyWith => __$SiteCopyWithImpl<_Site>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SiteToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Site&&(identical(other.id, id) || other.id == id)&&(identical(other.siteName, siteName) || other.siteName == siteName)&&(identical(other.address, address) || other.address == address)&&(identical(other.customer, customer) || other.customer == customer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,siteName,address,customer);
}

@override
String toString() {
    return 'Site(id: $id, siteName: $siteName, address: $address, customer: $customer)';
}


}

/// @nodoc
abstract mixin class _$SiteCopyWith<$Res> implements $SiteCopyWith<$Res> {
  factory _$SiteCopyWith(_Site value, $Res Function(_Site) _then) = __$SiteCopyWithImpl;
@override @useResult
$Res call({
 int id, String siteName, String address, Customer customer
});


@override $CustomerCopyWith<$Res> get customer;

}
/// @nodoc
class __$SiteCopyWithImpl<$Res>
    implements _$SiteCopyWith<$Res> {
  __$SiteCopyWithImpl(this._self, this._then);

  final _Site _self;
  final $Res Function(_Site) _then;

/// Create a copy of Site
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? siteName = null,Object? address = null,Object? customer = null,}) {
  return _then(_Site(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,siteName: null == siteName ? _self.siteName : siteName // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,customer: null == customer ? _self.customer : customer // ignore: cast_nullable_to_non_nullable
as Customer,
  ));
}

/// Create a copy of Site
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CustomerCopyWith<$Res> get customer {
  
  return $CustomerCopyWith<$Res>(_self.customer, (value) {
    return _then(_self.copyWith(customer: value));
  });
}
}

// dart format on
