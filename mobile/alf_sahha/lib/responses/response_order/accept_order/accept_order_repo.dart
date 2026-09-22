import '../../../models/orders/accept_order/accept_order_model.dart';
import '../../../routes/orders/orders_routes.dart';
import '../../apiExceptionHandler.dart';

class AcceptOrderRepository {
  final OrderService orderService;

  AcceptOrderRepository(this.orderService);

  Future<AcceptOrderModel> acceptOrder({required String orderId}) {
    return ApiExceptionHandler.handle<AcceptOrderModel>(
      () => orderService.acceptOrder(orderId),
      fallbackErrorMessage: 'فشل قبول الطلب 🧨',
      isSuccess: (r) => r.success == true,
      extractMessage: (r) => r.message,
    );
  }
}
