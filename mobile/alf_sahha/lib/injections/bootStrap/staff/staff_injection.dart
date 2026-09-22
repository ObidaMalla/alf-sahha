import 'package:get_it/get_it.dart';

import '../../../cubits/staffCubit/staff_cubit.dart';
import '../../../responses/response_staff/staff_repo.dart';
import '../../../routes/staff/staff_routes.dart';
import '../../dio_config.dart';

final getIt = GetIt.instance;

void initGetItStaff() {
  if (!getIt.isRegistered<GetStaffCubit>()) {
    getIt.registerFactory<GetStaffCubit>(
      () => GetStaffCubit(getIt<StaffRepository>()),
    );
  }
  if (!getIt.isRegistered<DeleteStaffCubit>()) {
    getIt.registerFactory<DeleteStaffCubit>(
      () => DeleteStaffCubit(getIt<StaffRepository>()),
    );
  }
  if (!getIt.isRegistered<StaffRepository>()) {
    getIt.registerLazySingleton<StaffRepository>(
      () => StaffRepository(getIt<StaffService>()),
    );
  }
  if (!getIt.isRegistered<StaffService>()) {
    getIt.registerLazySingleton<StaffService>(
      () => StaffService(createAndSetupDio()),
    );
  }
}
