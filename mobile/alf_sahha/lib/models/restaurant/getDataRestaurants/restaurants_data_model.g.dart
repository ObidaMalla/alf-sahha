// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurants_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestaurantsResponseModel _$RestaurantsResponseModelFromJson(
  Map<String, dynamic> json,
) => RestaurantsResponseModel(
  success: json['success'] as bool?,
  statusCode: (json['statusCode'] as num?)?.toInt(),
  message: json['message'] as String?,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => RestaurantItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$RestaurantsResponseModelToJson(
  RestaurantsResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'statusCode': instance.statusCode,
  'message': instance.message,
  'data': instance.data,
};

RestaurantItem _$RestaurantItemFromJson(Map<String, dynamic> json) =>
    RestaurantItem(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      address: json['address'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$RestaurantItemToJson(RestaurantItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'address': instance.address,
      'imageUrl': instance.imageUrl,
    };
