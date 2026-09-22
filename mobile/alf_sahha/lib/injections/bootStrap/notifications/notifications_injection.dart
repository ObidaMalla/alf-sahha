import 'package:get_it/get_it.dart';

import '../../../cubits/notifications/UnreadCountCubit.dart';
import '../../../cubits/notifications/notifications_cubit.dart';
import '../../../responses/response_notifications/notifications_repo.dart';
import '../../../routes/notifications/notifications_routes.dart';
import '../../dio_config.dart';

final getIt = GetIt.instance;

void initGetItNotifications() {
  if (!getIt.isRegistered<NotificationsCubit>()) {
    getIt.registerFactory<NotificationsCubit>(
      () => NotificationsCubit(getIt<NotificationsRepository>()),
    );
  }
  if (!getIt.isRegistered<UnreadCountCubit>()) {
    getIt.registerLazySingleton<UnreadCountCubit>(
      () => UnreadCountCubit(getIt<NotificationsRepository>()),
    );
  }
  if (!getIt.isRegistered<NotificationsRepository>()) {
    getIt.registerLazySingleton<NotificationsRepository>(
      () => NotificationsRepository(getIt<NotificationsService>()),
    );
  }
  if (!getIt.isRegistered<NotificationsService>()) {
    getIt.registerLazySingleton<NotificationsService>(
      () => NotificationsService(createAndSetupDio()),
    );
  }
}
