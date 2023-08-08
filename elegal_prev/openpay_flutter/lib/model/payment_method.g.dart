// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentMethod _$PaymentMethodFromJson(Map<String, dynamic> json) {
  return PaymentMethod(
      type: json['type'] as String,
      bank_name: json['bank_name'] as String,
      clabe: json['clabe'] as String,
      name: json['name'] as String,
      reference: json['reference'] as String,
      walmart_reference: json['walmart_reference'] as String,
      barcode_url: json['barcode_url'] as String,
      barcode_walmart_url: json['barcode_walmart_url'] as String,
      payment_address: json['payment_address'] as String,
      payment_url_bip21: json['payment_url_bip21'] as String,
      amount_bitcoins: (json['amount_bitcoins'] as num).toDouble(),
      exchange_rate:
          ExchangeRate.fromJson(json['exchange_rate'] as Map<String, dynamic>),
      url: json['url'] as String,
      ivr_key: json['ivr_key'] as String,
      phone_number: json['phone_number'] as String);
}

Map<String, dynamic> _$PaymentMethodToJson(PaymentMethod instance) =>
    <String, dynamic>{
      'type': instance.type,
      'bank_name': instance.bank_name,
      'clabe': instance.clabe,
      'name': instance.name,
      'reference': instance.reference,
      'walmart_reference': instance.walmart_reference,
      'barcode_url': instance.barcode_url,
      'barcode_walmart_url': instance.barcode_walmart_url,
      'payment_address': instance.payment_address,
      'payment_url_bip21': instance.payment_url_bip21,
      'amount_bitcoins': instance.amount_bitcoins,
      'exchange_rate': instance.exchange_rate,
      'url': instance.url,
      'ivr_key': instance.ivr_key,
      'phone_number': instance.phone_number
    };
