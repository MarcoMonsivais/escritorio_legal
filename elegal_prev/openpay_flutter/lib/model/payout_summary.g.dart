// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payout_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayoutSummary _$PayoutSummaryFromJson(Map<String, dynamic> json) {
  return PayoutSummary(
      in_x: (json['in_x'] as num).toDouble(),
      out: (json['out'] as num).toDouble(),
      charged_adjustments: (json['charged_adjustments'] as num).toDouble(),
      refunded_adjustments: (json['refunded_adjustments'] as num).toDouble())
    ..id = json['id'] as String;
}

Map<String, dynamic> _$PayoutSummaryToJson(PayoutSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'in_x': instance.in_x,
      'out': instance.out,
      'charged_adjustments': instance.charged_adjustments,
      'refunded_adjustments': instance.refunded_adjustments
    };
