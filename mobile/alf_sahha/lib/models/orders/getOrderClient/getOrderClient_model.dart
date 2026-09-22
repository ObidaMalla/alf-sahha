import 'package:json_annotation/json_annotation.dart';

part 'getOrderClient_model.g.dart';

@JsonSerializable()
class MyOrdersModel {
  bool? success;
  int? statusCode;
  String? message;
  List<MyOrderItem>? data;

  MyOrdersModel({this.success, this.statusCode, this.message, this.data});

  factory MyOrdersModel.fromJson(Map<String, dynamic> json) =>
      _$MyOrdersModelFromJson(json);
  Map<String, dynamic> toJson() => _$MyOrdersModelToJson(this);
}

@JsonSerializable()
class MyOrderItem {
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
  List<OrderLineItem>? items;

  MyOrderItem({
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

  factory MyOrderItem.fromJson(Map<String, dynamic> json) =>
      _$MyOrderItemFromJson(json);
  Map<String, dynamic> toJson() => _$MyOrderItemToJson(this);
}

@JsonSerializable()
class OrderLineItem {
  String? id;
  String? orderId;
  String? menuItemId;
  int? quantity;
  String? unitPrice;
  String? note;
  OrderMenuItemDetail? menuItem;

  OrderLineItem({
    this.id,
    this.orderId,
    this.menuItemId,
    this.quantity,
    this.unitPrice,
    this.note,
    this.menuItem,
  });

  factory OrderLineItem.fromJson(Map<String, dynamic> json) =>
      _$OrderLineItemFromJson(json);
  Map<String, dynamic> toJson() => _$OrderLineItemToJson(this);
}

@JsonSerializable()
class OrderMenuItemDetail {
  String? id;
  String? restaurantId;
  String? name;
  String? description;
  String? price;
  String? category;
  String? imageUrl;
  bool? isAvailable;
  String? createdAt;
  String? updatedAt;

  OrderMenuItemDetail({
    this.id,
    this.restaurantId,
    this.name,
    this.description,
    this.price,
    this.category,
    this.imageUrl,
    this.isAvailable,
    this.createdAt,
    this.updatedAt,
  });

  factory OrderMenuItemDetail.fromJson(Map<String, dynamic> json) =>
      _$OrderMenuItemDetailFromJson(json);
  Map<String, dynamic> toJson() => _$OrderMenuItemDetailToJson(this);
}
