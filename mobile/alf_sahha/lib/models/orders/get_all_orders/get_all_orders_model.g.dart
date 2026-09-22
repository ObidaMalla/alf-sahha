// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_orders_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllOrdersModel _$GetAllOrdersModelFromJson(Map<String, dynamic> json) =>
    GetAllOrdersModel(
      success: json['success'] as bool?,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetAllOrdersModelToJson(GetAllOrdersModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'statusCode': instance.statusCode,
      'message': instance.message,
      'data': instance.data,
    };

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
  id: json['id'] as String?,
  customerId: json['customerId'] as String?,
  restaurantId: json['restaurantId'] as String?,
  handledByUserId: json['handledByUserId'] as String?,
  status: json['status'] as String?,
  rejectionReason: json['rejectionReason'] as String?,
  totalPrice: json['totalPrice'] as String?,
  acceptedAt: json['acceptedAt'] as String?,
  paidAt: json['paidAt'] as String?,
  completedAt: json['completedAt'] as String?,
  rejectedAt: json['rejectedAt'] as String?,
  expiredAt: json['expiredAt'] as String?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
  items: (json['items'] as List<dynamic>?)
      ?.map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customerId': instance.customerId,
      'restaurantId': instance.restaurantId,
      'handledByUserId': instance.handledByUserId,
      'status': instance.status,
      'rejectionReason': instance.rejectionReason,
      'totalPrice': instance.totalPrice,
      'acceptedAt': instance.acceptedAt,
      'paidAt': instance.paidAt,
      'completedAt': instance.completedAt,
      'rejectedAt': instance.rejectedAt,
      'expiredAt': instance.expiredAt,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'items': instance.items,
    };

OrderItemModel _$OrderItemModelFromJson(Map<String, dynamic> json) =>
    OrderItemModel(
      id: json['id'] as String?,
      orderId: json['orderId'] as String?,
      menuItemId: json['menuItemId'] as String?,
      quantity: (json['quantity'] as num?)?.toInt(),
      unitPrice: json['unitPrice'] as String?,
      note: json['note'] as String?,
      menuItem: json['menuItem'] == null
          ? null
          : OrderItemMenuModel.fromJson(
              json['menuItem'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$OrderItemModelToJson(OrderItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'menuItemId': instance.menuItemId,
      'quantity': instance.quantity,
      'unitPrice': instance.unitPrice,
      'note': instance.note,
      'menuItem': instance.menuItem,
    };

OrderItemMenuModel _$OrderItemMenuModelFromJson(Map<String, dynamic> json) =>
    OrderItemMenuModel(
      id: json['id'] as String?,
      restaurantId: json['restaurantId'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      price: json['price'] as String?,
      category: json['category'] as String?,
      imageUrl: json['imageUrl'] as String?,
      isAvailable: json['isAvailable'] as bool?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$OrderItemMenuModelToJson(OrderItemMenuModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'restaurantId': instance.restaurantId,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'category': instance.category,
      'imageUrl': instance.imageUrl,
      'isAvailable': instance.isAvailable,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
