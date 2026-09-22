import { asyncHandler } from "../utils/asyncHandler.js";
import { successHandler } from "../handlers/successHandler.js";
import { 
  listNotifications, 
  markAsRead, 
  getUnreadCount, 
  deleteNotification 
} from "../services/notificationService.js";

export const list = asyncHandler(async (req, res) => {
  const notifications = await listNotifications(req.user.id);
  return successHandler(res, 200, "تم جلب الإشعارات بنجاح", notifications);
});

// 👇 **جديد:** جلب عدد الإشعارات غير المقروءة
export const unreadCount = asyncHandler(async (req, res) => {
  const result = await getUnreadCount(req.user.id);
  return successHandler(res, 200, "تم جلب عدد الإشعارات غير المقروءة بنجاح", result);
});

export const read = asyncHandler(async (req, res) => {
  const notification = await markAsRead(req.params.id, req.user.id);
  return successHandler(res, 200, "تم تعليم الإشعار كمقروء", notification);
});

// 👇 **جديد:** حذف إشعار معين
export const remove = asyncHandler(async (req, res) => {
  await deleteNotification(req.params.id, req.user.id);
  return successHandler(res, 200, "تم حذف الإشعار بنجاح");
});