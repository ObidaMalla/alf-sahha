import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/menu_item/update_element_in_menu_items/update_element_in_menu_items_model.dart';
import '../../../responses/menu_items/response_UpdateElementInMenuItems/UpdateElementInMenuItems_repo.dart';
import '../../results_state.dart';

class UpdateMenuItemCubit
    extends Cubit<ResultState<UpdateElementInMenuItemsModel>> {
  final UpdateMenuItemRepository updateMenuItemRepo;

  UpdateMenuItemCubit(this.updateMenuItemRepo)
    : super(const ResultState.idle());

  Future<void> updateMenuItem({
    required String itemId,
    required Map<String, dynamic> body,
  }) async {
    final isAlreadyLoading = state.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );
    if (isAlreadyLoading) return;

    emit(const ResultState.loading());
    try {
      final response = await updateMenuItemRepo.updateMenuItem(
        itemId: itemId,
        body: body,
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
