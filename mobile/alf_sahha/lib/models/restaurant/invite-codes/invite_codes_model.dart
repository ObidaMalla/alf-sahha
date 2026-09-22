import 'package:json_annotation/json_annotation.dart';

part 'invite_codes_model.g.dart';

@JsonSerializable()
class InviteCodeModel {
  bool? success;
  int? statusCode;
  String? message;
  InviteCodeData? data;

  InviteCodeModel({this.success, this.statusCode, this.message, this.data});

  factory InviteCodeModel.fromJson(Map<String, dynamic> json) =>
      _$InviteCodeModelFromJson(json);

  Map<String, dynamic> toJson() => _$InviteCodeModelToJson(this);
}

@JsonSerializable()
class InviteCodeData {
  String? id;
  String? code;
  String? restaurantId;
  String? status;
  String? expiresAt;
  String? usedAt;
  String? createdAt;

  InviteCodeData({
    this.id,
    this.code,
    this.restaurantId,
    this.status,
    this.expiresAt,
    this.usedAt,
    this.createdAt,
  });

  factory InviteCodeData.fromJson(Map<String, dynamic> json) =>
      _$InviteCodeDataFromJson(json);

  Map<String, dynamic> toJson() => _$InviteCodeDataToJson(this);
}
