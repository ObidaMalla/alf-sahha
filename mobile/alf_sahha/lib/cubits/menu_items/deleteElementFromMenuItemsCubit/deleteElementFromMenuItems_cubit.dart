import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/menu_item/delete_element_form_menu_items/delete_menu_item_response_model.dart';
import '../../../responses/menu_items/response_deleteElementFromMenuItems/deleteElementFromMenuItems_repo.dart';
import '../../results_state.dart';

class DeleteMenuItemCubit
    extends Cubit<ResultState<DeleteMenuItemResponseModel>> {
  final DeleteElementFromMenuItemRepository deleteMenuItemRepo;

  DeleteMenuItemCubit(this.deleteMenuItemRepo)
    : super(const ResultState.idle());

  Future<void> deleteMenuItem({required String itemId}) async {
    final isAlreadyLoading = state.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );
    if (isAlreadyLoading) return;

    emit(const ResultState.loading());
    try {
      final response = await deleteMenuItemRepo.deleteMenuItem(itemId: itemId);

      emit(ResultState.success(response));
    } catch (error) {
      emit(ResultState.error(error is String ? error : error.toString()));
    }
  }

  void resetState() {
    emit(const ResultState.idle());
  }
}
