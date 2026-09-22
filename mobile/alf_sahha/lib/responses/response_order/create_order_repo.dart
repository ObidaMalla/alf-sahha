import '../../models/orders/create_order/create_order_model.dart';
import '../../routes/orders/orders_routes.dart';
import '../apiExceptionHandler.dart';

class CreateOrderRepository {
  final OrderService orderService;
  CreateOrderRepository(this.orderService);

  Future<CreateOrderModel> createOrder({
    required String restaurantId,
    required List<Map<String, dynamic>> items,
  }) {
    return ApiExceptionHandler.handle<CreateOrderModel>(
      () => orderService.createOrder({
        'restaurantId': restaurantId,
        'items': items,
      }),
      fallbackErrorMessage: 'فشل إرسال الطلب 🧨',
      isSuccess: (r) => r.success == true,
      extractMessage: (r) => r.message,
    );
  }
}
