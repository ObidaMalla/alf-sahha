import 'package:json_annotation/json_annotation.dart';

part 'accept_order_model.g.dart';

@JsonSerializable()
class AcceptOrderModel {
  bool? success;
  int? statusCode;
  String? message;
  AcceptOrderData? data;

  AcceptOrderModel({this.success, this.statusCode, this.message, this.data});

  factory AcceptOrderModel.fromJson(Map<String, dynamic> json) =>
      _$AcceptOrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$AcceptOrderModelToJson(this);
}

@JsonSerializable()
class AcceptOrderData {
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

  AcceptOrderData({
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

  factory AcceptOrderData.fromJson(Map<String, dynamic> json) =>
      _$AcceptOrderDataFromJson(json);

  Map<String, dynamic> toJson() => _$AcceptOrderDataToJson(this);
}
