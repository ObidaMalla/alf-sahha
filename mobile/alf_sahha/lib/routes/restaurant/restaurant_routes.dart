import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../core/constants/api_constants.dart';
import '../../models/redeemInviteCode/redeem_invite_code_model.dart';
import '../../models/restaurant/create_restaurant_model.dart';
import '../../models/restaurant/getDataRestaurants/restaurants_data_model.dart';
import '../../models/restaurant/invite-codes/invite_codes_model.dart';
import '../../models/restaurant/restaurant_stats/restaurant_stats_model.dart';

part 'restaurant_routes.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class RestaurantService {
  factory RestaurantService(Dio dio, {String baseUrl}) = _RestaurantService;

  @POST('/restaurants')
  @MultiPart()
  Future<CreateRestaurantModel> createRestaurant({
    @Part(name: 'name') required String name,
    @Part(name: 'description') String? description,
    @Part(name: 'address') String? address,
    @Part(name: 'image') File? image,
  });

  @GET('/restaurants')
  Future<RestaurantsResponseModel> getRestaurants();

  @POST('/restaurants/{restaurantId}/invite-codes')
  Future<InviteCodeModel> generateInviteCode(
    @Path('restaurantId') String restaurantId,
  );

  @POST('/invite-codes/redeem')
  Future<RedeemInviteCodeModel> redeemCode(@Body() Map<String, dynamic> body);

  @GET('/restaurants/{id}/stats')
  Future<RestaurantStatsModel> getRestaurantStats(
    @Path('id') String restaurantId,
  );
}
