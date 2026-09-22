import 'package:json_annotation/json_annotation.dart';

part 'reject_order_model.g.dart';

@JsonSerializable()
class RejectOrderModel {
  bool? success;
  int? statusCode;
  String? message;
  RejectOrderData? data;

  RejectOrderModel({this.success, this.statusCode, this.message, this.data});

  factory RejectOrderModel.fromJson(Map<String, dynamic> json) =>
      _$RejectOrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$RejectOrderModelToJson(this);
}

@JsonSerializable()
class RejectOrderData {
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

  RejectOrderData({
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

  factory RejectOrderData.fromJson(Map<String, dynamic> json) =>
      _$RejectOrderDataFromJson(json);

  Map<String, dynamic> toJson() => _$RejectOrderDataToJson(this);
}
