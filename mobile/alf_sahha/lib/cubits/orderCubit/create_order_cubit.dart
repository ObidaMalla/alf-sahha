import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/orders/create_order/create_order_model.dart';
import '../../responses/response_order/create_order_repo.dart';
import '../results_state.dart';

class CreateOrderCubit extends Cubit<ResultState<CreateOrderModel>> {
  final CreateOrderRepository createOrderRepo;
  CreateOrderCubit(this.createOrderRepo) : super(const ResultState.idle());

  Future<void> createOrder({
    required String restaurantId,
    required List<Map<String, dynamic>> items,
  }) async {
    emit(const ResultState.loading());
    try {
      final response = await createOrderRepo.createOrder(
        restaurantId: restaurantId,
        items: items,
      );
      emit(ResultState.success(response));
    } catch (error) {
      emit(ResultState.error(error is String ? error : error.toString()));
    }
  }

  void resetState() {
    emit(const ResultState.idle());
  }
}
