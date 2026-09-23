import 'package:json_annotation/json_annotation.dart';

part 'wallet_model.g.dart';

@JsonSerializable()
class WalletModel {
  bool? success;
  int? statusCode;
  String? message;
  WalletData? data;

  WalletModel({this.success, this.statusCode, this.message, this.data});

  factory WalletModel.fromJson(Map<String, dynamic> json) =>
      _$WalletModelFromJson(json);
  Map<String, dynamic> toJson() => _$WalletModelToJson(this);
}

@JsonSerializable()
class WalletData {
  String? balance;
  List<WalletTransaction>? transactions;

  WalletData({this.balance, this.transactions});

  factory WalletData.fromJson(Map<String, dynamic> json) =>
      _$WalletDataFromJson(json);
  Map<String, dynamic> toJson() => _$WalletDataToJson(this);
}

@JsonSerializable()
class WalletTransaction {
  String? id;
  String? orderId;
  String? fromUserId;
  String? toUserId;
  String? amount;
  String? type;
  String? createdAt;
  String? direction;

  String? signedAmount;

  WalletTransaction({
    this.id,
    this.orderId,
    this.fromUserId,
    this.toUserId,
    this.amount,
    this.type,
    this.createdAt,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) =>
      _$WalletTransactionFromJson(json);
  Map<String, dynamic> toJson() => _$WalletTransactionToJson(this);
}
