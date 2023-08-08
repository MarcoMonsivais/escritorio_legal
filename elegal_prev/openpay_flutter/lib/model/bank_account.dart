import 'package:openpay_flutter/model/open_pay_base_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bank_account.g.dart';

@JsonSerializable(nullable: false)
class BankAccount extends OpenPayBaseModel {
  BankAccount(
      {this.creation_date,
      this.alias,
      this.clabe,
      this.holder_name,
      this.bank_name,
      this.bank_code});

  @JsonKey(nullable: true)
  DateTime creation_date;
  String alias;
  String clabe;
  String holder_name;
  String bank_name;
  String bank_code;

  factory BankAccount.fromJson(Map<String, dynamic> json) =>
      _$BankAccountFromJson(json);

  BankAccount fromJson(Map<String, dynamic> json) =>
      _$BankAccountFromJson(json);
  Map<String, dynamic> toJson() => _$BankAccountToJson(this);
}
