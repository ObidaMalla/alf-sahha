import 'package:json_annotation/json_annotation.dart';

part 'redeem_invite_code_model.g.dart';

@JsonSerializable()
class RedeemInviteCodeModel {
  bool? success;
  int? statusCode;
  String? message;
  RedeemInviteCodeData? data;

  RedeemInviteCodeModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory RedeemInviteCodeModel.fromJson(Map<String, dynamic> json) =>
      _$RedeemInviteCodeModelFromJson(json);
  Map<String, dynamic> toJson() => _$RedeemInviteCodeModelToJson(this);
}

@JsonSerializable()
class RedeemInviteCodeData {
  String? token;
  String? restaurantId;

  RedeemInviteCodeData({this.token, this.restaurantId});

  factory RedeemInviteCodeData.fromJson(Map<String, dynamic> json) =>
      _$RedeemInviteCodeDataFromJson(json);
  Map<String, dynamic> toJson() => _$RedeemInviteCodeDataToJson(this);
}
