// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_points.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CardPoints _$CardPointsFromJson(Map<String, dynamic> json) {
  return CardPoints(
      used: (json['used'] as num).toDouble(),
      remaining: (json['remaining'] as num).toDouble(),
      amount: (json['amount'] as num).toDouble(),
      caption: json['caption'] as String);
}

Map<String, dynamic> _$CardPointsToJson(CardPoints instance) =>
    <String, dynamic>{
      'used': instance.used,
      'remaining': instance.remaining,
      'amount': instance.amount,
      'caption': instance.caption
    };
