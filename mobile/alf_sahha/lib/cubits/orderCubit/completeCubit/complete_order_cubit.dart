import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/orders/completeOrder/complete_order_model.dart';
import '../../../responses/response_order/complete_order/complete_order_repo.dart';
import '../../results_state.dart';

class CompleteOrderCubit extends Cubit<ResultState<CompleteOrderModel>> {
  final CompleteOrderRepository completeOrderRepo;
  CompleteOrderCubit(this.completeOrderRepo) : super(const ResultState.idle());

  Future<void> completeOrder({required String orderId}) async {
    final isAlreadyLoading = state.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );
    if (isAlreadyLoading) return;

    emit(const ResultState.loading());
    try {
      final response = await completeOrderRepo.completeOrder(orderId: orderId);
      debugPrint('✅ [CompleteOrderCubit] Success: ${response.message}');
      emit(ResultState.success(response));
    } catch (error) {
      final String message = error is String ? error : error.toString();
      debugPrint('❌ [CompleteOrderCubit] $message');
      emit(ResultState.error(message));
    }
  }

  void resetState() => emit(const ResultState.idle());
}
