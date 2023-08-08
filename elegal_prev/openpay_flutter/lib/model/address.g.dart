// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) {
  return Address(
      postal_code: json['postal_code'] as String,
      line1: json['line1'] as String,
      line2: json['line2'] as String,
      line3: json['line3'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      country_code: json['country_code'] as String);
}

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'postal_code': instance.postal_code,
      'line1': instance.line1,
      'line2': instance.line2,
      'line3': instance.line3,
      'city': instance.city,
      'state': instance.state,
      'country_code': instance.country_code
    };
