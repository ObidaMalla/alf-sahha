import 'package:json_annotation/json_annotation.dart';

part 'get_all_orders_model.g.dart';

@JsonSerializable()
class GetAllOrdersModel {
  bool? success;
  int? statusCode;
  String? message;
  List<OrderModel>? data;

  GetAllOrdersModel({this.success, this.statusCode, this.message, this.data});

  factory GetAllOrdersModel.fromJson(Map<String, dynamic> json) =>
      _$GetAllOrdersModelFromJson(json);
  Map<String, dynamic> toJson() => _$GetAllOrdersModelToJson(this);
}

@JsonSerializable()
class OrderModel {
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
  List<OrderItemModel>? items;

  OrderModel({
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

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderModelToJson(this);
}

@JsonSerializable()
class OrderItemModel {
  String? id;
  String? orderId;
  String? menuItemId;
  int? quantity;
  String? unitPrice;
  String? note;
  OrderItemMenuModel? menuItem;

  OrderItemModel({
    this.id,
    this.orderId,
    this.menuItemId,
    this.quantity,
    this.unitPrice,
    this.note,
    this.menuItem,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderItemModelToJson(this);
}

@JsonSerializable()
class OrderItemMenuModel {
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

  OrderItemMenuModel({
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

  factory OrderItemMenuModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemMenuModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderItemMenuModelToJson(this);
}
