import 'package:json_annotation/json_annotation.dart';

part 'menu_item_model.g.dart';

@JsonSerializable()
class MenuItemModel {
  bool? success;
  int? statusCode;
  String? message;
  MenuItemData? data;

  MenuItemModel({this.success, this.statusCode, this.message, this.data});

  factory MenuItemModel.fromJson(Map<String, dynamic> json) =>
      _$MenuItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$MenuItemModelToJson(this);
}

@JsonSerializable()
class MenuItemData {
  String? id;
  String? restaurantId;
  String? name;
  String? description;
  String? price;
  String? category;
  String? imageUrl;
  bool? isAvailable;
  String? createdAt;
  String? updatedAt;

  MenuItemData({
    this.id,
    this.restaurantId,
    this.name,
    this.description,
    this.price,
    this.category,
    this.imageUrl,
    this.isAvailable,
    this.createdAt,
    this.updatedAt,
  });

  factory MenuItemData.fromJson(Map<String, dynamic> json) =>
      _$MenuItemDataFromJson(json);

  Map<String, dynamic> toJson() => _$MenuItemDataToJson(this);
}
