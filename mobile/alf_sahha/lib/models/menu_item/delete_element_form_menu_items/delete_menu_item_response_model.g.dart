// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_menu_item_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteMenuItemResponseModel _$DeleteMenuItemResponseModelFromJson(
  Map<String, dynamic> json,
) => DeleteMenuItemResponseModel(
  success: json['success'] as bool?,
  statusCode: (json['statusCode'] as num?)?.toInt(),
  message: json['message'] as String?,
  data: json['data'],
);

Map<String, dynamic> _$DeleteMenuItemResponseModelToJson(
  DeleteMenuItemResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'statusCode': instance.statusCode,
  'message': instance.message,
  'data': instance.data,
};
