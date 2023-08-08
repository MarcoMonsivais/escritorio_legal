import 'package:openpay_flutter/model/card.dart';
import 'package:openpay_flutter/model/open_pay_base_model.dart';
import 'package:openpay_flutter/model/transaction.dart';
import 'package:json_annotation/json_annotation.dart';

part 'subscription.g.dart';

@JsonSerializable(nullable: false)
class Subscription extends OpenPayBaseModel {
  Subscription({
    this.creation_date,
    this.cancel_at_period_end,
    this.charge_date,
    this.current_period,
    this.period_end_date,
    this.trial_end_date,
    this.plan_id,
    this.customer_id,
    this.card_id,
    this.status,
    this.card,
    this.transaction,
  });

  @JsonKey(nullable: true)
  DateTime creation_date;
  bool cancel_at_period_end;
  @JsonKey(nullable: true)
  DateTime charge_date;
  int current_period;
  @JsonKey(nullable: true)
  DateTime period_end_date;
  @JsonKey(nullable: true)
  DateTime trial_end_date;
  String plan_id;
  String customer_id;
  String card_id;
  String status;
  Card card;
  Transaction transaction;

  factory Subscription.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionFromJson(json);
      Subscription fromJson(Map<String, dynamic> json) =>
      _$SubscriptionFromJson(json);
  Map<String, dynamic> toJson() => _$SubscriptionToJson(this);
}
