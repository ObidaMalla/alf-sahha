import 'package:json_annotation/json_annotation.dart';

part 'restaurants_data_model.g.dart';

@JsonSerializable()
class RestaurantsResponseModel {
  bool? success;
  int? statusCode;
  String? message;
  List<RestaurantItem>? data;

  RestaurantsResponseModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory RestaurantsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantsResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$RestaurantsResponseModelToJson(this);
}

@JsonSerializable()
class RestaurantItem {
  String? id;
  String? name;
  String? description;
  String? address;
  String? imageUrl;

  RestaurantItem({
    this.id,
    this.name,
    this.description,
    this.address,
    this.imageUrl,
  });

  factory RestaurantItem.fromJson(Map<String, dynamic> json) =>
      _$RestaurantItemFromJson(json);
  Map<String, dynamic> toJson() => _$RestaurantItemToJson(this);
}
