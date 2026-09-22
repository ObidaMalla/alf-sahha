import 'package:alf_sahha/injections/bootStrap/profile/profile_injection.dart';
import 'package:alf_sahha/injections/bootStrap/restaurant/_restaurant_injections.dart';
import 'package:alf_sahha/injections/bootStrap/staff/staff_injection.dart';
import 'package:alf_sahha/injections/bootStrap/wallet/wallet_injection.dart';

import 'auth/_auth_injection.dart';
import 'logout/logout_injections.dart';
import 'menu_items/_menu_items.dart';
import 'notifications/notifications_injection.dart';
import 'orders/_orders.dart';

void setupDependencies() {
  initAuthFeature();
  initGetItWallet();
  initRestaurantFeature();
  initRestaurantMenuItemFeature();
  initOrdersFeature();
  initGetItNotifications();
  initGetItProfile();
  initGetItStaff();
  initGetItLogout();
}
