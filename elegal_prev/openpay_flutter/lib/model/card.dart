import 'package:openpay_flutter/model/address.dart';
import 'package:openpay_flutter/model/affiliation.dart';
import 'package:openpay_flutter/model/open_pay_base_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'card.g.dart';

@JsonSerializable(nullable: true)
class Card extends OpenPayBaseModel {
  Card(
      {this.token_id,
      this.creation_date,
      this.bank_name,
      this.allows_payouts,
      this.holder_name,
      this.expiration_month,
      this.expiration_year,
      this.address,
      this.card_number,
      this.brand,
      this.allows_charges,
      this.bank_code,
      this.type,
      this.cvv2,
      this.device_session_id,
      this.points_card,
      this.points_type,
      this.affiliation});

  String token_id;
  @JsonKey(nullable: true)
  DateTime creation_date;
  String bank_name;
  bool allows_payouts;
  String holder_name;
  String expiration_month;
  String expiration_year;
  Address address;
  String card_number;
  String brand;
  bool allows_charges;
  String bank_code;
  String type;
  String cvv2;
  String device_session_id;
  bool points_card;
  String points_type;
  Affiliation affiliation;
  String customer_id;

  factory Card.fromJson(Map<String, dynamic> json) => _$CardFromJson(json);

  Card fromJson(Map<String, dynamic> json) => _$CardFromJson(json);
  Map<String, dynamic> toJson() => _$CardToJson(this);
}
