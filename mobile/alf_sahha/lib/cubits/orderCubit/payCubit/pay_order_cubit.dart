import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/orders/pay/pay_order_model.dart';
import '../../../responses/response_order/pay_order/pay_order_repo.dart';
import '../../results_state.dart';

class PayOrderCubit extends Cubit<ResultState<PayOrderModel>> {
  final PayOrderRepository payOrderRepo;
  PayOrderCubit(this.payOrderRepo) : super(const ResultState.idle());

  Future<void> payOrder(String orderId) async {
    emit(const ResultState.loading());
    try {
      final response = await payOrderRepo.payOrder(orderId);
      emit(ResultState.success(response));
    } catch (error) {
      emit(ResultState.error(error is String ? error : error.toString()));
    }
  }
}
