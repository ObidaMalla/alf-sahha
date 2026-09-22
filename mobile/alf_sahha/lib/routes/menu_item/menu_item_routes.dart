import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../core/constants/api_constants.dart';
import '../../models/menu_item/all_data_for_menu/all_data_for_menu_items_model.dart';
import '../../models/menu_item/delete_element_form_menu_items/delete_menu_item_response_model.dart';
import '../../models/menu_item/menu_item_model.dart';
import '../../models/menu_item/update_element_in_menu_items/update_element_in_menu_items_model.dart';

part 'menu_item_routes.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class MenuItemService {
  factory MenuItemService(Dio dio, {String baseUrl}) = _MenuItemService;

  @POST('/restaurants/{restaurantId}/menu-items')
  @MultiPart()
  Future<MenuItemModel> addMenuItem({
    @Path('restaurantId') required String restaurantId,
    @Part(name: 'name') required String name,
    @Part(name: 'description') String? description,
    @Part(name: 'price') required String price,
    @Part(name: 'category') required String category,
    @Part(name: 'image') File? image,
  });

  // جلب كل أصناف المنيو
  @GET('/restaurants/{restaurantId}/menu-items')
  Future<GetAllMenuItemsModel> getMenuItems({
    @Path('restaurantId') required String restaurantId,
  });

  // تعديل صنف
  @PATCH('/menu-items/{itemId}')
  Future<UpdateElementInMenuItemsModel> updateMenuItem({
    @Path('itemId') required String itemId,
    @Body() required Map<String, dynamic> body,
  });

  // حذف صنف
  @DELETE('/menu-items/{itemId}')
  Future<DeleteMenuItemResponseModel> deleteMenuItem({
    @Path('itemId') required String itemId,
  });
}
