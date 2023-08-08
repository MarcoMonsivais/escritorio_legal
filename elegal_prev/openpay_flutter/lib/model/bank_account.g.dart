// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BankAccount _$BankAccountFromJson(Map<String, dynamic> json) {
  return BankAccount(
      creation_date: json['creation_date'] == null
          ? null
          : DateTime.parse(json['creation_date'] as String),
      alias: json['alias'] as String,
      clabe: json['clabe'] as String,
      holder_name: json['holder_name'] as String,
      bank_name: json['bank_name'] as String,
      bank_code: json['bank_code'] as String)
    ..id = json['id'] as String;
}

Map<String, dynamic> _$BankAccountToJson(BankAccount instance) =>
    <String, dynamic>{
      'id': instance.id,
      'creation_date': instance.creation_date?.toIso8601String(),
      'alias': instance.alias,
      'clabe': instance.clabe,
      'holder_name': instance.holder_name,
      'bank_name': instance.bank_name,
      'bank_code': instance.bank_code
    };
