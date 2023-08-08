// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_pay_fees_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpenPayFeesSummary _$OpenPayFeesSummaryFromJson(Map<String, dynamic> json) {
  return OpenPayFeesSummary(
      charged: (json['charged'] as num).toDouble(),
      charged_tax: (json['charged_tax'] as num).toDouble(),
      charged_adjustments: (json['charged_adjustments'] as num).toDouble(),
      charged_adjustments_tax:
          (json['charged_adjustments_tax'] as num).toDouble(),
      refunded: (json['refunded'] as num).toDouble(),
      refunded_tax: (json['refunded_tax'] as num).toDouble(),
      refunded_adjustments: (json['refunded_adjustments'] as num).toDouble(),
      refunded_adjustments_tax:
          (json['refunded_adjustments_tax'] as num).toDouble(),
      total: (json['total'] as num).toDouble());
}

Map<String, dynamic> _$OpenPayFeesSummaryToJson(OpenPayFeesSummary instance) =>
    <String, dynamic>{
      'charged': instance.charged,
      'charged_tax': instance.charged_tax,
      'charged_adjustments': instance.charged_adjustments,
      'charged_adjustments_tax': instance.charged_adjustments_tax,
      'refunded': instance.refunded,
      'refunded_tax': instance.refunded_tax,
      'refunded_adjustments': instance.refunded_adjustments,
      'refunded_adjustments_tax': instance.refunded_adjustments_tax,
      'total': instance.total
    };
