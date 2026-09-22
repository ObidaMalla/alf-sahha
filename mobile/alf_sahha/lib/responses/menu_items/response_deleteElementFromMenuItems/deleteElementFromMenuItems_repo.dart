import '../../../models/menu_item/delete_element_form_menu_items/delete_menu_item_response_model.dart';
import '../../../routes/menu_item/menu_item_routes.dart';
import '../../apiExceptionHandler.dart';

class DeleteElementFromMenuItemRepository {
  final MenuItemService menuItemService;

  DeleteElementFromMenuItemRepository(this.menuItemService);

  Future<DeleteMenuItemResponseModel> deleteMenuItem({required String itemId}) {
    return ApiExceptionHandler.handle<DeleteMenuItemResponseModel>(
      () => menuItemService.deleteMenuItem(itemId: itemId),
      fallbackErrorMessage: 'فشلت عملية حذف الصنف 🧨',
      isSuccess: (r) => r.success == true,
      extractMessage: (r) => r.message,
    );
  }
}
