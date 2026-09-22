import 'package:get_it/get_it.dart';

import '../../../../cubits/orderCubit/payCubit/pay_order_cubit.dart';
import '../../../../responses/response_order/pay_order/pay_order_repo.dart';
import '../../../../routes/orders/orders_routes.dart';
import '../../../dio_config.dart';

final getIt = GetIt.instance;

void initGetItPayOrder() {
  if (!getIt.isRegistered<PayOrderCubit>()) {
    getIt.registerFactory<PayOrderCubit>(
      () => PayOrderCubit(getIt<PayOrderRepository>()),
    );
  }
  if (!getIt.isRegistered<PayOrderRepository>()) {
    getIt.registerLazySingleton<PayOrderRepository>(
      () => PayOrderRepository(getIt<OrderService>()),
    );
  }
  if (!getIt.isRegistered<OrderService>()) {
    getIt.registerLazySingleton<OrderService>(
      () => OrderService(createAndSetupDio()),
    );
  }
}
