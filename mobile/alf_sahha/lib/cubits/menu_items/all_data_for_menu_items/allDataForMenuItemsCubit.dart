import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/menu_item/all_data_for_menu/all_data_for_menu_items_model.dart';
import '../../../responses/menu_items/responses_all_data_for_menu_items/all_data_for_menu_items_repo.dart';
import '../../results_state.dart';

class GetMenuItemsCubit extends Cubit<ResultState<GetAllMenuItemsModel>> {
  final GetMenuItemsRepository getMenuItemsRepo;

  GetMenuItemsCubit(this.getMenuItemsRepo) : super(const ResultState.idle());

  Future<void> getMenuItems({required String restaurantId}) async {
    final isAlreadyLoading = state.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );
    if (isAlreadyLoading) return;

    emit(const ResultState.loading());
    try {
      final response = await getMenuItemsRepo.getMenuItems(
        restaurantId: restaurantId,
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
