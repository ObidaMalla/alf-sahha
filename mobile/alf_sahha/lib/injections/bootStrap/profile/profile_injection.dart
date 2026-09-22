import 'package:get_it/get_it.dart';

import '../../../cubits/profile/profile_cubit.dart';
import '../../../responses/response_profile/profile_repo.dart';
import '../../../routes/profile/profile_routes.dart';
import '../../dio_config.dart';

final getIt = GetIt.instance;

void initGetItProfile() {
  if (!getIt.isRegistered<ProfileCubit>()) {
    getIt.registerFactory<ProfileCubit>(
      () => ProfileCubit(getIt<ProfileRepository>()),
    );
  }
  if (!getIt.isRegistered<ProfileRepository>()) {
    getIt.registerLazySingleton<ProfileRepository>(
      () => ProfileRepository(getIt<ProfileService>()),
    );
  }
  if (!getIt.isRegistered<ProfileService>()) {
    getIt.registerLazySingleton<ProfileService>(
      () => ProfileService(createAndSetupDio()),
    );
  }
}
