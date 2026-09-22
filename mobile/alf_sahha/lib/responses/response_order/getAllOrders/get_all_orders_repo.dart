import '../../../models/orders/get_all_orders/get_all_orders_model.dart';
import '../../../routes/orders/orders_routes.dart';
import '../../apiExceptionHandler.dart';

class GetAllOrdersRepository {
  final OrderService orderService;
  GetAllOrdersRepository(this.orderService);

  Future<GetAllOrdersModel> getAllOrders({required String restaurantId}) {
    return ApiExceptionHandler.handle<GetAllOrdersModel>(
      () => orderService.getAllOrders(restaurantId),
      fallbackErrorMessage: 'فشل جلب الطلبات 🧨',
      isSuccess: (r) => r.success == true,
      extractMessage: (r) => r.message,
    );
  }
}
