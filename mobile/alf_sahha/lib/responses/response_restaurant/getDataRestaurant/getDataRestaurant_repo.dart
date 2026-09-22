import '../../../models/restaurant/getDataRestaurants/restaurants_data_model.dart';
import '../../../routes/restaurant/restaurant_routes.dart';
import '../../apiExceptionHandler.dart';

class RestaurantRepository {
  final RestaurantService restaurantService;
  RestaurantRepository(this.restaurantService);

  Future<RestaurantsResponseModel> getRestaurants() {
    return ApiExceptionHandler.handle<RestaurantsResponseModel>(
      () => restaurantService.getRestaurants(),
      fallbackErrorMessage: 'فشل جلب قائمة المطاعم 🧨',
      isSuccess: (r) => r.success == true,
      extractMessage: (r) => r.message,
    );
  }
}
