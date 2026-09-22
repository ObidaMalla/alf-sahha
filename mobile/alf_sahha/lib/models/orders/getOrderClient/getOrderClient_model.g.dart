// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'getOrderClient_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyOrdersModel _$MyOrdersModelFromJson(Map<String, dynamic> json) =>
    MyOrdersModel(
      success: json['success'] as bool?,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => MyOrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MyOrdersModelToJson(MyOrdersModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'statusCode': instance.statusCode,
      'message': instance.message,
      'data': instance.data,
    };

MyOrderItem _$MyOrderItemFromJson(Map<String, dynamic> json) => MyOrderItem(
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
      ?.map((e) => OrderLineItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$MyOrderItemToJson(MyOrderItem instance) =>
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

OrderLineItem _$OrderLineItemFromJson(Map<String, dynamic> json) =>
    OrderLineItem(
      id: json['id'] as String?,
      orderId: json['orderId'] as String?,
      menuItemId: json['menuItemId'] as String?,
      quantity: (json['quantity'] as num?)?.toInt(),
      unitPrice: json['unitPrice'] as String?,
      note: json['note'] as String?,
      menuItem: json['menuItem'] == null
          ? null
          : OrderMenuItemDetail.fromJson(
              json['menuItem'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$OrderLineItemToJson(OrderLineItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'menuItemId': instance.menuItemId,
      'quantity': instance.quantity,
      'unitPrice': instance.unitPrice,
      'note': instance.note,
      'menuItem': instance.menuItem,
    };

OrderMenuItemDetail _$OrderMenuItemDetailFromJson(Map<String, dynamic> json) =>
    OrderMenuItemDetail(
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

Map<String, dynamic> _$OrderMenuItemDetailToJson(
  OrderMenuItemDetail instance,
) => <String, dynamic>{
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
