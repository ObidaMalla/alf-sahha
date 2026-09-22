import 'package:alf_sahha/injections/bootStrap/restaurant/redeem_invite_code/redeem_invite_code_injection.dart';
import 'package:alf_sahha/injections/bootStrap/restaurant/restaurant_stats/restaurant_stats_injection.dart';

import 'create_restaurant/create_restaurant_injection.dart';
import 'getDataRestaurant/getDataRestaurant_injection.dart';
import 'invite-codes/invite-codes-injection.dart';

void initRestaurantFeature() {
  initGetItCreateRestaurant();
  initGetItInviteCode();
  initGetItRedeemInviteCode();
  initGetItDataRestaurant();
  initGetItRestaurantStats();
}
