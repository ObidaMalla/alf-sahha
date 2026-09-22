import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/orders/reject_order/reject_order_model.dart';
import '../../../responses/response_order/reject_order/reject_order_repo.dart';
import '../../results_state.dart';

class RejectOrderCubit extends Cubit<ResultState<RejectOrderModel>> {
  final RejectOrderRepository rejectOrderRepo;

  RejectOrderCubit(this.rejectOrderRepo) : super(const ResultState.idle());

  Future<void> rejectOrder({
    required String orderId,
    required String reason,
  }) async {
    emit(const ResultState.loading());

    try {
      final response = await rejectOrderRepo.rejectOrder(
        orderId: orderId,
        reason: reason,
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
