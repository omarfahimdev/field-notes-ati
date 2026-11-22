// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'site.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Site _$SiteFromJson(Map<String, dynamic> json) => _Site(
  id: (json['id'] as num).toInt(),
  siteName: json['siteName'] as String,
  address: json['address'] as String,
  customer: Customer.fromJson(json['customer'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SiteToJson(_Site instance) => <String, dynamic>{
  'id': instance.id,
  'siteName': instance.siteName,
  'address': instance.address,
  'customer': instance.customer,
};
