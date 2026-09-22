// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetStaffModel _$GetStaffModelFromJson(Map<String, dynamic> json) =>
    GetStaffModel(
      success: json['success'] as bool?,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => StaffData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetStaffModelToJson(GetStaffModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'statusCode': instance.statusCode,
      'message': instance.message,
      'data': instance.data,
    };

StaffData _$StaffDataFromJson(Map<String, dynamic> json) => StaffData(
  id: json['id'] as String?,
  userId: json['userId'] as String?,
  restaurantId: json['restaurantId'] as String?,
  inviteCodeId: json['inviteCodeId'] as String?,
  joinedAt: json['joinedAt'] as String?,
  user: json['user'] == null
      ? null
      : StaffUserInfo.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$StaffDataToJson(StaffData instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'restaurantId': instance.restaurantId,
  'inviteCodeId': instance.inviteCodeId,
  'joinedAt': instance.joinedAt,
  'user': instance.user,
};

StaffUserInfo _$StaffUserInfoFromJson(Map<String, dynamic> json) =>
    StaffUserInfo(
      id: json['id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$StaffUserInfoToJson(StaffUserInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'createdAt': instance.createdAt,
    };

DeleteStaffModel _$DeleteStaffModelFromJson(Map<String, dynamic> json) =>
    DeleteStaffModel(
      success: json['success'] as bool?,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      message: json['message'] as String?,
      data: json['data'],
    );

Map<String, dynamic> _$DeleteStaffModelToJson(DeleteStaffModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'statusCode': instance.statusCode,
      'message': instance.message,
      'data': instance.data,
    };
