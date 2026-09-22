import 'package:get_it/get_it.dart';

import '../../../../cubits/orderCubit/rejectOrderCubit/reject_order_cubit.dart';
import '../../../../responses/response_order/reject_order/reject_order_repo.dart';
import '../../../../routes/orders/orders_routes.dart';
import '../../../dio_config.dart';

final getIt = GetIt.instance;

void initGetItRejectOrder() {
  if (!getIt.isRegistered<RejectOrderCubit>()) {
    getIt.registerFactory<RejectOrderCubit>(
      () => RejectOrderCubit(getIt<RejectOrderRepository>()),
    );
  }

  if (!getIt.isRegistered<RejectOrderRepository>()) {
    getIt.registerLazySingleton<RejectOrderRepository>(
      () => RejectOrderRepository(getIt<OrderService>()),
    );
  }

  if (!getIt.isRegistered<OrderService>()) {
    getIt.registerLazySingleton<OrderService>(
      () => OrderService(createAndSetupDio()),
    );
  }
}
