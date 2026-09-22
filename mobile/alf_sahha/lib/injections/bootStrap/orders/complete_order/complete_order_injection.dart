import 'package:get_it/get_it.dart';

import '../../../../cubits/orderCubit/completeCubit/complete_order_cubit.dart';
import '../../../../responses/response_order/complete_order/complete_order_repo.dart';
import '../../../../routes/orders/orders_routes.dart';
import '../../../dio_config.dart';

final getIt = GetIt.instance;

void initGetItCompleteOrder() {
  if (!getIt.isRegistered<CompleteOrderCubit>()) {
    getIt.registerFactory<CompleteOrderCubit>(
      () => CompleteOrderCubit(getIt<CompleteOrderRepository>()),
    );
  }
  if (!getIt.isRegistered<CompleteOrderRepository>()) {
    getIt.registerLazySingleton<CompleteOrderRepository>(
      () => CompleteOrderRepository(getIt<OrderService>()),
    );
  }
  if (!getIt.isRegistered<OrderService>()) {
    getIt.registerLazySingleton<OrderService>(
      () => OrderService(createAndSetupDio()),
    );
  }
}
