import 'package:get_it/get_it.dart';

import '../../../../cubits/menu_items/all_data_for_menu_items/allDataForMenuItemsCubit.dart';
import '../../../../responses/menu_items/responses_all_data_for_menu_items/all_data_for_menu_items_repo.dart';
import '../../../../routes/menu_item/menu_item_routes.dart';
import '../../../dio_config.dart';

final getIt = GetIt.instance;

void initGetItGetALLMenuItems() {
  if (!getIt.isRegistered<GetMenuItemsCubit>()) {
    getIt.registerFactory<GetMenuItemsCubit>(
      () => GetMenuItemsCubit(getIt<GetMenuItemsRepository>()),
    );
  }
  if (!getIt.isRegistered<GetMenuItemsRepository>()) {
    getIt.registerLazySingleton<GetMenuItemsRepository>(
      () => GetMenuItemsRepository(getIt<MenuItemService>()),
    );
  }
  if (!getIt.isRegistered<MenuItemService>()) {
    getIt.registerLazySingleton<MenuItemService>(
      () => MenuItemService(createAndSetupDio()),
    );
  }
}
