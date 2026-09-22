import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/color/colors.dart';
import '../../../cubits/orderCubit/acceptCubit/acceptOrder_cubit.dart';
import '../../../cubits/results_state.dart';
import '../../../models/orders/accept_order/accept_order_model.dart';
import '../../../models/orders/get_all_orders/get_all_orders_model.dart';

class AcceptOrderScreen extends StatelessWidget {
  final OrderModel order;

  const AcceptOrderScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AcceptOrderCubit, ResultState<AcceptOrderModel>>(
      listener: (context, state) {
        state.whenOrNull(
          success: (data) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(data.message ?? 'تم قبول الطلب')),
            );

            Navigator.pop(context, true);
          },
          error: (message) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message)));
          },
        );
      },
      builder: (context, state) {
        final isLoading = state.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: AppColors.backgroundColor,
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              backgroundColor: AppColors.backgroundColor,
              title: Text(
                'تفاصيل وقبول الطلب',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.cardColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'رقم الطلب',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '#${order.id?.substring(0, 8) ?? ''}',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'الإجمالي',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${order.totalPrice ?? 0} ل.س',
                          style: TextStyle(
                            color: AppColors.accentColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'الأصناف',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...(order.items ?? []).map(
                    (item) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: item.menuItem?.imageUrl != null
                                ? Image.network(
                                    item.menuItem!.imageUrl!,
                                    width: 55,
                                    height: 55,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    width: 55,
                                    height: 55,
                                    color: Colors.grey.shade300,
                                    child: const Icon(Icons.fastfood),
                                  ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.menuItem?.name ?? '',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${item.unitPrice ?? 0} ل.س',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.accentColor.withOpacity(.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'x${item.quantity}',
                              style: TextStyle(
                                color: AppColors.accentColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.successColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: isLoading
                          ? null
                          : () {
                              context.read<AcceptOrderCubit>().acceptOrder(
                                orderId: order.id!,
                              );
                            },
                      icon: isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.check_circle, color: Colors.white),
                      label: Text(
                        isLoading ? 'جاري القبول...' : 'تأكيد القبول',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
