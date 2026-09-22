import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/orders/accept_order/accept_order_model.dart';
import '../../../responses/response_order/accept_order/accept_order_repo.dart';
import '../../results_state.dart';

class AcceptOrderCubit extends Cubit<ResultState<AcceptOrderModel>> {
  final AcceptOrderRepository acceptOrderRepo;

  AcceptOrderCubit(this.acceptOrderRepo) : super(const ResultState.idle());

  Future<void> acceptOrder({required String orderId}) async {
    emit(const ResultState.loading());

    try {
      final response = await acceptOrderRepo.acceptOrder(orderId: orderId);

      emit(ResultState.success(response));
    } catch (error) {
      emit(ResultState.error(error is String ? error : error.toString()));
    }
  }

  void resetState() {
    emit(const ResultState.idle());
  }
}
