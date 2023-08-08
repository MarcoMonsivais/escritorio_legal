import 'package:json_annotation/json_annotation.dart';

part 'card_points.g.dart';

@JsonSerializable(nullable: false)
class CardPoints {
  CardPoints({this.used, this.remaining, this.amount, this.caption});

  double used;
  double remaining;
  double amount;
  String caption;

  factory CardPoints.fromJson(Map<String, dynamic> json) =>
      _$CardPointsFromJson(json);
  Map<String, dynamic> toJson() => _$CardPointsToJson(this);
}

enum UseCardPointsType {
  /** mixed. Cargo con pesos y puntos*/
  MIXED,

  /** none. Cargo en pesos*/
  NONE,

  /** only points. Cargo solo con puntos*/
  ONLY_POINTS
}
