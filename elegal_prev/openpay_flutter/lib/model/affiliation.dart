import 'package:json_annotation/json_annotation.dart';

part 'affiliation.g.dart';

@JsonSerializable(nullable: false)
class Affiliation {

  Affiliation({
    this.number,
    this.name,
    this.merchant_name
  });

  String number;
  String name;
  String merchant_name;

  factory Affiliation.fromJson(Map<String, dynamic> json) => _$AffiliationFromJson(json);
  Map<String, dynamic> toJson() => _$AffiliationToJson(this);
}
