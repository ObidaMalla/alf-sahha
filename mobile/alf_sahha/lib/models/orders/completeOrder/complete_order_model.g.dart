// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complete_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompleteOrderModel _$CompleteOrderModelFromJson(Map<String, dynamic> json) =>
    CompleteOrderModel(
      success: json['success'] as bool?,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : CompleteOrderData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CompleteOrderModelToJson(CompleteOrderModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'statusCode': instance.statusCode,
      'message': instance.message,
      'data': instance.data,
    };

CompleteOrderData _$CompleteOrderDataFromJson(Map<String, dynamic> json) =>
    CompleteOrderData(
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
    );

Map<String, dynamic> _$CompleteOrderDataToJson(CompleteOrderData instance) =>
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
    };
