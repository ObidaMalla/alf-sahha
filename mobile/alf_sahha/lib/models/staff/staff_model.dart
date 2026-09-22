import 'package:json_annotation/json_annotation.dart';

part 'staff_model.g.dart';

@JsonSerializable()
class GetStaffModel {
  bool? success;
  int? statusCode;
  String? message;
  List<StaffData>? data;

  GetStaffModel({this.success, this.statusCode, this.message, this.data});

  factory GetStaffModel.fromJson(Map<String, dynamic> json) =>
      _$GetStaffModelFromJson(json);
  Map<String, dynamic> toJson() => _$GetStaffModelToJson(this);
}

@JsonSerializable()
class StaffData {
  String? id;
  String? userId;
  String? restaurantId;
  String? inviteCodeId;
  String? joinedAt;
  StaffUserInfo? user;

  StaffData({
    this.id,
    this.userId,
    this.restaurantId,
    this.inviteCodeId,
    this.joinedAt,
    this.user,
  });

  factory StaffData.fromJson(Map<String, dynamic> json) =>
      _$StaffDataFromJson(json);
  Map<String, dynamic> toJson() => _$StaffDataToJson(this);
}

@JsonSerializable()
class StaffUserInfo {
  String? id;
  String? name;
  String? email;
  String? createdAt;

  StaffUserInfo({this.id, this.name, this.email, this.createdAt});

  factory StaffUserInfo.fromJson(Map<String, dynamic> json) =>
      _$StaffUserInfoFromJson(json);
  Map<String, dynamic> toJson() => _$StaffUserInfoToJson(this);
}

@JsonSerializable()
class DeleteStaffModel {
  bool? success;
  int? statusCode;
  String? message;
  dynamic data;

  DeleteStaffModel({this.success, this.statusCode, this.message, this.data});

  factory DeleteStaffModel.fromJson(Map<String, dynamic> json) =>
      _$DeleteStaffModelFromJson(json);
  Map<String, dynamic> toJson() => _$DeleteStaffModelToJson(this);
}
