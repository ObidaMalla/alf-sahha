import 'package:json_annotation/json_annotation.dart';

part 'create_restaurant_model.g.dart';

@JsonSerializable()
class CreateRestaurantModel {
  bool? success;
  int? statusCode;
  String? message;
  CreateRestaurantData? data;

  CreateRestaurantModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory CreateRestaurantModel.fromJson(Map<String, dynamic> json) =>
      _$CreateRestaurantModelFromJson(json);
  Map<String, dynamic> toJson() => _$CreateRestaurantModelToJson(this);
}

@JsonSerializable()
class CreateRestaurantData {
  RestaurantModel? restaurant;
  String? token;

  CreateRestaurantData({this.restaurant, this.token});

  factory CreateRestaurantData.fromJson(Map<String, dynamic> json) =>
      _$CreateRestaurantDataFromJson(json);
  Map<String, dynamic> toJson() => _$CreateRestaurantDataToJson(this);
}

@JsonSerializable()
class RestaurantModel {
  String? id;
  String? ownerId;
  String? name;
  String? description;
  String? address;
  String? imageUrl;
  String? createdAt;
  String? updatedAt;

  RestaurantModel({
    this.id,
    this.ownerId,
    this.name,
    this.description,
    this.address,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantModelFromJson(json);
  Map<String, dynamic> toJson() => _$RestaurantModelToJson(this);
}
