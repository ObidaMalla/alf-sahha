import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../core/constants/api_constants.dart';
import '../../models/orders/accept_order/accept_order_model.dart';
import '../../models/orders/completeOrder/complete_order_model.dart';
import '../../models/orders/create_order/create_order_model.dart';
import '../../models/orders/getOrderClient/getOrderClient_model.dart';
import '../../models/orders/get_all_orders/get_all_orders_model.dart';
import '../../models/orders/pay/pay_order_model.dart';
import '../../models/orders/reject_order/reject_order_model.dart';

part 'orders_routes.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class OrderService {
  factory OrderService(Dio dio, {String baseUrl}) = _OrderService;

  @POST('/orders')
  Future<CreateOrderModel> createOrder(@Body() Map<String, dynamic> body);

  @GET('/restaurants/{restaurantId}/orders')
  Future<GetAllOrdersModel> getAllOrders(
    @Path('restaurantId') String restaurantId,
  );

  @PATCH('/orders/{orderId}/accept')
  Future<AcceptOrderModel> acceptOrder(@Path('orderId') String orderId);

  @PATCH('/orders/{orderId}/reject')
  Future<RejectOrderModel> rejectOrder(
    @Path('orderId') String orderId,
    @Body() Map<String, dynamic> body,
  );

  @POST('/orders/{orderId}/pay')
  Future<PayOrderModel> payOrder(@Path('orderId') String orderId);

  @GET('/orders/my')
  Future<MyOrdersModel> getMyOrders(@Query('status') String? status);

  @PATCH('/orders/{id}/complete')
  Future<CompleteOrderModel> completeOrder(@Path('id') String id);
}
