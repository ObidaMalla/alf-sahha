import 'package:json_annotation/json_annotation.dart';

part 'logout_model.g.dart';

@JsonSerializable()
class LogoutModel {
  bool? success;
  int? statusCode;
  String? message;
  dynamic data;

  LogoutModel({this.success, this.statusCode, this.message, this.data});

  factory LogoutModel.fromJson(Map<String, dynamic> json) =>
      _$LogoutModelFromJson(json);
  Map<String, dynamic> toJson() => _$LogoutModelToJson(this);
}
