import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/color/colors.dart';
import '../../cubits/notifications/UnreadCountCubit.dart';
import '../../cubits/notifications/notifications_cubit.dart';
import '../../injections/bootStrap/auth/_login/login_injection.dart';
import '../../models/notifications/notifications_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final NotificationsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<NotificationsCubit>();
    _cubit.loadNotifications();
  }

  // ============================================================
  // تحويل نوع الإشعار (كود خام) لأيقونة ولون مناسبين
  // ============================================================
  IconData _typeIcon(String? type) {
    switch (type) {
      case 'WELCOME':
        return Icons.waving_hand_rounded;
      case 'ORDER_ACCEPTED':
        return Icons.check_circle_rounded;
      case 'ORDER_READY':
        return Icons.soup_kitchen_rounded;
      case 'ORDER_REJECTED':
        return Icons.cancel_rounded;
      case 'ORDER_EXPIRED_CUSTOMER':
        return Icons.timer_off_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Color _typeColor(String? type) {
    switch (type) {
      case 'WELCOME':
        return AppColors.goldColor;
      case 'ORDER_ACCEPTED':
      case 'ORDER_READY':
        return AppColors.successColor;
      case 'ORDER_REJECTED':
      case 'ORDER_EXPIRED_CUSTOMER':
        return AppColors.errorColor;
      default:
        return AppColors.accentColor;
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

  void _onTapNotification(NotificationItem item) {
    if (item.isRead != true && item.id != null) {
      _cubit.markAsRead(item.id!);
      // 👇 تحديث عداد الجرس بمكان تاني بالتطبيق فوراً
      getIt<UnreadCountCubit>().fetchUnreadCount();
    }
  }

  void _confirmDelete(NotificationItem item) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          'حذف الإشعار',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          'هل تريد حذف هذا الإشعار؟',
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
              _cubit.deleteNotification(item.id!);
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
            'الإشعارات',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
        ),
        body: BlocBuilder<NotificationsCubit, NotificationsState>(
          bloc: _cubit,
          builder: (context, state) {
            if (state.isLoading && state.items.isEmpty) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.accentColor),
              );
            }

            if (state.error != null && state.items.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: AppColors.errorColor,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      state.error!,
                      style: TextStyle(color: AppColors.errorColor),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _cubit.loadNotifications(),
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
              );
            }

            if (state.items.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.notifications_off_outlined,
                      color: AppColors.textMuted,
                      size: 56,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'لا توجد إشعارات حالياً',
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
              onRefresh: () async => _cubit.loadNotifications(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.items.length,
                itemBuilder: (context, index) =>
                    _buildNotificationTile(state.items[index]),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNotificationTile(NotificationItem item) {
    final isRead = item.isRead ?? false;
    final typeColor = _typeColor(item.type);

    return InkWell(
      onTap: () => _onTapNotification(item),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          // 👇 اللون الأساسي بيفرق حسب حالة القراءة (زي ما طلبت)
          color: isRead ? AppColors.cardColor : typeColor.withOpacity(0.12),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isRead ? AppColors.borderColor : typeColor.withOpacity(0.4),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: typeColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(_typeIcon(item.type), color: typeColor, size: 19),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (!isRead)
                        Container(
                          margin: const EdgeInsets.only(left: 6),
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      Expanded(
                        child: Text(
                          item.message ?? '',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: isRead
                                ? FontWeight.w600
                                : FontWeight.bold,
                            fontSize: 13.5,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _formatDate(item.createdAt),
                    style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.delete_outline_rounded,
                color: AppColors.errorColor.withOpacity(0.8),
                size: 19,
              ),
              onPressed: () => _confirmDelete(item),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
          ],
        ),
      ),
    );
  }
}
