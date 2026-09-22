import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/color/colors.dart';
import '../../../cubits/orderCubit/completeCubit/complete_order_cubit.dart';
import '../../../cubits/results_state.dart';
import '../../../injections/bootStrap/auth/_login/login_injection.dart';
import '../../../models/orders/completeOrder/complete_order_model.dart';

class CompleteOrderButton extends StatefulWidget {
  final String orderId;
  final VoidCallback? onCompleted;

  const CompleteOrderButton({
    super.key,
    required this.orderId,
    this.onCompleted,
  });

  @override
  State<CompleteOrderButton> createState() => _CompleteOrderButtonState();
}

class _CompleteOrderButtonState extends State<CompleteOrderButton> {
  late final CompleteOrderCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<CompleteOrderCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<CompleteOrderCubit, ResultState<CompleteOrderModel>>(
        listener: (context, state) {
          state.whenOrNull(
            success: (data) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(data.message ?? 'تم تجهيز الطلب 🎉'),
                  backgroundColor: AppColors.successColor,
                ),
              );
              widget.onCompleted?.call();
            },
            error: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                  backgroundColor: AppColors.errorColor,
                ),
              );
            },
          );
        },
        builder: (context, state) {
          final isLoading = state.maybeWhen(
            loading: () => true,
            orElse: () => false,
          );

          return SizedBox(
            height: 44,
            child: ElevatedButton.icon(
              onPressed: isLoading
                  ? null
                  : () => _cubit.completeOrder(orderId: widget.orderId),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentColor,
                disabledBackgroundColor: AppColors.accentColor.withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: isLoading
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.backgroundColor,
                      ),
                    )
                  : Icon(
                      Icons.check_circle_outline_rounded,
                      color: AppColors.backgroundColor,
                      size: 18,
                    ),
              label: Text(
                'تم تجيز الطلبية',
                style: TextStyle(
                  color: AppColors.backgroundColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
