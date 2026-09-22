import 'package:json_annotation/json_annotation.dart';

part 'update_element_in_menu_items_model.g.dart';

@JsonSerializable()
class UpdateElementInMenuItemsModel {
  bool? success;
  int? statusCode;
  String? message;
  DataUpdateElementInMenuItemsModel? data;

  UpdateElementInMenuItemsModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory UpdateElementInMenuItemsModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateElementInMenuItemsModelFromJson(
        json,
      ); // تم تصحيح اسم الدالة هنا لتتطابق مع اسم الكلاس

  Map<String, dynamic> toJson() => _$UpdateElementInMenuItemsModelToJson(this);
}

@JsonSerializable()
class DataUpdateElementInMenuItemsModel {
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

  DataUpdateElementInMenuItemsModel({
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

  factory DataUpdateElementInMenuItemsModel.fromJson(
    Map<String, dynamic> json,
  ) => _$DataUpdateElementInMenuItemsModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$DataUpdateElementInMenuItemsModelToJson(this);
}
