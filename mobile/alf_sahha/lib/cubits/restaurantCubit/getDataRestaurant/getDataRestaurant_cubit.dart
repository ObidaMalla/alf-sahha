import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/restaurant/getDataRestaurants/restaurants_data_model.dart';
import '../../../responses/response_restaurant/getDataRestaurant/getDataRestaurant_repo.dart';
import '../../results_state.dart';

class RestaurantsCubit extends Cubit<ResultState<RestaurantsResponseModel>> {
  final RestaurantRepository restaurantRepo;

  RestaurantsCubit(this.restaurantRepo) : super(const ResultState.idle());

  Future<void> getRestaurants() async {
    final isAlreadyLoading = state.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );
    if (isAlreadyLoading) return;

    emit(const ResultState.loading());
    try {
      final response = await restaurantRepo.getRestaurants();
      debugPrint('✅ [RestaurantsCubit] Success: ${response.message}');
      emit(ResultState.success(response));
    } catch (error) {
      final String message = error is String ? error : error.toString();
      debugPrint('❌ [RestaurantsCubit] $message');
      emit(ResultState.error(message));
    }
  }

  void resetState() => emit(const ResultState.idle());
}
