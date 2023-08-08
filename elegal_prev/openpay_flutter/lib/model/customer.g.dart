// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) {
  return Customer(
      external_id: json['external_id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      last_name: json['last_name'] as String,
      phone_number: json['phone_number'] as String,
      address: json['address'] == null
          ? null
          : Address.fromJson(json['address'] as Map<String, dynamic>),
      status: json['status'] as String,
      clabe: json['clabe'] as String,
      balance: (json['balance'] as num)?.toDouble(),
      creation_date: json['creation_date'] == null
          ? null
          : DateTime.parse(json['creation_date'] as String),
      requires_account: json['requires_account'] as bool,
      store: json['store'] == null
          ? null
          : Store.fromJson(json['store'] as Map<String, dynamic>))
    ..id = json['id'] as String;
}

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'id': instance.id,
      'external_id': instance.external_id,
      'name': instance.name,
      'email': instance.email,
      'last_name': instance.last_name,
      'phone_number': instance.phone_number,
      'address': instance.address,
      'status': instance.status,
      'clabe': instance.clabe,
      'balance': instance.balance,
      'creation_date': instance.creation_date?.toIso8601String(),
      'requires_account': instance.requires_account,
      'store': instance.store
    };
