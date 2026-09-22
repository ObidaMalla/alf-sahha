import 'package:get_it/get_it.dart';

import '../../../../cubits/restaurantCubit/create_restaurant_cubit.dart';
import '../../../../responses/response_restaurant/create_restaurant_repo.dart';
import '../../../../routes/restaurant/restaurant_routes.dart';
import '../../../dio_config.dart';

final getIt = GetIt.instance;

void initGetItCreateRestaurant() {
  if (!getIt.isRegistered<CreateRestaurantCubit>()) {
    getIt.registerFactory<CreateRestaurantCubit>(
      () => CreateRestaurantCubit(getIt<CreateRestaurantRepository>()),
    );
  }
  if (!getIt.isRegistered<CreateRestaurantRepository>()) {
    getIt.registerLazySingleton<CreateRestaurantRepository>(
      () => CreateRestaurantRepository(getIt<RestaurantService>()),
    );
  }
  if (!getIt.isRegistered<RestaurantService>()) {
    getIt.registerLazySingleton<RestaurantService>(
      () => RestaurantService(createAndSetupDio()),
    );
  }
}
