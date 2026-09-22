import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/color/colors.dart';
import '../../../cubits/orderCubit/rejectOrderCubit/reject_order_cubit.dart';
import '../../../cubits/results_state.dart';
import '../../../models/orders/get_all_orders/get_all_orders_model.dart';
import '../../../models/orders/reject_order/reject_order_model.dart';

class RejectOrderScreen extends StatefulWidget {
  final OrderModel order;

  const RejectOrderScreen({super.key, required this.order});

  @override
  State<RejectOrderScreen> createState() => _RejectOrderScreenState();
}

class _RejectOrderScreenState extends State<RejectOrderScreen> {
  final TextEditingController reasonController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    reasonController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;

    return BlocConsumer<RejectOrderCubit, ResultState<RejectOrderModel>>(
      listener: (context, state) {
        state.whenOrNull(
          success: (response) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(response.message ?? 'تم رفض الطلب بنجاح'),
                backgroundColor: AppColors.successColor,
                behavior: SnackBarBehavior.floating,
              ),
            );
            Navigator.pop(context, true);
          },
          error: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: AppColors.errorColor,
                behavior: SnackBarBehavior.floating,
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

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: AppColors.backgroundColor,
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              backgroundColor: AppColors.backgroundColor,
              title: Text(
                'رفض الطلب',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              iconTheme: IconThemeData(color: AppColors.textPrimary),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // بطاقة معلومات الطلب مع تحسين التوهج والعمق البصري
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.errorColor.withOpacity(0.12),
                          AppColors.cardColor,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: AppColors.errorColor.withOpacity(0.25),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.errorColor.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.errorColor.withOpacity(0.15),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.errorColor.withOpacity(0.3),
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.cancel_rounded,
                            color: AppColors.errorColor,
                            size: 45,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'تفاصيل الطلب المراد رفضه',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _infoRow(
                          'رقم الطلب',
                          '#${order.id?.substring(0, 8) ?? ''}',
                        ),
                        _infoRow('حالة الطلب', order.status ?? '-'),
                        _infoRow(
                          'الإجمالي الكلي',
                          '${order.totalPrice ?? 0} ل.س',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'الأصناف المطلوبة',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // قائمة الأصناف مع ظل خفيف لتخرج من الظلام
                  ...(order.items ?? []).map(
                    (item) => Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
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
                                    color: Colors.grey.shade800,
                                    child: const Icon(
                                      Icons.fastfood,
                                      color: Colors.white54,
                                    ),
                                  ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.menuItem?.name ?? '',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${item.unitPrice ?? 0} ل.س',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 13,
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
                              color: AppColors.errorColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'x${item.quantity}',
                              style: TextStyle(
                                color: AppColors.errorColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'سبب الرفض',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'إلزامي',
                        style: TextStyle(
                          color: AppColors.errorColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // حقل سبب الرفض مع تأثير توهج عند التركيز
                  TextField(
                    controller: reasonController,
                    focusNode: _focusNode,
                    maxLines: 4,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText: 'اكتب سبب الرفض بوضوح ليتم إرساله للعميل...',
                      hintStyle: TextStyle(
                        color: AppColors.textSecondary.withOpacity(0.5),
                        fontSize: 13.5,
                      ),
                      filled: true,
                      fillColor: AppColors.cardColor,
                      contentPadding: const EdgeInsets.all(16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide(
                          color: AppColors.errorColor,
                          width: 1.8,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // زر تأكيد الرفض مع ظل متوهج خفيف
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.errorColor.withOpacity(0.35),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.errorColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: isLoading
                          ? null
                          : () {
                              final reason = reasonController.text.trim();

                              if (reason.isEmpty) {
                                _focusNode.requestFocus();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      'يرجى كتابة سبب الرفض أولاً',
                                    ),
                                    backgroundColor: AppColors.warningColor,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                                return;
                              }

                              context.read<RejectOrderCubit>().rejectOrder(
                                orderId: order.id!,
                                reason: reason,
                              );
                            },
                      child: isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'تأكيد رفض الطلب',
                              style: TextStyle(
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

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          Text(
            value,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
