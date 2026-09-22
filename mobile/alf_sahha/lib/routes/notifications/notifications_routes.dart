import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../core/constants/api_constants.dart';
import '../../models/notifications/notifications_model.dart';

part 'notifications_routes.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class NotificationsService {
  factory NotificationsService(Dio dio, {String baseUrl}) =
      _NotificationsService;

  @GET('/notifications')
  Future<NotificationsListModel> getNotifications();

  @GET('/notifications/unread-count')
  Future<UnreadCountModel> getUnreadCount();

  @PATCH('/notifications/{id}/read')
  Future<NotificationActionModel> markAsRead(@Path('id') String id);

  @DELETE('/notifications/{id}')
  Future<NotificationActionModel> deleteNotification(@Path('id') String id);
}
