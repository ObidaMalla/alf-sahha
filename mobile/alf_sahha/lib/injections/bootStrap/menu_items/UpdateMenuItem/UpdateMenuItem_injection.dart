import 'package:get_it/get_it.dart';

import '../../../../cubits/menu_items/updateMenuItemCubit/updateMenuItem_cubit.dart';
import '../../../../responses/menu_items/response_UpdateElementInMenuItems/UpdateElementInMenuItems_repo.dart';
import '../../../../routes/menu_item/menu_item_routes.dart';
import '../../../dio_config.dart';

final getIt = GetIt.instance;

void initGetItUpdateMenuItem() {
  if (!getIt.isRegistered<UpdateMenuItemCubit>()) {
    getIt.registerFactory<UpdateMenuItemCubit>(
          () => UpdateMenuItemCubit(getIt<UpdateMenuItemRepository>()),
    );
  }
  if (!getIt.isRegistered<UpdateMenuItemRepository>()) {
    getIt.registerLazySingleton<UpdateMenuItemRepository>(
          () => UpdateMenuItemRepository(getIt<MenuItemService>()),
    );
  }
  if (!getIt.isRegistered<MenuItemService>()) {
    getIt.registerLazySingleton<MenuItemService>(
          () => MenuItemService(createAndSetupDio()),
    );
  }
}