// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Location _$LocationFromJson(Map<String, dynamic> json) => _Location(
  locationLabel: json['locationLabel'] as String?,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
);

Map<String, dynamic> _$LocationToJson(_Location instance) => <String, dynamic>{
  'locationLabel': instance.locationLabel,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
};
