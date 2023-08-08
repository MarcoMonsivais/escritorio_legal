import 'package:json_annotation/json_annotation.dart';

part 'merchant.g.dart';

@JsonSerializable(nullable: false)
class Merchant {
  Merchant(
      {this.name,
      this.email,
      this.phone,
      this.status,
      this.clabe,
      this.balance,
      this.creation_date,
      this.available_funds});

  String name;
  String email;
  String phone;
  String status;
  String clabe;
  double balance;
  @JsonKey(nullable: true)
  DateTime creation_date;
  double available_funds;
  factory Merchant.fromJson(Map<String, dynamic> json) =>
      _$MerchantFromJson(json);
  Map<String, dynamic> toJson() => _$MerchantToJson(this);
}
