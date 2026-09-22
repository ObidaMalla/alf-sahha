import 'package:json_annotation/json_annotation.dart';

import '../create_order/create_order_model.dart';

part 'pay_order_model.g.dart';

@JsonSerializable()
class PayOrderModel {
  bool? success;
  int? statusCode;
  String? message;
  OrderData? data;

  PayOrderModel({this.success, this.statusCode, this.message, this.data});

  factory PayOrderModel.fromJson(Map<String, dynamic> json) =>
      _$PayOrderModelFromJson(json);
  Map<String, dynamic> toJson() => _$PayOrderModelToJson(this);
}

@JsonSerializable()
class OrderData {
  String? id;
  String? customerId;
  String? restaurantId;
  String? handledByUserId;
  String? status;
  String? rejectionReason;
  String? totalPrice;
  String? acceptedAt;
  String? paidAt;
  String? completedAt;
  String? rejectedAt;
  String? expiredAt;
  String? createdAt;
  String? updatedAt;
  List<OrderItemData>? items;

  OrderData({
    this.id,
    this.customerId,
    this.restaurantId,
    this.handledByUserId,
    this.status,
    this.rejectionReason,
    this.totalPrice,
    this.acceptedAt,
    this.paidAt,
    this.completedAt,
    this.rejectedAt,
    this.expiredAt,
    this.createdAt,
    this.updatedAt,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) =>
      _$OrderDataFromJson(json);
  Map<String, dynamic> toJson() => _$OrderDataToJson(this);
}
