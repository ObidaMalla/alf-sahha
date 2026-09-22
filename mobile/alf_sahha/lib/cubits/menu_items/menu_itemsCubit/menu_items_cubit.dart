import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/menu_item/menu_item_model.dart';
import '../../../responses/menu_items/responses_item_menu/menu_item_repo.dart';
import '../../results_state.dart';

class MenuItemCubit extends Cubit<ResultState<MenuItemModel>> {
  final MenuItemRepository menuItemRepo;

  MenuItemCubit(this.menuItemRepo) : super(const ResultState.idle());

  Future<void> addMenuItem({
    required String restaurantId,
    required String name,
    String? description,
    required String price,
    required String category,
    File? image,
  }) async {
    final isAlreadyLoading = state.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );
    if (isAlreadyLoading) return;

    emit(const ResultState.loading());
    try {
      final response = await menuItemRepo.addMenuItem(
        restaurantId: restaurantId,
        name: name,
        description: description,
        price: price,
        category: category,
        image: image,
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
