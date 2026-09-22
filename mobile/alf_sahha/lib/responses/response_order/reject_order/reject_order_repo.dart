import '../../../models/orders/reject_order/reject_order_model.dart';
import '../../../routes/orders/orders_routes.dart';
import '../../apiExceptionHandler.dart';

class RejectOrderRepository {
  final OrderService orderService;

  RejectOrderRepository(this.orderService);

  Future<RejectOrderModel> rejectOrder({
    required String orderId,
    required String reason,
  }) {
    return ApiExceptionHandler.handle<RejectOrderModel>(
      () => orderService.rejectOrder(orderId, {'reason': reason}),
      fallbackErrorMessage: 'فشل رفض الطلب 🧨',
      isSuccess: (r) => r.success == true,
      extractMessage: (r) => r.message,
    );
  }
}
