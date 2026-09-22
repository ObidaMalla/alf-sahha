// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateOrderModel _$CreateOrderModelFromJson(Map<String, dynamic> json) =>
    CreateOrderModel(
      success: json['success'] as bool?,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : OrderData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateOrderModelToJson(CreateOrderModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'statusCode': instance.statusCode,
      'message': instance.message,
      'data': instance.data,
    };

OrderData _$OrderDataFromJson(Map<String, dynamic> json) => OrderData(
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
      ?.map((e) => OrderItemData.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$OrderDataToJson(OrderData instance) => <String, dynamic>{
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

OrderItemData _$OrderItemDataFromJson(Map<String, dynamic> json) =>
    OrderItemData(
      id: json['id'] as String?,
      orderId: json['orderId'] as String?,
      menuItemId: json['menuItemId'] as String?,
      quantity: (json['quantity'] as num?)?.toInt(),
      unitPrice: json['unitPrice'] as String?,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$OrderItemDataToJson(OrderItemData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'menuItemId': instance.menuItemId,
      'quantity': instance.quantity,
      'unitPrice': instance.unitPrice,
      'note': instance.note,
    };
