import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/orders/get_all_orders/get_all_orders_model.dart';
import '../../../responses/response_order/getAllOrders/get_all_orders_repo.dart';
import '../../../token/token_storage.dart';
import '../../results_state.dart';

class GetAllOrdersCubit extends Cubit<ResultState<GetAllOrdersModel>> {
  final GetAllOrdersRepository getAllOrdersRepo;
  GetAllOrdersCubit(this.getAllOrdersRepo) : super(const ResultState.idle());

  Future<void> getAllOrders() async {
    emit(const ResultState.loading());
    try {
      final restaurantId = await TokenStorage.getRestaurantId();

      if (restaurantId == null || restaurantId.isEmpty) {
        emit(const ResultState.error('لا يوجد مطعم مرتبط بحسابك'));
        return;
      }

      final response = await getAllOrdersRepo.getAllOrders(
        restaurantId: restaurantId,
      );
      emit(ResultState.success(response));
    } catch (error) {
      emit(ResultState.error(error is String ? error : error.toString()));
    }
  }
}
