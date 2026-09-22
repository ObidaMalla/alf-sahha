// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_data_for_menu_items_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllMenuItemsModel _$GetAllMenuItemsModelFromJson(
  Map<String, dynamic> json,
) => GetAllMenuItemsModel(
  success: json['success'] as bool?,
  statusCode: (json['statusCode'] as num?)?.toInt(),
  message: json['message'] as String?,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => MenuItemData.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$GetAllMenuItemsModelToJson(
  GetAllMenuItemsModel instance,
) => <String, dynamic>{
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
