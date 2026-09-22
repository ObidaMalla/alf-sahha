import 'package:get_it/get_it.dart';

import '../../../../cubits/orderCubit/acceptCubit/acceptOrder_cubit.dart';
import '../../../../responses/response_order/accept_order/accept_order_repo.dart';
import '../../../../routes/orders/orders_routes.dart';
import '../../../dio_config.dart';

final getIt = GetIt.instance;

void initGetItAcceptOrder() {
  if (!getIt.isRegistered<AcceptOrderCubit>()) {
    getIt.registerFactory<AcceptOrderCubit>(
      () => AcceptOrderCubit(getIt<AcceptOrderRepository>()),
    );
  }

  if (!getIt.isRegistered<AcceptOrderRepository>()) {
    getIt.registerLazySingleton<AcceptOrderRepository>(
      () => AcceptOrderRepository(getIt<OrderService>()),
    );
  }

  if (!getIt.isRegistered<OrderService>()) {
    getIt.registerLazySingleton<OrderService>(
      () => OrderService(createAndSetupDio()),
    );
  }
}
