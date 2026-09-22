import '../../../models/orders/pay/pay_order_model.dart';
import '../../../routes/orders/orders_routes.dart';
import '../../apiExceptionHandler.dart';

class PayOrderRepository {
  final OrderService orderService;
  PayOrderRepository(this.orderService);

  Future<PayOrderModel> payOrder(String orderId) {
    return ApiExceptionHandler.handle<PayOrderModel>(
      () => orderService.payOrder(orderId),
      fallbackErrorMessage: 'فشلت عملية الدفع 🧨',
      isSuccess: (r) => r.success == true,
      extractMessage: (r) => r.message,
    );
  }
}
