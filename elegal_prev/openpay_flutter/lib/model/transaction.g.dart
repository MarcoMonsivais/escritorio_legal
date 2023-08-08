// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) {
  return Transaction(
      creation_date: json['creation_date'] == null
          ? null
          : DateTime.parse(json['creation_date'] as String),
      amount: (json['amount'] as num).toDouble(),
      status: json['status'] as String,
      description: json['description'] as String,
      transaction_type: json['transaction_type'] as String,
      operation_type: json['operation_type'] as String,
      method: json['method'] as String,
      error_message: json['error_message'] as String,
      card: Card.fromJson(json['card'] as Map<String, dynamic>),
      bank_account: json['bank_account'] == null
          ? null
          : BankAccount.fromJson(json['bank_account'] as Map<String, dynamic>),
      authorization: json['authorization'] as String,
      order_id: json['order_id'] as String,
      customer_id: json['customer_id'] as String,
      conciliated: json['conciliated'] as bool,
      due_date: json['due_date'] == null
          ? null
          : DateTime.parse(json['due_date'] as String))
    ..id = json['id'] as String;
}

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'creation_date': instance.creation_date?.toIso8601String(),
      'amount': instance.amount,
      'status': instance.status,
      'description': instance.description,
      'transaction_type': instance.transaction_type,
      'operation_type': instance.operation_type,
      'method': instance.method,
      'error_message': instance.error_message,
      'card': instance.card,
      'bank_account': instance.bank_account,
      'authorization': instance.authorization,
      'order_id': instance.order_id,
      'customer_id': instance.customer_id,
      'conciliated': instance.conciliated,
      'due_date': instance.due_date?.toIso8601String()
    };
