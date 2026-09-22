import 'package:flutter_bloc/flutter_bloc.dart';

import '../../responses/response_notifications/notifications_repo.dart';

class UnreadCountCubit extends Cubit<int> {
  final NotificationsRepository notificationsRepo;
  UnreadCountCubit(this.notificationsRepo) : super(0);

  Future<void> fetchUnreadCount() async {
    try {
      final response = await notificationsRepo.getUnreadCount();
      emit(response.data?.unreadCount ?? 0);
    } catch (_) {}
  }

  void reset() => emit(0);
}
