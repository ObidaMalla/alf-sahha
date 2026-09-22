import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/notifications/notifications_model.dart';
import '../../responses/response_notifications/notifications_repo.dart';

class NotificationsState {
  final List<NotificationItem> items;
  final bool isLoading;
  final String? error;

  const NotificationsState({
    this.items = const [],
    this.isLoading = false,
    this.error,
  });

  NotificationsState copyWith({
    List<NotificationItem>? items,
    bool? isLoading,
    String? error,
  }) {
    return NotificationsState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepository notificationsRepo;
  NotificationsCubit(this.notificationsRepo)
    : super(const NotificationsState());

  Future<void> loadNotifications() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final response = await notificationsRepo.getNotifications();
      emit(state.copyWith(items: response.data ?? [], isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> markAsRead(String id) async {
    final target = state.items.firstWhere(
      (n) => n.id == id,
      orElse: () => NotificationItem(),
    );
    if (target.isRead == true) return; // أصلاً مقروء

    // تحديث متفائل فوري
    final updated = state.items.map((n) {
      if (n.id == id) n.isRead = true;
      return n;
    }).toList();
    emit(state.copyWith(items: updated));

    try {
      await notificationsRepo.markAsRead(id);
    } catch (_) {
      // فشل السيرفر ⟶ رجّع الحالة القديمة
      final reverted = state.items.map((n) {
        if (n.id == id) n.isRead = false;
        return n;
      }).toList();
      emit(state.copyWith(items: reverted));
    }
  }

  Future<void> deleteNotification(String id) async {
    final previousItems = state.items;
    final updated = state.items.where((n) => n.id != id).toList();
    emit(state.copyWith(items: updated));

    try {
      await notificationsRepo.deleteNotification(id);
    } catch (_) {
      emit(state.copyWith(items: previousItems)); // رجّعها لو فشل الحذف
    }
  }
}
