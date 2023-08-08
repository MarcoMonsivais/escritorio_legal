import 'package:openpay_flutter/model/bank_account.dart';
import 'package:openpay_flutter/model/card.dart';
import 'package:openpay_flutter/model/card_points.dart';
import 'package:openpay_flutter/model/exchange_rate.dart';
import 'package:openpay_flutter/model/open_pay_base_model.dart';
import 'package:openpay_flutter/model/payment_method.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transaction.g.dart';

@JsonSerializable(nullable: false)
class Transaction extends OpenPayBaseModel {
  Transaction(
      {
        this.creation_date,
      this.amount,
      this.status,
      this.description,
      this.transaction_type,
      this.operation_type,
      this.method,
      this.error_message,
      this.card,
      this.bank_account,
      this.authorization,
      this.order_id,
      this.customer_id,
      this.conciliated,
      this.due_date});

  @JsonKey(nullable: true)
  DateTime creation_date;
  double amount;
  String status;
  String description;
  String transaction_type;
  String operation_type;
  String method;
  String error_message;
  Card card;
   @JsonKey(nullable: true)
  BankAccount bank_account;
  String authorization;
  String order_id;
  String customer_id;
  bool conciliated;
  @JsonKey(nullable: true)
  DateTime due_date;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

    Transaction fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}

class Refund extends Transaction {}

class Charge extends Transaction {
  Refund refund;

  PaymentMethod payment_method;

  CardPoints card_points;

  ExchangeRate exchange_rate;

  Map<String, String> metadata;
}

class Payout extends Transaction {}

class Fee extends Transaction {}

class Transfer extends Transaction {}

enum TransactionStatus {
  IN_PROGRESS,
  COMPLETED,
  REFUNDED,
  CHARGEBACK_PENDING,
  CHARGEBACK_ACCEPTED,
  CHARGEBACK_ADJUSTMENT,
  CHARGE_PENDING,
  CANCELLED,
  FAILED
}
