// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletModel _$WalletModelFromJson(Map<String, dynamic> json) => WalletModel(
  success: json['success'] as bool?,
  statusCode: (json['statusCode'] as num?)?.toInt(),
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : WalletData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$WalletModelToJson(WalletModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'statusCode': instance.statusCode,
      'message': instance.message,
      'data': instance.data,
    };

WalletData _$WalletDataFromJson(Map<String, dynamic> json) => WalletData(
  balance: json['balance'] as String?,
  transactions: (json['transactions'] as List<dynamic>?)
      ?.map((e) => WalletTransaction.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$WalletDataToJson(WalletData instance) =>
    <String, dynamic>{
      'balance': instance.balance,
      'transactions': instance.transactions,
    };

WalletTransaction _$WalletTransactionFromJson(Map<String, dynamic> json) =>
    WalletTransaction(
      id: json['id'] as String?,
      orderId: json['orderId'] as String?,
      fromUserId: json['fromUserId'] as String?,
      toUserId: json['toUserId'] as String?,
      amount: json['amount'] as String?,
      type: json['type'] as String?,
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$WalletTransactionToJson(WalletTransaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'fromUserId': instance.fromUserId,
      'toUserId': instance.toUserId,
      'amount': instance.amount,
      'type': instance.type,
      'createdAt': instance.createdAt,
    };
