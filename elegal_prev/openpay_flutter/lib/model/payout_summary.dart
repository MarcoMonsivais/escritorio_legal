import 'package:openpay_flutter/model/open_pay_base_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payout_summary.g.dart';

@JsonSerializable(nullable: false)
class PayoutSummary extends OpenPayBaseModel {
  PayoutSummary(
      {this.in_x,
      this.out,
      this.charged_adjustments,
      this.refunded_adjustments});
  double in_x;
  double out;
  double charged_adjustments;
  double refunded_adjustments;

  factory PayoutSummary.fromJson(Map<String, dynamic> json) =>
      _$PayoutSummaryFromJson(json);
      PayoutSummary fromJson(Map<String, dynamic> json) =>
      _$PayoutSummaryFromJson(json);
  Map<String, dynamic> toJson() => _$PayoutSummaryToJson(this);
}
