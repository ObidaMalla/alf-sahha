import '../../../models/restaurant/restaurant_stats/restaurant_stats_model.dart';
import '../../../routes/restaurant/restaurant_routes.dart';
import '../../apiExceptionHandler.dart';

class RestaurantStatsRepository {
  final RestaurantService restaurantService;
  RestaurantStatsRepository(this.restaurantService);

  Future<RestaurantStatsModel> getRestaurantStats(String restaurantId) {
    return ApiExceptionHandler.handle<RestaurantStatsModel>(
      () => restaurantService.getRestaurantStats(restaurantId),
      fallbackErrorMessage: 'فشل جلب إحصائيات المطعم 🧨',
      isSuccess: (r) => r.success == true,
      extractMessage: (r) => r.message,
    );
  }
}
