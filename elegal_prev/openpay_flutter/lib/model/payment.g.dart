// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Payment _$PaymentFromJson(Map<String, dynamic> json) {
  return Payment(
      source_id: json['source_id'] as String,
      method: json['method'] as String,
      amount: (json['amount'] as num)?.toDouble(),
      description: json['description'] as String,
      order_id: json['order_id'] as String,
      device_session_id: json['device_session_id'] as String,
      customer: json['customer'] as Map<String, dynamic>);
}

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
      'source_id': instance.source_id,
      'method': instance.method,
      'amount': instance.amount,
      'description': instance.description,
      'order_id': instance.order_id,
      'device_session_id': instance.device_session_id,
      'customer': instance.customer
    };
