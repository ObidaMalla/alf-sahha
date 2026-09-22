import 'package:get_it/get_it.dart';

import '../../../../cubits/orderCubit/cartCubit.dart';
import '../../../../cubits/orderCubit/create_order_cubit.dart';
import '../../../../responses/response_order/create_order_repo.dart';
import '../../../../routes/orders/orders_routes.dart';
import '../../../dio_config.dart';

final getIt = GetIt.instance;

void initGetItCreateOrder() {
  if (!getIt.isRegistered<CreateOrderCubit>()) {
    getIt.registerFactory<CreateOrderCubit>(
      () => CreateOrderCubit(getIt<CreateOrderRepository>()),
    );
  }
  if (!getIt.isRegistered<CreateOrderRepository>()) {
    getIt.registerLazySingleton<CreateOrderRepository>(
      () => CreateOrderRepository(getIt<OrderService>()),
    );
  }
  if (!getIt.isRegistered<OrderService>()) {
    getIt.registerLazySingleton<OrderService>(
      () => OrderService(createAndSetupDio()),
    );
  }

  if (!getIt.isRegistered<CartCubit>()) {
    getIt.registerLazySingleton<CartCubit>(() => CartCubit());
  }
}
