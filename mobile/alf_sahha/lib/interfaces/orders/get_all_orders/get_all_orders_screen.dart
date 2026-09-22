import 'package:alf_sahha/interfaces/orders/get_all_orders/pulsingGlowButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/color/colors.dart';
import '../../../cubits/orderCubit/getAllOrdersCubit/get_all_orders_cubit.dart';
import '../../../cubits/results_state.dart';
import '../../../injections/bootStrap/auth/_login/login_injection.dart';
import '../../../models/orders/get_all_orders/get_all_orders_model.dart';
import '../acceptOrder/acceptOrderScreen.dart';
import '../complete/completeOrderScreen.dart';
import '../rejectOrder/RejectOrderScreen.dart';

class GetAllOrdersScreen extends StatefulWidget {
  const GetAllOrdersScreen({super.key});

  @override
  State<GetAllOrdersScreen> createState() => _GetAllOrdersScreenState();
}

class _GetAllOrdersScreenState extends State<GetAllOrdersScreen> {
  late final GetAllOrdersCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<GetAllOrdersCubit>();
    _cubit.getAllOrders();
  }

  Future<void> _onRefresh() async {
    await _cubit.getAllOrders();
  }

  // ============================================================
  // ألوان + نصوص حالة الطلب
  // ============================================================
  Color _statusColor(String? status) {
    switch (status) {
      case 'PENDING':
        return AppColors.warningColor;
      case 'ACCEPTED':
        return AppColors.infoColor;
      case 'PREPARING':
        return Colors.orangeAccent;
      case 'COMPLETED':
        return AppColors.successColor;
      case 'REJECTED':
        return AppColors.errorColor;
      case 'EXPIRED':
        return AppColors.textMuted;
      default:
        return AppColors.textSecondary;
    }
  }

  String _statusLabel(String? status) {
    switch (status) {
      case 'PENDING':
        return 'قيد الانتظار';
      case 'ACCEPTED':
        return 'مقبول';
      case 'PREPARING':
        return 'قيد التجهيز';
      case 'COMPLETED':
        return 'مكتمل';
      case 'REJECTED':
        return 'مرفوض';
      case 'EXPIRED':
        return 'منتهي';
      default:
        return status ?? '';
    }
  }

  IconData _statusIcon(String? status) {
    switch (status) {
      case 'PENDING':
        return Icons.hourglass_top_rounded;
      case 'ACCEPTED':
        return Icons.check_circle_outline_rounded;
      case 'PREPARING':
        return Icons.restaurant_menu_rounded;
      case 'COMPLETED':
        return Icons.done_all_rounded;
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
      final hour12 = parsed.hour % 12 == 0 ? 12 : parsed.hour % 12;
      final period = parsed.hour >= 12 ? 'مساءً' : 'صباحاً';
      final minute = parsed.minute.toString().padLeft(2, '0');
      return '${parsed.day}/${parsed.month} - $hour12:$minute $period';
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
          backgroundColor: AppColors.backgroundSecondary,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'الطلبات',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
        ),
        body: BlocBuilder<GetAllOrdersCubit, ResultState<GetAllOrdersModel>>(
          bloc: _cubit,
          builder: (context, state) {
            return state.when(
              idle: () => const SizedBox.shrink(),
              loading: () => Center(
                child: CircularProgressIndicator(color: AppColors.accentColor),
              ),
              error: (message) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        color: AppColors.errorColor,
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.errorColor),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => _cubit.getAllOrders(),
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
              ),
              success: (response) {
                final orders = response.data ?? [];

                if (orders.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          color: AppColors.textMuted,
                          size: 64,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'لا توجد طلبات حالياً',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  color: AppColors.accentColor,
                  onRefresh: _onRefresh,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
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

  // ============================================================
  // كارت الطلب
  // ============================================================
  Widget _buildOrderCard(OrderModel order) {
    final color = _statusColor(order.status);
    final items = order.items ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================= HEADER =================
          Row(
            children: [
              Expanded(
                child: Text(
                  'طلب #${order.id?.substring(0, 8) ?? ''}',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 14.5,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: color.withOpacity(0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_statusIcon(order.status), size: 13, color: color),
                    const SizedBox(width: 5),
                    Text(
                      _statusLabel(order.status),
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
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
            style: TextStyle(color: AppColors.textMuted, fontSize: 11.5),
          ),

          const Divider(height: 22),

          // ================= ITEMS =================
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: item.menuItem?.imageUrl != null
                        ? Image.network(
                            item.menuItem!.imageUrl!,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                _buildTinyPlaceholder(),
                          )
                        : _buildTinyPlaceholder(),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      item.menuItem?.name ?? 'صنف',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  Text(
                    '×${item.quantity ?? 1}',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Divider(height: 22),

          // ================= TOTAL =================
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
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                ),
              ),
            ],
          ),

          // ================= REJECTION REASON =================
          if (order.status == 'REJECTED' &&
              order.rejectionReason != null &&
              order.rejectionReason!.isNotEmpty) ...[
            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.withOpacity(.25)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'سبب الرفض',
                    style: TextStyle(
                      color: AppColors.errorColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    order.rejectionReason!,
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
                ],
              ),
            ),
          ],

          // ================= ACTION BUTTONS (PENDING) =================
          if (order.status == 'PENDING') ...[
            const SizedBox(height: 18),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.successColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AcceptOrderScreen(order: order),
                          ),
                        );

                        if (result == true) {
                          _cubit.getAllOrders();
                        }
                      },
                      icon: const Icon(
                        Icons.check_circle_outline_rounded,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'قبول',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.errorColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RejectOrderScreen(order: order),
                          ),
                        );

                        if (result == true) {
                          _cubit.getAllOrders();
                        }
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'رفض',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],

          // ================= ACTION BUTTON (PREPARING) =================
          if (order.status == 'PREPARING') ...[
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: PulsingGlowButton(
                child: CompleteOrderButton(
                  orderId: order.id!,
                  onCompleted: () => _cubit.getAllOrders(),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTinyPlaceholder() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.accentColorSoft,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.fastfood_rounded,
        color: AppColors.accentColor,
        size: 18,
      ),
    );
  }
}
