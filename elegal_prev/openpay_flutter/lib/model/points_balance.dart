import 'package:json_annotation/json_annotation.dart';
part 'points_balance.g.dart';

@JsonSerializable(nullable: false)
class PointsBalance {
  PointsBalance({this.remaining_points, this.remaining_mxn});

  String _pointsType;

  BigInt remaining_points;
  double remaining_mxn;

  String get points_type => _pointsType;

  factory PointsBalance.fromJson(Map<String, dynamic> json) =>
      _$PointsBalanceFromJson(json);
  Map<String, dynamic> toJson() => _$PointsBalanceToJson(this);

  PointsType get points_type_enum {
    if (_pointsType == "BANCOMER")
      return PointsType.BANCOMER;
    else if (_pointsType == "SANTANDER") {
      return PointsType.SANTANDER;
    } else if (_pointsType == "SCOTIA") {
      return PointsType.SCOTIA;
    } else {
      return PointsType.NONE;
    }
  }
}

enum PointsType { NONE, BANCOMER, SANTANDER, SCOTIA }
