import '../../../models/menu_item/all_data_for_menu/all_data_for_menu_items_model.dart';
import '../../../routes/menu_item/menu_item_routes.dart';
import '../../apiExceptionHandler.dart';

class GetMenuItemsRepository {
  final MenuItemService menuItemService;

  GetMenuItemsRepository(this.menuItemService);

  Future<GetAllMenuItemsModel> getMenuItems({required String restaurantId}) {
    return ApiExceptionHandler.handle<GetAllMenuItemsModel>(
      () => menuItemService.getMenuItems(restaurantId: restaurantId),
      fallbackErrorMessage: 'فشلت عملية جلب المنيو 🧨',
      isSuccess: (r) => r.success == true,
      extractMessage: (r) => r.message,
    );
  }
}
