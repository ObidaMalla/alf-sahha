import '../../../models/orders/getOrderClient/getOrderClient_model.dart';
import '../../../routes/orders/orders_routes.dart';
import '../../apiExceptionHandler.dart';

class MyOrdersRepository {
  final OrderService orderService;
  MyOrdersRepository(this.orderService);

  Future<MyOrdersModel> getMyOrders({String? status}) {
    return ApiExceptionHandler.handle<MyOrdersModel>(
      () => orderService.getMyOrders(status),
      fallbackErrorMessage: 'فشل جلب طلباتك 🧨',
      isSuccess: (r) => r.success == true,
      extractMessage: (r) => r.message,
    );
  }
}
