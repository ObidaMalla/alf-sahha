import 'package:get_it/get_it.dart';

import '../../../../cubits/orderCubit/getOrderClientCubit/getOrderClient_cubit.dart';
import '../../../../responses/response_order/getOrderClient/my_orders_repo.dart';
import '../../../../routes/orders/orders_routes.dart';
import '../../../dio_config.dart';

final getIt = GetIt.instance;

void initGetItMyOrders() {
  if (!getIt.isRegistered<MyOrdersCubit>()) {
    getIt.registerFactory<MyOrdersCubit>(
      () => MyOrdersCubit(getIt<MyOrdersRepository>()),
    );
  }
  if (!getIt.isRegistered<MyOrdersRepository>()) {
    getIt.registerLazySingleton<MyOrdersRepository>(
      () => MyOrdersRepository(getIt<OrderService>()),
    );
  }
  if (!getIt.isRegistered<OrderService>()) {
    getIt.registerLazySingleton<OrderService>(
      () => OrderService(createAndSetupDio()),
    );
  }
}
