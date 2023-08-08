// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Merchant _$MerchantFromJson(Map<String, dynamic> json) {
  return Merchant(
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      status: json['status'] as String,
      clabe: json['clabe'] as String,
      balance: (json['balance'] as num).toDouble(),
      creation_date: json['creation_date'] == null
          ? null
          : DateTime.parse(json['creation_date'] as String),
      available_funds: (json['available_funds'] as num).toDouble());
}

Map<String, dynamic> _$MerchantToJson(Merchant instance) => <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'status': instance.status,
      'clabe': instance.clabe,
      'balance': instance.balance,
      'creation_date': instance.creation_date?.toIso8601String(),
      'available_funds': instance.available_funds
    };
