import 'package:json_annotation/json_annotation.dart';

part 'notifications_model.g.dart';

@JsonSerializable()
class NotificationsListModel {
  bool? success;
  int? statusCode;
  String? message;
  List<NotificationItem>? data;

  NotificationsListModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory NotificationsListModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationsListModelFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationsListModelToJson(this);
}

@JsonSerializable()
class NotificationItem {
  String? id;
  String? userId;
  String? orderId;
  String? type;
  String? message;
  bool? isRead;
  String? createdAt;

  NotificationItem({
    this.id,
    this.userId,
    this.orderId,
    this.type,
    this.message,
    this.isRead,
    this.createdAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) =>
      _$NotificationItemFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationItemToJson(this);
}

@JsonSerializable()
class UnreadCountModel {
  bool? success;
  int? statusCode;
  String? message;
  UnreadCountData? data;

  UnreadCountModel({this.success, this.statusCode, this.message, this.data});

  factory UnreadCountModel.fromJson(Map<String, dynamic> json) =>
      _$UnreadCountModelFromJson(json);
  Map<String, dynamic> toJson() => _$UnreadCountModelToJson(this);
}

@JsonSerializable()
class UnreadCountData {
  int? unreadCount;

  UnreadCountData({this.unreadCount});

  factory UnreadCountData.fromJson(Map<String, dynamic> json) =>
      _$UnreadCountDataFromJson(json);
  Map<String, dynamic> toJson() => _$UnreadCountDataToJson(this);
}

@JsonSerializable()
class NotificationActionModel {
  bool? success;
  int? statusCode;
  String? message;
  dynamic data; // إما كائن الإشعار (mark-as-read) أو null (delete)

  NotificationActionModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory NotificationActionModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationActionModelFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationActionModelToJson(this);
}
