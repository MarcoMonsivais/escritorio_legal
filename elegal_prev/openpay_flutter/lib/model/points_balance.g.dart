// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'points_balance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PointsBalance _$PointsBalanceFromJson(Map<String, dynamic> json) {
  return PointsBalance(
      remaining_points: BigInt.parse(json['remaining_points'] as String),
      remaining_mxn: (json['remaining_mxn'] as num).toDouble());
}

Map<String, dynamic> _$PointsBalanceToJson(PointsBalance instance) =>
    <String, dynamic>{
      'remaining_points': instance.remaining_points.toString(),
      'remaining_mxn': instance.remaining_mxn
    };
