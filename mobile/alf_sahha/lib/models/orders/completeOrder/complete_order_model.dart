import 'package:json_annotation/json_annotation.dart';

part 'complete_order_model.g.dart';

@JsonSerializable()
class CompleteOrderModel {
  bool? success;
  int? statusCode;
  String? message;
  CompleteOrderData? data;

  CompleteOrderModel({this.success, this.statusCode, this.message, this.data});

  factory CompleteOrderModel.fromJson(Map<String, dynamic> json) =>
      _$CompleteOrderModelFromJson(json);
  Map<String, dynamic> toJson() => _$CompleteOrderModelToJson(this);
}

@JsonSerializable()
class CompleteOrderData {
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

  CompleteOrderData({
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

  factory CompleteOrderData.fromJson(Map<String, dynamic> json) =>
      _$CompleteOrderDataFromJson(json);
  Map<String, dynamic> toJson() => _$CompleteOrderDataToJson(this);
}
