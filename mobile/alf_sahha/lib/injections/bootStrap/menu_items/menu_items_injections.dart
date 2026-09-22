import 'package:get_it/get_it.dart';

import '../../../cubits/menu_items/menu_itemsCubit/menu_items_cubit.dart';
import '../../../responses/menu_items/responses_item_menu/menu_item_repo.dart';
import '../../../routes/menu_item/menu_item_routes.dart';
import '../../dio_config.dart';

final getIt = GetIt.instance;

void initGetItMenuItem() {
  if (!getIt.isRegistered<MenuItemCubit>()) {
    getIt.registerFactory<MenuItemCubit>(
      () => MenuItemCubit(getIt<MenuItemRepository>()),
    );
  }
  if (!getIt.isRegistered<MenuItemRepository>()) {
    getIt.registerLazySingleton<MenuItemRepository>(
      () => MenuItemRepository(getIt<MenuItemService>()),
    );
  }
  if (!getIt.isRegistered<MenuItemService>()) {
    getIt.registerLazySingleton<MenuItemService>(
      () => MenuItemService(createAndSetupDio()),
    );
  }
}
