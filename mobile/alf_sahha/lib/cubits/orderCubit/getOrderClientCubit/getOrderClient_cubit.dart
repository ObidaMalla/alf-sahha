import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/orders/getOrderClient/getOrderClient_model.dart';
import '../../../responses/response_order/getOrderClient/my_orders_repo.dart';
import '../../results_state.dart';

class MyOrdersCubit extends Cubit<ResultState<MyOrdersModel>> {
  final MyOrdersRepository myOrdersRepo;
  MyOrdersCubit(this.myOrdersRepo) : super(const ResultState.idle());

  Future<void> getMyOrders({String? status}) async {
    emit(const ResultState.loading());
    try {
      final response = await myOrdersRepo.getMyOrders(status: status);
      emit(ResultState.success(response));
    } catch (error) {
      emit(ResultState.error(error is String ? error : error.toString()));
    }
  }
}
