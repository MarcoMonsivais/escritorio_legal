// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange_rate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExchangeRate _$ExchangeRateFromJson(Map<String, dynamic> json) {
  return ExchangeRate(
      from_currency: json['from_currency'] as String,
      to_currency: json['to_currency'] as String,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      value: (json['value'] as num).toDouble());
}

Map<String, dynamic> _$ExchangeRateToJson(ExchangeRate instance) =>
    <String, dynamic>{
      'from_currency': instance.from_currency,
      'to_currency': instance.to_currency,
      'date': instance.date?.toIso8601String(),
      'value': instance.value
    };
