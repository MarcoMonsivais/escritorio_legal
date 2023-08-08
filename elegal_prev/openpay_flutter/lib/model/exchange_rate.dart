import 'package:json_annotation/json_annotation.dart';

part 'exchange_rate.g.dart';

@JsonSerializable(nullable: false)
class ExchangeRate {
  ExchangeRate({this.from_currency, this.to_currency, this.date, this.value});

  String from_currency;
  String to_currency;
  @JsonKey(nullable: true)
  DateTime date;
  double value;

  factory ExchangeRate.fromJson(Map<String, dynamic> json) =>
      _$ExchangeRateFromJson(json);
  Map<String, dynamic> toJson() => _$ExchangeRateToJson(this);
}
