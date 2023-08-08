
import 'package:openpay_flutter/model/customer.dart';
import 'package:openpay_flutter/model/open_pay_base_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment.g.dart';

@JsonSerializable(nullable: true)
class Payment {
  Payment(
      {
      this.source_id,
      this.method,
      this.amount,
      this.description,
      this.order_id,
      this.device_session_id,
      this.customer
      });

  @JsonKey(nullable: true)
  
  
  String source_id;
  String method;
  double amount;
  String description;
  String order_id;
  String device_session_id;
  Map<String, dynamic> customer;



  factory Payment.fromJson(Map<String, dynamic> json) => _$PaymentFromJson(json);

  Payment fromJson(Map<String, dynamic> json) => _$PaymentFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentToJson(this);
}
