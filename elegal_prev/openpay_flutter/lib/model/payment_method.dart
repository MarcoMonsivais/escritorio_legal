import 'package:openpay_flutter/model/exchange_rate.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment_method.g.dart';

@JsonSerializable(nullable: false)
class PaymentMethod {
  PaymentMethod(
      {this.type,
      this.bank_name,
      this.clabe,
      this.name,
      this.reference,
      this.walmart_reference,
      this.barcode_url,
      this.barcode_walmart_url,
      this.payment_address,
      this.payment_url_bip21,
      this.amount_bitcoins,
      this.exchange_rate,
      this.url,
      this.ivr_key,
      this.phone_number});

  String type;
  String bank_name;
  String clabe;
  String name;
  String reference;
  String walmart_reference;
  String barcode_url;
  String barcode_walmart_url;
  String payment_address;
  String payment_url_bip21;
  double amount_bitcoins;
  ExchangeRate exchange_rate;
  String url;
  String ivr_key;
  String phone_number;

  factory PaymentMethod.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentMethodToJson(this);
}
