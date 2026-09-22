import 'package:json_annotation/json_annotation.dart';

part 'all_data_for_menu_items_model.g.dart';

@JsonSerializable()
class GetAllMenuItemsModel {
  bool? success;
  int? statusCode;
  String? message;
  List<MenuItemData>? data;

  GetAllMenuItemsModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory GetAllMenuItemsModel.fromJson(Map<String, dynamic> json) =>
      _$GetAllMenuItemsModelFromJson(json);

  Map<String, dynamic> toJson() => _$GetAllMenuItemsModelToJson(this);
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
