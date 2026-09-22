import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/restaurant/restaurant_stats/restaurant_stats_model.dart';
import '../../../responses/response_restaurant/restaurant_stats/restaurant_stats_repo.dart';
import '../../results_state.dart';

class RestaurantStatsCubit extends Cubit<ResultState<RestaurantStatsModel>> {
  final RestaurantStatsRepository restaurantStatsRepo;
  RestaurantStatsCubit(this.restaurantStatsRepo)
    : super(const ResultState.idle());

  Future<void> getStats(String restaurantId) async {
    emit(const ResultState.loading());
    try {
      final response = await restaurantStatsRepo.getRestaurantStats(
        restaurantId,
      );
      emit(ResultState.success(response));
    } catch (error) {
      emit(ResultState.error(error is String ? error : error.toString()));
    }
  }
}
