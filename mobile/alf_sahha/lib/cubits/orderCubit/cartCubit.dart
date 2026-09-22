import 'package:flutter_bloc/flutter_bloc.dart';

import '../../interfaces/orders/create_order/orderCheckoutScreen.dart';

class CartCubit extends Cubit<List<CartItem>> {
  CartCubit() : super([]);

  void addItem({
    required String menuItemId,
    required String restaurantId,
    required String name,
    required num price,
  }) {
    final index = state.indexWhere((e) => e.menuItemId == menuItemId);

    if (index != -1) {
      state[index].quantity++;
      emit(List.from(state));
    } else {
      emit([
        ...state,
        CartItem(
          menuItemId: menuItemId,
          restaurantId: restaurantId,
          name: name,
          price: price,
        ),
      ]);
    }
  }

  void removeItem(String menuItemId) {
    emit(state.where((e) => e.menuItemId != menuItemId).toList());
  }

  void clear() => emit([]);

  int get totalQuantity => state.fold(0, (sum, item) => sum + item.quantity);

  num get totalPrice => state.fold(0, (sum, item) => sum + item.subtotal);
}
