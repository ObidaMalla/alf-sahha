import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/color/colors.dart';
import '../../../cubits/orderCubit/payCubit/pay_order_cubit.dart';
import '../../../cubits/results_state.dart';
import '../../../injections/bootStrap/auth/_login/login_injection.dart';
import '../../../models/orders/pay/pay_order_model.dart';

class PayOrderScreen extends StatefulWidget {
  final String orderId;
  final VoidCallback?
  onPaid; // 👈 يُستدعى بعد نجاح الدفع (لتحديث شاشة التفاصيل مثلاً)

  const PayOrderScreen({super.key, required this.orderId, this.onPaid});

  @override
  State<PayOrderScreen> createState() => _PayOrderScreenState();
}

class _PayOrderScreenState extends State<PayOrderScreen> {
  late final PayOrderCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<PayOrderCubit>();
  }

  void _confirmAndPay() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          'تأكيد الدفع',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          'هل تريد المتابعة لدفع قيمة هذا الطلب؟',
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
              _startPayment();
            },
            child: Text(
              'ادفع الآن',
              style: TextStyle(
                color: AppColors.accentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _startPayment() {
    _cubit.payOrder(widget.orderId);
    _showStatusDialog();
  }

  void _showStatusDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (dialogContext) {
        return _PayStatusDialog(
          cubit: _cubit,
          onSuccessFinished: () {
            Navigator.of(dialogContext).pop();
            widget.onPaid?.call();
          },
          onErrorFinished: () {
            Navigator.of(dialogContext).pop(); // البقاء بالشاشة للمحاولة مجدداً
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _confirmAndPay,
      child: Container(
        height: 54,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: AppColors.goldGradient),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.goldColor.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.payment_rounded, color: Colors.black87, size: 20),
            const SizedBox(width: 8),
            const Text(
              'ادفع الآن',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// 💠 نافذة حالة الدفع — Loading ⟶ Success ✅ / Error ❌
// ============================================================
class _PayStatusDialog extends StatefulWidget {
  final PayOrderCubit cubit;
  final VoidCallback onSuccessFinished;
  final VoidCallback onErrorFinished;

  const _PayStatusDialog({
    required this.cubit,
    required this.onSuccessFinished,
    required this.onErrorFinished,
  });

  @override
  State<_PayStatusDialog> createState() => _PayStatusDialogState();
}

class _PayStatusDialogState extends State<_PayStatusDialog> {
  bool _finishedTriggered = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 50),
      child: BlocConsumer<PayOrderCubit, ResultState<PayOrderModel>>(
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
                    idle: () => 'جاري تنفيذ الدفع...',
                    loading: () => 'جاري تنفيذ الدفع...',
                    success: (response) => response.message ?? 'تم الدفع بنجاح',
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
