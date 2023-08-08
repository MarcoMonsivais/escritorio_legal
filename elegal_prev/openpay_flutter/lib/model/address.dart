import 'package:json_annotation/json_annotation.dart';

part 'address.g.dart';

@JsonSerializable(nullable: true)
class Address {

  Address({    
    this.postal_code,
    this.line1,
    this.line2,
    this.line3,
    this.city,
    this.state,
    this.country_code
  });

  String postal_code;
  String line1;
  String line2;
  String line3;
  String city;
  String state;
  String country_code;

  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);
  Map<String, dynamic> toJson() => _$AddressToJson(this);
}
