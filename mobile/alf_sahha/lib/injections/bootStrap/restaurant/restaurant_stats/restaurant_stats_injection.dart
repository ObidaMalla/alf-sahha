import 'package:get_it/get_it.dart';

import '../../../../cubits/restaurantCubit/restaurant_stats/restaurant_stats_cubit.dart';
import '../../../../responses/response_restaurant/restaurant_stats/restaurant_stats_repo.dart';
import '../../../../routes/restaurant/restaurant_routes.dart';
import '../../../dio_config.dart';

final getIt = GetIt.instance;

void initGetItRestaurantStats() {
  if (!getIt.isRegistered<RestaurantStatsCubit>()) {
    getIt.registerFactory<RestaurantStatsCubit>(
      () => RestaurantStatsCubit(getIt<RestaurantStatsRepository>()),
    );
  }
  if (!getIt.isRegistered<RestaurantStatsRepository>()) {
    getIt.registerLazySingleton<RestaurantStatsRepository>(
      () => RestaurantStatsRepository(getIt<RestaurantService>()),
    );
  }
  if (!getIt.isRegistered<RestaurantService>()) {
    getIt.registerLazySingleton<RestaurantService>(
      () => RestaurantService(createAndSetupDio()),
    );
  }
}
