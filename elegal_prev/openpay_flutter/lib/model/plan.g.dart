// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Plan _$PlanFromJson(Map<String, dynamic> json) {
  return Plan(
      creation_date: json['creation_date'] == null
          ? null
          : DateTime.parse(json['creation_date'] as String),
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      repeat_every: json['repeat_every'] as int,
      repeat_unit: json['repeat_unit'] as String,
      retry_times: json['retry_times'] as int,
      status: json['status'] as String,
      status_After_retry: json['status_After_retry'] as String,
      trial_days: json['trial_days'] as int)
    ..id = json['id'] as String;
}

Map<String, dynamic> _$PlanToJson(Plan instance) => <String, dynamic>{
      'id': instance.id,
      'creation_date': instance.creation_date?.toIso8601String(),
      'name': instance.name,
      'amount': instance.amount,
      'currency': instance.currency,
      'repeat_every': instance.repeat_every,
      'repeat_unit': instance.repeat_unit,
      'retry_times': instance.retry_times,
      'status': instance.status,
      'status_After_retry': instance.status_After_retry,
      'trial_days': instance.trial_days
    };
