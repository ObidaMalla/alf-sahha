import '../../../models/orders/completeOrder/complete_order_model.dart';
import '../../../routes/orders/orders_routes.dart';
import '../../apiExceptionHandler.dart';

class CompleteOrderRepository {
  final OrderService orderService;
  CompleteOrderRepository(this.orderService);

  Future<CompleteOrderModel> completeOrder({required String orderId}) {
    return ApiExceptionHandler.handle<CompleteOrderModel>(
      () => orderService.completeOrder(orderId),
      fallbackErrorMessage: 'فشل تجهيز الطلب 🧨',
      isSuccess: (r) => r.success == true,
      extractMessage: (r) => r.message,
    );
  }
}
