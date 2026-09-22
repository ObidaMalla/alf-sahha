import 'package:alf_sahha/injections/bootStrap/orders/pay_order/pay_order_injection.dart';
import 'package:alf_sahha/injections/bootStrap/orders/reject_order/reject_order_injection.dart';

import 'accept_order/accept_order_injection.dart';
import 'complete_order/complete_order_injection.dart';
import 'create_order/create_order_injection.dart';
import 'getAllOrders/get_all_orders_injection.dart';
import 'getOrderClient/getOrderClient_injection.dart';

void initOrdersFeature() {
  initGetItCreateOrder();
  initGetItGetAllOrders();
  initGetItAcceptOrder();
  initGetItRejectOrder();
  initGetItPayOrder();
  initGetItMyOrders();
  initGetItCompleteOrder();
}
