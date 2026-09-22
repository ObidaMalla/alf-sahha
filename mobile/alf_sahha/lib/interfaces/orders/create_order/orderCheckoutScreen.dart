import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/color/colors.dart';
import '../../../cubits/orderCubit/cartCubit.dart';
import '../../../cubits/orderCubit/create_order_cubit.dart';
import '../../../cubits/results_state.dart';
import '../../../injections/bootStrap/auth/_login/login_injection.dart';
import '../../../models/orders/create_order/create_order_model.dart';

// ============================================================
// 🛒 عنصر سلة محلي — يمثل صنف مختار من القائمة قبل الإرسال
// ============================================================
class CartItem {
  final String menuItemId;
  final String restaurantId;

  final String name;
  final num price;
  int quantity;
  String note;

  CartItem({
    required this.menuItemId,
    required this.restaurantId,

    required this.name,
    required this.price,
    this.quantity = 1,
    this.note = '',
  });

  num get subtotal => price * quantity;
}

class OrderCheckoutScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  final VoidCallback? onOrderCompleted;

  const OrderCheckoutScreen({
    super.key,
    required this.cartItems,
    this.onOrderCompleted,
  });

  @override
  State<OrderCheckoutScreen> createState() => _OrderCheckoutScreenState();
}

class _OrderCheckoutScreenState extends State<OrderCheckoutScreen> {
  late final CreateOrderCubit _cubit;
  late List<CartItem> _items;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<CreateOrderCubit>();
    _items = widget.cartItems;
  }

  num get _totalPrice =>
      _items.fold<num>(0, (sum, item) => sum + item.subtotal);

  void _incrementQuantity(CartItem item) {
    setState(() => item.quantity++);
  }

  void _decrementQuantity(CartItem item) {
    if (item.quantity <= 1) {
      _confirmRemoveItem(item);
      return;
    }
    setState(() => item.quantity--);
  }

  void _confirmRemoveItem(CartItem item) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          'حذف الصنف',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          'هل تريد حذف "${item.name}" من الطلب؟',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'إلغاء',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              setState(() => _items.remove(item));
            },
            child: Text(
              'حذف',
              style: TextStyle(
                color: AppColors.errorColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _editNote(CartItem item) {
    final controller = TextEditingController(text: item.note);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'ملاحظة على "${item.name}"',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: controller,
                maxLines: 3,
                style: TextStyle(color: AppColors.textPrimary),
                cursorColor: AppColors.accentColor,
                decoration: InputDecoration(
                  hintText: 'مثال: بدون بصل...',
                  hintStyle: TextStyle(color: AppColors.hintColor),
                  filled: true,
                  fillColor: AppColors.inputColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: AppColors.borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: AppColors.borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: AppColors.accentColor,
                      width: 1.6,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  setState(() => item.note = controller.text.trim());
                  Navigator.pop(sheetContext);
                },
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: AppColors.fireGradient),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Text(
                    'حفظ الملاحظة',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitOrder() {
    if (_items.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('السلة فارغة')));
      return;
    }

    final restaurantId = _items.first.restaurantId.trim();

    if (restaurantId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر تحديد المطعم الخاص بالطلب')),
      );
      return;
    }

    // حماية: لا نسمح بوجود أصناف من أكثر من مطعم بنفس الطلب
    final hasDifferentRestaurant = _items.any(
      (item) => item.restaurantId != restaurantId,
    );

    if (hasDifferentRestaurant) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('لا يمكن إرسال أصناف من أكثر من مطعم في نفس الطلب'),
        ),
      );
      return;
    }

    debugPrint('================ CREATE ORDER ================');
    debugPrint('Restaurant ID: $restaurantId');
    debugPrint('Items Count: ${_items.length}');

    _cubit.createOrder(
      restaurantId: restaurantId,
      items: _items
          .map(
            (item) => {
              'menuItemId': item.menuItemId,
              'quantity': item.quantity,
              if (item.note.isNotEmpty) 'note': item.note,
            },
          )
          .toList(),
    );

    _showStatusDialog();
  }

  void _showStatusDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (dialogContext) {
        return _OrderStatusDialog(
          cubit: _cubit,
          onSuccessFinished: () {
            Navigator.of(dialogContext).pop(); // سكر الـ Dialog
            getIt<CartCubit>().clear(); // صفّر السلة الحقيقية
            widget.onOrderCompleted
                ?.call(); // سكر شاشة الـ Checkout وارجع للمنيو
          },
          onErrorFinished: () {
            Navigator.of(dialogContext).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'مراجعة الطلب',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
        ),
        body: _items.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      color: AppColors.textMuted,
                      size: 60,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'سلتك فارغة',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _items.length,
                      itemBuilder: (context, index) =>
                          _buildCartItemCard(_items[index]),
                    ),
                  ),
                  _buildBottomSummary(),
                ],
              ),
      ),
    );
  }

  Widget _buildCartItemCard(CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accentColor.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.name,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 15.5,
                  ),
                ),
              ),
              Text(
                '${item.subtotal.toStringAsFixed(0)} ل.س',
                style: TextStyle(
                  color: AppColors.accentColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${item.price.toStringAsFixed(0)} ل.س للقطعة',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
          if (item.note.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.goldColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.sticky_note_2_rounded,
                    size: 13,
                    color: AppColors.goldColor,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      item.note,
                      style: TextStyle(
                        color: AppColors.goldColor,
                        fontSize: 11.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: () => _editNote(item),
                icon: Icon(
                  Icons.edit_note_rounded,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
                label: Text(
                  item.note.isEmpty ? 'إضافة ملاحظة' : 'تعديل الملاحظة',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12.5,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.inputColor,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppColors.borderColor),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.remove_rounded,
                        size: 18,
                        color: AppColors.textPrimary,
                      ),
                      onPressed: () => _decrementQuantity(item),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 34,
                        minHeight: 34,
                      ),
                    ),
                    SizedBox(
                      width: 24,
                      child: Text(
                        '${item.quantity}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.add_rounded,
                        size: 18,
                        color: AppColors.accentColor,
                      ),
                      onPressed: () => _incrementQuantity(item),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 34,
                        minHeight: 34,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSummary() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الإجمالي',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${_totalPrice.toStringAsFixed(0)} ل.س',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _submitOrder,
            child: Container(
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: AppColors.fireGradient),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentColor.withOpacity(0.35),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Text(
                'تأكيد الطلب',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.5,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 💠 نافذة حالة إرسال الطلب — Loading ⟶ Success ✅ / Error ❌
// ============================================================
class _OrderStatusDialog extends StatefulWidget {
  final CreateOrderCubit cubit;
  final VoidCallback onSuccessFinished;
  final VoidCallback onErrorFinished;

  const _OrderStatusDialog({
    required this.cubit,
    required this.onSuccessFinished,
    required this.onErrorFinished,
  });

  @override
  State<_OrderStatusDialog> createState() => _OrderStatusDialogState();
}

class _OrderStatusDialogState extends State<_OrderStatusDialog> {
  bool _finishedTriggered = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 50),
      child: BlocConsumer<CreateOrderCubit, ResultState<CreateOrderModel>>(
        bloc: widget.cubit,
        listener: (context, state) {
          if (_finishedTriggered) return;

          state.whenOrNull(
            success: (_) async {
              _finishedTriggered = true;
              await Future.delayed(const Duration(seconds: 2));
              widget.onSuccessFinished();
            },
            error: (_) async {
              _finishedTriggered = true;
              await Future.delayed(const Duration(seconds: 2));
              widget.onErrorFinished();
            },
          );
        },
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: AppColors.darkGlassGradient,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.borderColorLight),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 30,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  transitionBuilder: (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
                  child: state.when(
                    idle: () => _buildSpinner(key: const ValueKey('spinner')),
                    loading: () =>
                        _buildSpinner(key: const ValueKey('spinner')),
                    success: (_) => _buildIcon(
                      key: const ValueKey('success'),
                      icon: Icons.check_rounded,
                      color: AppColors.successColor,
                    ),
                    error: (_) => _buildIcon(
                      key: const ValueKey('error'),
                      icon: Icons.close_rounded,
                      color: AppColors.errorColor,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  state.when(
                    idle: () => 'جاري إرسال الطلب...',
                    loading: () => 'جاري إرسال الطلب...',
                    success: (response) =>
                        response.message ?? 'تم إرسال الطلب بنجاح',
                    error: (message) => message,
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSpinner({required Key key}) {
    return SizedBox(
      key: key,
      width: 64,
      height: 64,
      child: CircularProgressIndicator(
        strokeWidth: 4,
        color: AppColors.accentColor,
      ),
    );
  }

  Widget _buildIcon({
    required Key key,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      key: key,
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.15),
        border: Border.all(color: color, width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 18,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Icon(icon, color: color, size: 34),
    );
  }
}
