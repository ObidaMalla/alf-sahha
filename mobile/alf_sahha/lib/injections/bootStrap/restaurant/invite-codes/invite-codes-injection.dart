import 'package:get_it/get_it.dart';

import '../../../../cubits/restaurantCubit/invite-codes/invite-codes_cubit.dart';
import '../../../../responses/response_restaurant/invite-codes/invite-codes_repo.dart';
import '../../../../routes/restaurant/restaurant_routes.dart';
import '../../../dio_config.dart';

final getIt = GetIt.instance;

void initGetItInviteCode() {
  if (!getIt.isRegistered<InviteCodeCubit>()) {
    getIt.registerFactory<InviteCodeCubit>(
      () => InviteCodeCubit(getIt<InviteCodeRepository>()),
    );
  }

  if (!getIt.isRegistered<InviteCodeRepository>()) {
    getIt.registerLazySingleton<InviteCodeRepository>(
      () => InviteCodeRepository(getIt<RestaurantService>()),
    );
  }

  if (!getIt.isRegistered<RestaurantService>()) {
    getIt.registerLazySingleton<RestaurantService>(
      () => RestaurantService(createAndSetupDio()),
    );
  }
}
