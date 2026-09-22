import 'package:get_it/get_it.dart';

import '../../../../cubits/orderCubit/getAllOrdersCubit/get_all_orders_cubit.dart';
import '../../../../responses/response_order/getAllOrders/get_all_orders_repo.dart';
import '../../../../routes/orders/orders_routes.dart';
import '../../../dio_config.dart';

final getIt = GetIt.instance;

void initGetItGetAllOrders() {
  if (!getIt.isRegistered<GetAllOrdersCubit>()) {
    getIt.registerFactory<GetAllOrdersCubit>(
      () => GetAllOrdersCubit(getIt<GetAllOrdersRepository>()),
    );
  }
  if (!getIt.isRegistered<GetAllOrdersRepository>()) {
    getIt.registerLazySingleton<GetAllOrdersRepository>(
      () => GetAllOrdersRepository(getIt<OrderService>()),
    );
  }
  if (!getIt.isRegistered<OrderService>()) {
    getIt.registerLazySingleton<OrderService>(
      () => OrderService(createAndSetupDio()),
    );
  }
}
