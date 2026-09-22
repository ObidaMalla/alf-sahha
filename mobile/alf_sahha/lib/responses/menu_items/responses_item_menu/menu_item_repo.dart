import 'dart:io';

import '../../../models/menu_item/menu_item_model.dart'; // عدل المسار حسب هيكلة مشروعك
import '../../../routes/menu_item/menu_item_routes.dart';
import '../../apiExceptionHandler.dart';

class MenuItemRepository {
  final MenuItemService menuItemService;

  MenuItemRepository(this.menuItemService);

  Future<MenuItemModel> addMenuItem({
    required String restaurantId,
    required String name,
    String? description,
    required String price,
    required String category,
    File? image,
  }) {
    return ApiExceptionHandler.handle<MenuItemModel>(
      () => menuItemService.addMenuItem(
        restaurantId: restaurantId,
        name: name,
        description: description,
        price: price,
        category: category,
        image: image,
      ),
      fallbackErrorMessage: 'فشلت عملية إضافة الصنف 🧨',
      isSuccess: (r) => r.success == true,
      extractMessage: (r) => r.message,
    );
  }
}
