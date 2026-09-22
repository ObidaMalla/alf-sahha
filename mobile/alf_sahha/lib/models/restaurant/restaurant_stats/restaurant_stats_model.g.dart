// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestaurantStatsModel _$RestaurantStatsModelFromJson(
  Map<String, dynamic> json,
) => RestaurantStatsModel(
  success: json['success'] as bool?,
  statusCode: (json['statusCode'] as num?)?.toInt(),
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : RestaurantStatsData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RestaurantStatsModelToJson(
  RestaurantStatsModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'statusCode': instance.statusCode,
  'message': instance.message,
  'data': instance.data,
};

RestaurantStatsData _$RestaurantStatsDataFromJson(Map<String, dynamic> json) =>
    RestaurantStatsData(
      ordersByStatus: json['ordersByStatus'] == null
          ? null
          : OrdersByStatus.fromJson(
              json['ordersByStatus'] as Map<String, dynamic>,
            ),
      totalOrders: (json['totalOrders'] as num?)?.toInt(),
      totalRevenue: json['totalRevenue'] as String?,
    );

Map<String, dynamic> _$RestaurantStatsDataToJson(
  RestaurantStatsData instance,
) => <String, dynamic>{
  'ordersByStatus': instance.ordersByStatus,
  'totalOrders': instance.totalOrders,
  'totalRevenue': instance.totalRevenue,
};

OrdersByStatus _$OrdersByStatusFromJson(Map<String, dynamic> json) =>
    OrdersByStatus(
      PENDING: (json['PENDING'] as num?)?.toInt(),
      ACCEPTED: (json['ACCEPTED'] as num?)?.toInt(),
      PREPARING: (json['PREPARING'] as num?)?.toInt(),
      COMPLETED: (json['COMPLETED'] as num?)?.toInt(),
      REJECTED: (json['REJECTED'] as num?)?.toInt(),
      EXPIRED: (json['EXPIRED'] as num?)?.toInt(),
    );

Map<String, dynamic> _$OrdersByStatusToJson(OrdersByStatus instance) =>
    <String, dynamic>{
      'PENDING': instance.PENDING,
      'ACCEPTED': instance.ACCEPTED,
      'PREPARING': instance.PREPARING,
      'COMPLETED': instance.COMPLETED,
      'REJECTED': instance.REJECTED,
      'EXPIRED': instance.EXPIRED,
    };
