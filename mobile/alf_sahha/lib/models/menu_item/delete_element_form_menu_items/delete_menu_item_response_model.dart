import 'package:json_annotation/json_annotation.dart';

part 'delete_menu_item_response_model.g.dart';

@JsonSerializable()
class DeleteMenuItemResponseModel {
  final bool? success;
  final int? statusCode;
  final String? message;
  final dynamic data;

  DeleteMenuItemResponseModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory DeleteMenuItemResponseModel.fromJson(Map<String, dynamic> json) =>
      _$DeleteMenuItemResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteMenuItemResponseModelToJson(this);
}
