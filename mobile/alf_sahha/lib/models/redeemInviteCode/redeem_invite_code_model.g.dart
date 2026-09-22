// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'redeem_invite_code_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RedeemInviteCodeModel _$RedeemInviteCodeModelFromJson(
  Map<String, dynamic> json,
) => RedeemInviteCodeModel(
  success: json['success'] as bool?,
  statusCode: (json['statusCode'] as num?)?.toInt(),
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : RedeemInviteCodeData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RedeemInviteCodeModelToJson(
  RedeemInviteCodeModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'statusCode': instance.statusCode,
  'message': instance.message,
  'data': instance.data,
};

RedeemInviteCodeData _$RedeemInviteCodeDataFromJson(
  Map<String, dynamic> json,
) => RedeemInviteCodeData(
  token: json['token'] as String?,
  restaurantId: json['restaurantId'] as String?,
);

Map<String, dynamic> _$RedeemInviteCodeDataToJson(
  RedeemInviteCodeData instance,
) => <String, dynamic>{
  'token': instance.token,
  'restaurantId': instance.restaurantId,
};
