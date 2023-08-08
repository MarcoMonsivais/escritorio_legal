// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Card _$CardFromJson(Map<String, dynamic> json) {
  return Card(
      token_id: json['token_id'] as String,
      creation_date: json['creation_date'] == null
          ? null
          : DateTime.parse(json['creation_date'] as String),
      bank_name: json['bank_name'] as String,
      allows_payouts: json['allows_payouts'] as bool,
      holder_name: json['holder_name'] as String,
      expiration_month: json['expiration_month'] as String,
      expiration_year: json['expiration_year'] as String,
      address: json['address'] == null
          ? null
          : Address.fromJson(json['address'] as Map<String, dynamic>),
      card_number: json['card_number'] as String,
      brand: json['brand'] as String,
      allows_charges: json['allows_charges'] as bool,
      bank_code: json['bank_code'] as String,
      type: json['type'] as String,
      cvv2: json['cvv2'] as String,
      device_session_id: json['device_session_id'] as String,
      points_card: json['points_card'] as bool,
      points_type: json['points_type'] as String,
      affiliation: json['affiliation'] == null
          ? null
          : Affiliation.fromJson(json['affiliation'] as Map<String, dynamic>))
    ..id = json['id'] as String
    ..customer_id = json['customer_id'] as String;
}

Map<String, dynamic> _$CardToJson(Card instance) => <String, dynamic>{
      'id': instance.id,
      'token_id': instance.token_id,
      'creation_date': instance.creation_date?.toIso8601String(),
      'bank_name': instance.bank_name,
      'allows_payouts': instance.allows_payouts,
      'holder_name': instance.holder_name,
      'expiration_month': instance.expiration_month,
      'expiration_year': instance.expiration_year,
      'address': instance.address,
      'card_number': instance.card_number,
      'brand': instance.brand,
      'allows_charges': instance.allows_charges,
      'bank_code': instance.bank_code,
      'type': instance.type,
      'cvv2': instance.cvv2,
      'device_session_id': instance.device_session_id,
      'points_card': instance.points_card,
      'points_type': instance.points_type,
      'affiliation': instance.affiliation,
      'customer_id': instance.customer_id
    };
