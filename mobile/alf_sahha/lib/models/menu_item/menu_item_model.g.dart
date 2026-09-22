// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuItemModel _$MenuItemModelFromJson(Map<String, dynamic> json) =>
    MenuItemModel(
      success: json['success'] as bool?,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : MenuItemData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MenuItemModelToJson(MenuItemModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'statusCode': instance.statusCode,
      'message': instance.message,
      'data': instance.data,
    };

MenuItemData _$MenuItemDataFromJson(Map<String, dynamic> json) => MenuItemData(
  id: json['id'] as String?,
  restaurantId: json['restaurantId'] as String?,
  name: json['name'] as String?,
  description: json['description'] as String?,
  price: json['price'] as String?,
  category: json['category'] as String?,
  imageUrl: json['imageUrl'] as String?,
  isAvailable: json['isAvailable'] as bool?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
);

Map<String, dynamic> _$MenuItemDataToJson(MenuItemData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'restaurantId': instance.restaurantId,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'category': instance.category,
      'imageUrl': instance.imageUrl,
      'isAvailable': instance.isAvailable,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
