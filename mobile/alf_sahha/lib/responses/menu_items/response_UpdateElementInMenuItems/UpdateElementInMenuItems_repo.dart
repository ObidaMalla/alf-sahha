import '../../../models/menu_item/update_element_in_menu_items/update_element_in_menu_items_model.dart';
import '../../../routes/menu_item/menu_item_routes.dart';
import '../../apiExceptionHandler.dart';

class UpdateMenuItemRepository {
  final MenuItemService menuItemService;

  UpdateMenuItemRepository(this.menuItemService);

  Future<UpdateElementInMenuItemsModel> updateMenuItem({
    required String itemId,
    required Map<String, dynamic> body,
  }) {
    return ApiExceptionHandler.handle<UpdateElementInMenuItemsModel>(
      () => menuItemService.updateMenuItem(itemId: itemId, body: body),
      fallbackErrorMessage: 'فشلت عملية تعديل الصنف 🧨',
      isSuccess: (r) => r.success == true,
      extractMessage: (r) => r.message,
    );
  }
}
