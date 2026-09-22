import 'package:json_annotation/json_annotation.dart';

part 'create_order_model.g.dart';

@JsonSerializable()
class CreateOrderModel {
  bool? success;
  int? statusCode;
  String? message;
  OrderData? data;

  CreateOrderModel({this.success, this.statusCode, this.message, this.data});

  factory CreateOrderModel.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderModelFromJson(json);
  Map<String, dynamic> toJson() => _$CreateOrderModelToJson(this);
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
    this.items,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) =>
      _$OrderDataFromJson(json);
  Map<String, dynamic> toJson() => _$OrderDataToJson(this);
}

@JsonSerializable()
class OrderItemData {
  String? id;
  String? orderId;
  String? menuItemId;
  int? quantity;
  String? unitPrice;
  String? note;

  OrderItemData({
    this.id,
    this.orderId,
    this.menuItemId,
    this.quantity,
    this.unitPrice,
    this.note,
  });

  factory OrderItemData.fromJson(Map<String, dynamic> json) =>
      _$OrderItemDataFromJson(json);
  Map<String, dynamic> toJson() => _$OrderItemDataToJson(this);
}
