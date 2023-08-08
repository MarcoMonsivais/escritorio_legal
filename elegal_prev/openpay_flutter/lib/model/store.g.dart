// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Store _$StoreFromJson(Map<String, dynamic> json) {
  return Store(
      reference: json['reference'] as String,
      barcode_url: json['barcode_url'] as String);
}

Map<String, dynamic> _$StoreToJson(Store instance) => <String, dynamic>{
      'reference': instance.reference,
      'barcode_url': instance.barcode_url
    };
