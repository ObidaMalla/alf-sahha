import 'package:get_it/get_it.dart';

import '../../../cubits/logout/logout_cubit.dart';
import '../../../responses/logout/logout_response.dart';
import '../../../routes/logout/logout_route.dart';
import '../../dio_config.dart';

final getIt = GetIt.instance;

void initGetItLogout() {
  if (!getIt.isRegistered<LogoutCubit>()) {
    getIt.registerFactory<LogoutCubit>(
      () => LogoutCubit(getIt<LogoutRepository>()),
    );
  }
  if (!getIt.isRegistered<LogoutRepository>()) {
    getIt.registerLazySingleton<LogoutRepository>(
      () => LogoutRepository(getIt<LogoutService>()),
    );
  }
  if (!getIt.isRegistered<LogoutService>()) {
    getIt.registerLazySingleton<LogoutService>(
      () => LogoutService(createAndSetupDio()),
    );
  }
}
