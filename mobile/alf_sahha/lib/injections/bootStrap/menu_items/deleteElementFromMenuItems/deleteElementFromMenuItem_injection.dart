import 'package:get_it/get_it.dart';

import '../../../../cubits/menu_items/deleteElementFromMenuItemsCubit/deleteElementFromMenuItems_cubit.dart';
import '../../../../responses/menu_items/response_deleteElementFromMenuItems/deleteElementFromMenuItems_repo.dart';
import '../../../../routes/menu_item/menu_item_routes.dart';
import '../../../dio_config.dart';

final getIt = GetIt.instance;

void initGetItDeleteMenuItem() {
  // 1. تسجيل الـ Service (مشتركة لجميع عمليات المنيو)
  if (!getIt.isRegistered<MenuItemService>()) {
    getIt.registerLazySingleton<MenuItemService>(
      () => MenuItemService(createAndSetupDio()),
    );
  }
  // 3. تسجيل الـ Repository والـ Cubit الخاصين بالحذف (تمت إضافتها هنا)
  if (!getIt.isRegistered<DeleteElementFromMenuItemRepository>()) {
    getIt.registerLazySingleton<DeleteElementFromMenuItemRepository>(
      () => DeleteElementFromMenuItemRepository(getIt<MenuItemService>()),
    );
  }
  if (!getIt.isRegistered<DeleteMenuItemCubit>()) {
    getIt.registerFactory<DeleteMenuItemCubit>(
      () => DeleteMenuItemCubit(getIt<DeleteElementFromMenuItemRepository>()),
    );
  }
}
