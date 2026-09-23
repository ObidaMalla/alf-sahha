import 'package:json_annotation/json_annotation.dart';

part 'restaurant_stats_model.g.dart';

@JsonSerializable()
class RestaurantStatsModel {
  bool? success;
  int? statusCode;
  String? message;
  RestaurantStatsData? data;

  RestaurantStatsModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory RestaurantStatsModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantStatsModelFromJson(json);
  Map<String, dynamic> toJson() => _$RestaurantStatsModelToJson(this);
}

@JsonSerializable()
class RestaurantStatsData {
  OrdersByStatus? ordersByStatus;
  int? totalOrders;
  num? totalRevenue; // <-- بدل String?

  RestaurantStatsData({
    this.ordersByStatus,
    this.totalOrders,
    this.totalRevenue,
  });

  factory RestaurantStatsData.fromJson(Map<String, dynamic> json) =>
      _$RestaurantStatsDataFromJson(json);
  Map<String, dynamic> toJson() => _$RestaurantStatsDataToJson(this);
}

@JsonSerializable()
class OrdersByStatus {
  int? PENDING;
  int? ACCEPTED;
  int? PREPARING;
  int? COMPLETED;
  int? REJECTED;
  int? EXPIRED;

  OrdersByStatus({
    this.PENDING,
    this.ACCEPTED,
    this.PREPARING,
    this.COMPLETED,
    this.REJECTED,
    this.EXPIRED,
  });

  factory OrdersByStatus.fromJson(Map<String, dynamic> json) =>
      _$OrdersByStatusFromJson(json);
  Map<String, dynamic> toJson() => _$OrdersByStatusToJson(this);
}
