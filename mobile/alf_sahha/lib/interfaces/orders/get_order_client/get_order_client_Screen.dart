import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/color/colors.dart';
import '../../../cubits/orderCubit/getOrderClientCubit/getOrderClient_cubit.dart';
import '../../../cubits/results_state.dart';
import '../../../injections/bootStrap/auth/_login/login_injection.dart';
import '../../../models/orders/getOrderClient/getOrderClient_model.dart';
import '../payOrder/payOrderScreen.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  late final MyOrdersCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<MyOrdersCubit>();
    _cubit.getMyOrders();
  }

  // ============================================================
  // تحويل حالة الطلب (كود خام) لنص + لون عربي واضح
  // ============================================================
  String _statusLabel(String? status) {
    switch (status) {
      case 'PENDING':
        return 'قيد الانتظار';
      case 'ACCEPTED':
        return 'مقبول - بانتظار الدفع';
      case 'PREPARING':
        return 'قيد التحضير';
      case 'COMPLETED':
        return 'مكتمل';
      case 'REJECTED':
        return 'مرفوض';
      case 'EXPIRED':
        return 'منتهي الصلاحية';
      default:
        return status ?? '';
    }
  }

  Color _statusColor(String? status) {
    switch (status) {
      case 'PENDING':
        return AppColors.goldColor;
      case 'ACCEPTED':
        return AppColors.infoColor;
      case 'PREPARING':
        return AppColors.accentColor;
      case 'COMPLETED':
        return AppColors.successColor;
      case 'REJECTED':
      case 'EXPIRED':
        return AppColors.errorColor;
      default:
        return AppColors.textMuted;
    }
  }

  IconData _statusIcon(String? status) {
    switch (status) {
      case 'PENDING':
        return Icons.hourglass_top_rounded;
      case 'ACCEPTED':
        return Icons.payment_rounded;
      case 'PREPARING':
        return Icons.soup_kitchen_rounded;
      case 'COMPLETED':
        return Icons.check_circle_rounded;
      case 'REJECTED':
        return Icons.cancel_rounded;
      case 'EXPIRED':
        return Icons.timer_off_rounded;
      default:
        return Icons.receipt_long_rounded;
    }
  }

  String _formatDate(String? isoDate) {
    if (isoDate == null) return '';
    try {
      final parsed = DateTime.parse(isoDate).toLocal();
      final dayNames = [
        'الإثنين',
        'الثلاثاء',
        'الأربعاء',
        'الخميس',
        'الجمعة',
        'السبت',
        'الأحد',
      ];
      final dayName = dayNames[parsed.weekday - 1];
      final hour12 = parsed.hour % 12 == 0 ? 12 : parsed.hour % 12;
      final period = parsed.hour >= 12 ? 'مساءً' : 'صباحاً';
      final minute = parsed.minute.toString().padLeft(2, '0');
      return '$dayName $hour12:$minute $period';
    } catch (_) {
      return isoDate;
    }
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
            'طلباتي',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
        ),
        body: BlocBuilder<MyOrdersCubit, ResultState<MyOrdersModel>>(
          bloc: _cubit,
          builder: (context, state) {
            return state.when(
              idle: () => const SizedBox.shrink(),
              loading: () => Center(
                child: CircularProgressIndicator(color: AppColors.accentColor),
              ),
              error: (msg) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: AppColors.errorColor,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    Text(msg, style: TextStyle(color: AppColors.errorColor)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _cubit.getMyOrders(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentColor,
                      ),
                      child: const Text(
                        'إعادة المحاولة',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              success: (model) {
                final orders = model.data ?? [];

                if (orders.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          color: AppColors.textMuted,
                          size: 60,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'لا توجد طلبات بعد',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  color: AppColors.accentColor,
                  onRefresh: () async => _cubit.getMyOrders(),
                  child: ListView.builder(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 16,
                      bottom: 216, // مسافة 200 بكسل إضافية تحت آخر كارد
                    ),
                    itemCount: orders.length,
                    itemBuilder: (context, index) =>
                        _buildOrderCard(orders[index]),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildOrderCard(MyOrderItem order) {
    final statusColor = _statusColor(order.status);
    final items = order.items ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.darkGlassGradient,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: statusColor.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الهيدر — رقم الطلب + الحالة
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'طلب #${order.id?.substring(0, 8) ?? ''}',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor.withOpacity(0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _statusIcon(order.status),
                      size: 13,
                      color: statusColor,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      _statusLabel(order.status),
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            _formatDate(order.createdAt),
            style: TextStyle(color: AppColors.textMuted, fontSize: 11),
          ),

          // سبب الرفض إذا موجود
          if (order.status == 'REJECTED' && order.rejectionReason != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.errorColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'سبب الرفض: ${order.rejectionReason}',
                style: TextStyle(color: AppColors.errorColor, fontSize: 12),
              ),
            ),
          ],

          const SizedBox(height: 14),
          Divider(color: AppColors.borderColor, height: 1),
          const SizedBox(height: 12),

          // قائمة الأصناف
          ...items.map((item) => _buildLineItem(item)),

          const SizedBox(height: 12),
          Divider(color: AppColors.borderColor, height: 1),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الإجمالي',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${order.totalPrice ?? '0'} ل.س',
                style: TextStyle(
                  color: AppColors.accentColor,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),

          // زر الدفع — بس إذا الطلب ACCEPTED (مقبول ولسا ما انندفع)
          if (order.status == 'ACCEPTED') ...[
            const SizedBox(height: 14),
            PayOrderScreen(
              orderId: order.id!,
              onPaid: () => _cubit.getMyOrders(), // 👈 تحديث القائمة بعد الدفع
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLineItem(OrderLineItem item) {
    final menuItem = item.menuItem;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: menuItem?.imageUrl != null && menuItem!.imageUrl!.isNotEmpty
                ? Image.network(
                    menuItem.imageUrl!,
                    width: 46,
                    height: 46,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholderThumb(),
                  )
                : _placeholderThumb(),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.quantity ?? 1}× ${menuItem?.name ?? 'صنف'}',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5,
                  ),
                ),
                if (item.note != null && item.note!.trim().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      item.note!,
                      style: TextStyle(
                        color: AppColors.goldColor,
                        fontSize: 11,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Text(
            '${item.unitPrice ?? '0'} ل.س',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholderThumb() {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: AppColors.accentColorSoft,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        Icons.fastfood_rounded,
        color: AppColors.accentColor,
        size: 20,
      ),
    );
  }
}
