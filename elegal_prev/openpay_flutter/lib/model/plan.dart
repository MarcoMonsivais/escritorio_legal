import 'package:openpay_flutter/model/open_pay_base_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'plan.g.dart';

@JsonSerializable(nullable: false)
class Plan extends OpenPayBaseModel {
  Plan(
      {this.creation_date,
      this.name,
      this.amount,
      this.currency,
      this.repeat_every,
      this.repeat_unit,
      this.retry_times,
      this.status,
      this.status_After_retry,
      this.trial_days});
  @JsonKey(nullable: true)
  DateTime creation_date;
  String name;
  double amount;
  String currency;
  int repeat_every;
  String repeat_unit;
  int retry_times;
  String status;
  String status_After_retry;
  int trial_days;

  factory Plan.fromJson(Map<String, dynamic> json) => _$PlanFromJson(json);
  Plan fromJson(Map<String, dynamic> json) => _$PlanFromJson(json);
  Map<String, dynamic> toJson() => _$PlanToJson(this);
}
