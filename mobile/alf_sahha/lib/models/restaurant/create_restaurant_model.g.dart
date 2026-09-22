// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_restaurant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateRestaurantModel _$CreateRestaurantModelFromJson(
  Map<String, dynamic> json,
) => CreateRestaurantModel(
  success: json['success'] as bool?,
  statusCode: (json['statusCode'] as num?)?.toInt(),
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : CreateRestaurantData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CreateRestaurantModelToJson(
  CreateRestaurantModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'statusCode': instance.statusCode,
  'message': instance.message,
  'data': instance.data,
};

CreateRestaurantData _$CreateRestaurantDataFromJson(
  Map<String, dynamic> json,
) => CreateRestaurantData(
  restaurant: json['restaurant'] == null
      ? null
      : RestaurantModel.fromJson(json['restaurant'] as Map<String, dynamic>),
  token: json['token'] as String?,
);

Map<String, dynamic> _$CreateRestaurantDataToJson(
  CreateRestaurantData instance,
) => <String, dynamic>{
  'restaurant': instance.restaurant,
  'token': instance.token,
};

RestaurantModel _$RestaurantModelFromJson(Map<String, dynamic> json) =>
    RestaurantModel(
      id: json['id'] as String?,
      ownerId: json['ownerId'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      address: json['address'] as String?,
      imageUrl: json['imageUrl'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$RestaurantModelToJson(RestaurantModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ownerId': instance.ownerId,
      'name': instance.name,
      'description': instance.description,
      'address': instance.address,
      'imageUrl': instance.imageUrl,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
