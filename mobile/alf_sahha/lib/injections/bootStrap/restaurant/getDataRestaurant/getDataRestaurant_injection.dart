import 'package:get_it/get_it.dart';

import '../../../../cubits/restaurantCubit/getDataRestaurant/getDataRestaurant_cubit.dart';
import '../../../../responses/response_restaurant/getDataRestaurant/getDataRestaurant_repo.dart';
import '../../../../routes/restaurant/restaurant_routes.dart'; // 👈 استيراد الـ Service الجديد
import '../../../dio_config.dart';

final getIt = GetIt.instance;

void initGetItDataRestaurant() {
  if (!getIt.isRegistered<RestaurantsCubit>()) {
    getIt.registerFactory<RestaurantsCubit>(
      () => RestaurantsCubit(getIt<RestaurantRepository>()),
    );
  }
  if (!getIt.isRegistered<RestaurantRepository>()) {
    getIt.registerLazySingleton<RestaurantRepository>(
      () => RestaurantRepository(getIt<RestaurantService>()),
    );
  }
  if (!getIt.isRegistered<RestaurantService>()) {
    getIt.registerLazySingleton<RestaurantService>(
      () => RestaurantService(createAndSetupDio()),
    );
  }
}
