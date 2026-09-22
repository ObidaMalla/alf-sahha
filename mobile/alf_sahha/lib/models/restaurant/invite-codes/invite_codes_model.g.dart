// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invite_codes_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InviteCodeModel _$InviteCodeModelFromJson(Map<String, dynamic> json) =>
    InviteCodeModel(
      success: json['success'] as bool?,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : InviteCodeData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$InviteCodeModelToJson(InviteCodeModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'statusCode': instance.statusCode,
      'message': instance.message,
      'data': instance.data,
    };

InviteCodeData _$InviteCodeDataFromJson(Map<String, dynamic> json) =>
    InviteCodeData(
      id: json['id'] as String?,
      code: json['code'] as String?,
      restaurantId: json['restaurantId'] as String?,
      status: json['status'] as String?,
      expiresAt: json['expiresAt'] as String?,
      usedAt: json['usedAt'] as String?,
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$InviteCodeDataToJson(InviteCodeData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'restaurantId': instance.restaurantId,
      'status': instance.status,
      'expiresAt': instance.expiresAt,
      'usedAt': instance.usedAt,
      'createdAt': instance.createdAt,
    };
