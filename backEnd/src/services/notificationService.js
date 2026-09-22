import { prisma } from "../config/prisma.js";
import { ApiError } from "../utils/ApiError.js";
import messaging from "../config/firebase.js"; // 👈 جديد

// تعريف دالة غير متزامنة لإنشاء إشعار جديد في قاعدة البيانات
export const createNotification = async (
  // استقبال كائن يحتوي على بيانات الإشعار، مع تعيين قيمة افتراضية لـ orderId بـ null
  //  إن لم تُرسل
  { userId, orderId = null, type, message },

  // استقبال معامل اختياري للعميل، وقيمته الافتراضية هي Prisma العادي أو معاملة (tx)
  /*
  await prisma.$transaction(async (tx) => {
  await tx.order.update({ where: { id: 1 }, data: { status: 'COMPLETED' } });
  await createNotification({
    userId: "user_123",
    orderId: 1,
    type: "ORDER_COMPLETED",
    message: "تم إكمال طلبك بنجاح"
  }, tx); // 👈 تمرير الـ tx هنا يضمن حفظ الإشعار فقط إذا نجحت العملية بالكامل
});
  */
  client = prisma
) => {

  // استخدام العميل المحدد (سواء prisma أو tx) لإنشاء سجل إشعار جديد بالبيانات المطلوبة
  const notification = await client.notification.create({

    // تمرير البيانات المراد إدخالها في جدول الإشعارات
    data: { userId, orderId, type, message },
  });

  // 2. 👇 جديد — إرسال Push إذا عند المستخدم fcmToken
  const user = await client.user.findUnique({
    where: { id: userId },
    select: { fcmToken: true },
  });

  if (user?.fcmToken) {
    await sendPushNotification(userId, user.fcmToken, type, message, orderId);
  }

  return notification;
};

// دالة مستقلة لإرسال الـ Push فقط
const sendPushNotification = async (userId, fcmToken, type, message, orderId) => {
  try {
    await messaging.send({
      token: fcmToken,
      notification: {
        title: "مطعمك", // 👈 عدّل لاسم تطبيقك (Flavor House مثلاً)
        body: message,
      },
      data: {
        type: type ?? "",
        orderId: orderId ? String(orderId) : "",
      },
    });
  } catch (err) {
    console.error("فشل إرسال Push:", err.message);

    // تنظيف التوكن الفاسد تلقائياً حتى ما نعيد المحاولة عليه لاحقاً
    if (
      err.code === "messaging/invalid-registration-token" ||
      err.code === "messaging/registration-token-not-registered"
    ) {
      await prisma.user.update({
        where: { id: userId },
        data: { fcmToken: null },
      }).catch(() => {});
    }
  }
};

// تعريف دالة غير متزامنة لجلب واستعراض قائمة إشعارات مستخدم معين
export const listNotifications = async (userId) => {

  // استخدام prisma للبحث وجلب جميع الإشعارات التي تطابق معرف المستخدم
  return prisma.notification.findMany({

    // شرط البحث بحيث يكون معرف المستخدم مطابقاً للمدخل
    where: { userId },

    // ترتيب النتائج تنازلياً (الأحدث أولاً) بناءً على تاريخ الإنشاء
    orderBy: { createdAt: "desc" },
  });
};

// تعريف دالة غير متزامنة لتحديث حالة إشعار معين ليصبح مقروءً
export const markAsRead = async (notificationId, userId) => {

  // البحث في قاعدة البيانات عن إشعار فريد بواسطة معرف الإشعار الخاص به
  const notification = await prisma.notification.findUnique({

    // شرط البحث باستخدام معرف الإشعار
    where: { id: notificationId },
  });

  // التحقق مما إذا كان الإشعار غير موجود أصلاً، أو أن معرف المستخدم لا يطابق صاحب الإشعار للحماية
  if (!notification || notification.userId !== userId) {

    // رمي خطأ برمز 404 (غير موجود) مع رسالة توضيحية
    throw new ApiError(404, "😊الإشعار غير موجود");
  }

  // استخدام prisma لتحديث السجل الموجود في قاعدة البيانات
  return prisma.notification.update({

    // تحديد الإشعار المراد تحديثه بواسطة معرفه
    where: { id: notificationId },

    // تغيير قيمة حقل القراءة إلى صحيح للإشارة إلى أنه تم قراءته
    data: { isRead: true },
  });
};

// تعريف دالة غير متزامنة لجلب عدد الإشعارات غير المقروءة
export const getUnreadCount = async (userId) => {

  // حساب عدد الإشعارات غير المقروءة الخاصة بالمستخدم الحالي
  const count = await prisma.notification.count({
    where: {
      userId,
      isRead: false,
    },
  });
  return { unreadCount: count };
};

// تعريف دالة غير متزامنة لحذف إشعار معين
export const deleteNotification = async (notificationId, userId) => {

  // البحث عن الإشعار للتأكد من وجوده وملكفته للمستخدم
  const notification = await prisma.notification.findUnique({
    where: { id: notificationId },
  });

  // التحقق من صحة وجود الإشعار وأنه يتبع لنفس المستخدم لحماية البيانات
  if (!notification || notification.userId !== userId) {
    throw new ApiError(404, "😊الإشعار غير موجود أو لا تملك صلاحية حذفه");
  }

  // حذف الإشعار من قاعدة البيانات
  return prisma.notification.delete({
    where: { id: notificationId },
  });
};