import 'package:get_it/get_it.dart';

import '../../../../cubits/redeemInviteCode/redeem_invite_code_cubit.dart';
import '../../../../responses/response_redeem_invite_code/redeem_invite_code_repo.dart';
import '../../../../routes/restaurant/restaurant_routes.dart';
import '../../../dio_config.dart';

final getIt = GetIt.instance;

void initGetItRedeemInviteCode() {
  if (!getIt.isRegistered<RedeemInviteCodeCubit>()) {
    getIt.registerFactory<RedeemInviteCodeCubit>(
      () => RedeemInviteCodeCubit(getIt<RedeemInviteCodeRepository>()),
    );
  }
  if (!getIt.isRegistered<RedeemInviteCodeRepository>()) {
    getIt.registerLazySingleton<RedeemInviteCodeRepository>(
      () => RedeemInviteCodeRepository(getIt<RestaurantService>()),
    );
  }
  if (!getIt.isRegistered<RestaurantService>()) {
    getIt.registerLazySingleton<RestaurantService>(
      () => RestaurantService(createAndSetupDio()),
    );
  }
}
