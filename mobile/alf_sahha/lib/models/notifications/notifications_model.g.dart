// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationsListModel _$NotificationsListModelFromJson(
  Map<String, dynamic> json,
) => NotificationsListModel(
  success: json['success'] as bool?,
  statusCode: (json['statusCode'] as num?)?.toInt(),
  message: json['message'] as String?,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => NotificationItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$NotificationsListModelToJson(
  NotificationsListModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'statusCode': instance.statusCode,
  'message': instance.message,
  'data': instance.data,
};

NotificationItem _$NotificationItemFromJson(Map<String, dynamic> json) =>
    NotificationItem(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      orderId: json['orderId'] as String?,
      type: json['type'] as String?,
      message: json['message'] as String?,
      isRead: json['isRead'] as bool?,
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$NotificationItemToJson(NotificationItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'orderId': instance.orderId,
      'type': instance.type,
      'message': instance.message,
      'isRead': instance.isRead,
      'createdAt': instance.createdAt,
    };

UnreadCountModel _$UnreadCountModelFromJson(Map<String, dynamic> json) =>
    UnreadCountModel(
      success: json['success'] as bool?,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : UnreadCountData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UnreadCountModelToJson(UnreadCountModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'statusCode': instance.statusCode,
      'message': instance.message,
      'data': instance.data,
    };

UnreadCountData _$UnreadCountDataFromJson(Map<String, dynamic> json) =>
    UnreadCountData(unreadCount: (json['unreadCount'] as num?)?.toInt());

Map<String, dynamic> _$UnreadCountDataToJson(UnreadCountData instance) =>
    <String, dynamic>{'unreadCount': instance.unreadCount};

NotificationActionModel _$NotificationActionModelFromJson(
  Map<String, dynamic> json,
) => NotificationActionModel(
  success: json['success'] as bool?,
  statusCode: (json['statusCode'] as num?)?.toInt(),
  message: json['message'] as String?,
  data: json['data'],
);

Map<String, dynamic> _$NotificationActionModelToJson(
  NotificationActionModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'statusCode': instance.statusCode,
  'message': instance.message,
  'data': instance.data,
};
