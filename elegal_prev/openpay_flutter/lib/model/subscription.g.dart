// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Subscription _$SubscriptionFromJson(Map<String, dynamic> json) {
  return Subscription(
      creation_date: json['creation_date'] == null
          ? null
          : DateTime.parse(json['creation_date'] as String),
      cancel_at_period_end: json['cancel_at_period_end'] as bool,
      charge_date: json['charge_date'] == null
          ? null
          : DateTime.parse(json['charge_date'] as String),
      current_period: json['current_period'] as int,
      period_end_date: json['period_end_date'] == null
          ? null
          : DateTime.parse(json['period_end_date'] as String),
      trial_end_date: json['trial_end_date'] == null
          ? null
          : DateTime.parse(json['trial_end_date'] as String),
      plan_id: json['plan_id'] as String,
      customer_id: json['customer_id'] as String,
      card_id: json['card_id'] as String,
      status: json['status'] as String,
      card: Card.fromJson(json['card'] as Map<String, dynamic>),
      transaction:
          Transaction.fromJson(json['transaction'] as Map<String, dynamic>))
    ..id = json['id'] as String;
}

Map<String, dynamic> _$SubscriptionToJson(Subscription instance) =>
    <String, dynamic>{
      'id': instance.id,
      'creation_date': instance.creation_date?.toIso8601String(),
      'cancel_at_period_end': instance.cancel_at_period_end,
      'charge_date': instance.charge_date?.toIso8601String(),
      'current_period': instance.current_period,
      'period_end_date': instance.period_end_date?.toIso8601String(),
      'trial_end_date': instance.trial_end_date?.toIso8601String(),
      'plan_id': instance.plan_id,
      'customer_id': instance.customer_id,
      'card_id': instance.card_id,
      'status': instance.status,
      'card': instance.card,
      'transaction': instance.transaction
    };
