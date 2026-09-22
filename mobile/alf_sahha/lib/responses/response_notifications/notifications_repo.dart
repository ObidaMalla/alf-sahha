import '../../models/notifications/notifications_model.dart';
import '../../routes/notifications/notifications_routes.dart';
import '../apiExceptionHandler.dart';

class NotificationsRepository {
  final NotificationsService notificationsService;
  NotificationsRepository(this.notificationsService);

  Future<NotificationsListModel> getNotifications() {
    return ApiExceptionHandler.handle<NotificationsListModel>(
          () => notificationsService.getNotifications(),
      fallbackErrorMessage: 'فشل جلب الإشعارات 🧨',
      isSuccess: (r) => r.success == true,
      extractMessage: (r) => r.message,
    );
  }

  Future<UnreadCountModel> getUnreadCount() {
    return ApiExceptionHandler.handle<UnreadCountModel>(
          () => notificationsService.getUnreadCount(),
      fallbackErrorMessage: 'فشل جلب عدد الإشعارات 🧨',
      isSuccess: (r) => r.success == true,
      extractMessage: (r) => r.message,
    );
  }

  Future<NotificationActionModel> markAsRead(String id) {
    return ApiExceptionHandler.handle<NotificationActionModel>(
          () => notificationsService.markAsRead(id),
      fallbackErrorMessage: 'فشل تعليم الإشعار كمقروء 🧨',
      isSuccess: (r) => r.success == true,
      extractMessage: (r) => r.message,
    );
  }

  Future<NotificationActionModel> deleteNotification(String id) {
    return ApiExceptionHandler.handle<NotificationActionModel>(
          () => notificationsService.deleteNotification(id),
      fallbackErrorMessage: 'فشل حذف الإشعار 🧨',
      isSuccess: (r) => r.success == true,
      extractMessage: (r) => r.message,
    );
  }
}