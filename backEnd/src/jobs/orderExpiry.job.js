//فـ .job.js تعني أن هذا الملف خاص بمهام مجدولة تعمل في الخلفية (Cron Jobs).
// استيراد مكتبة node-cron لجدولة المهام وتلك التي تعمل في أوقات محددة أو بشكل دوري
import cron from "node-cron";

import { prisma } from "../config/prisma.js";

// استيراد دالة إنشاء الإشعارات لإرسال تنبيهات للزبون أو الموظف
import { createNotification } from "../services/notificationService.js";

// تحديد الحد الأقصى للمهلة بالدقائق (5 دقائق مثلاً) قبل اعتبار الطلب منتهي الصلاحية
const EXPIRY_MINUTES = 5;

// تعريف وتصدير دالة تبدأ تشغيل مهمة مراقبة وانتهاء الطلبات المجدولة
export const startOrderExpiryJob = () => {
  
  // جدولة المهمة لتعمل تلقائياً كل دقيقة باستخدام التعبير الزمني (* * * * *)
  cron.schedule("* * * * *", async () => {
    
    // حساب الوقت الحدّي المسموح به (الوقت الحالي ناقص 5 دقائق)
    const cutoff = new Date(Date.now() - EXPIRY_MINUTES * 60 * 1000);

    // البحث في قاعدة البيانات عن الطلبات التي ما زالت بحالة قيد الانتظار وتاريخ إنشائها أقدم من الوقت المسموح (cutoff)
    const candidates = await prisma.order.findMany({
      where: { status: "PENDING", createdAt: { lt: cutoff } },
    });

    // المرور على كل طلب من الطلبات المرشحة لانتهاء الصلاحية عبر حلقة تكرار
    for (const order of candidates) {
      
      // تحديث حالة الطلب إلى EXPIRED بشكل آمن ومشروط لمنع التعارض، وتسجيل وقت انتهاء الصلاحية
      const result = await prisma.order.updateMany({
        where: { id: order.id, status: "PENDING" },
        data: { status: "EXPIRED", expiredAt: new Date() },
      });

      // إذا كانت النتيجة 0، فهذا يعني أن الطلب تم تغييره أو معالجته من قبل عملية أخرى، فيتم تخطيه
      if (result.count === 0) continue;

      // إنشاء وإرسال إشعار للزبون صاحب الطلب يخبره أن مهلة القبول قد انتهت
      await createNotification({
        userId: order.customerId,
        orderId: order.id,
        type: "ORDER_EXPIRED_CUSTOMER",
        message: "انتهت مهلة القبول، يرجى إعادة إرسال الطلب",
      });

    // جلب جميع موظفي المطعم المرتبطين بهذا الطلب لتنبيههم
      const staff = await prisma.restaurantStaff.findMany({
        where: { restaurantId: order.restaurantId },
        select: { userId: true },
      });

      // المرور على كل موظف وإرسال إشعار انتهاء المهلة له
      for (const s of staff) {
        await createNotification({
          userId: s.userId,
          orderId: order.id,
          type: "ORDER_EXPIRED_EMPLOYEE",
          message: `طلبية تجاوزت وقت القبول: ${order.id}`,
        });
      }
    }
  });
};
/*
كيف يعمل هذا الكود خطوة بخطوة؟
الجدولة (cron.schedule("* * * * *", ...)):

الرمز * * * * * يعني أن هذه المهمة ستعمل تلقائياً كل دقيقة في الخلفية.

تحديد الوقت الحدّي (cutoff):

يقوم بحساب الوقت الحالي وينقص منه 5 دقائق (EXPIRY_MINUTES = 5). أي طلب مر عليه أكثر من 5 دقائق وبقي بحالة PENDING يعتبر متأخراً.

البحث عن الطلبات منتهية الصلاحية (candidates):

يبحث عن كل الطلبات التي حالتها PENDING وتاريخ إنشاءها (createdAt) أقدم من الوقت الحدّي (lt: cutoff).

التحديث الآمن لمنع التعارض (updateMany):

يقوم بتحديث حالة الطلب إلى EXPIRED وتسجيل وقت انتهاء الصلاحية. وإذا تم تحديثه بنجاح، يقوم بـ:

إرسال إشعار للزبون يخبره أن مهلة القبول انتهت.

إرسال إشعار لموظف المطعم لتنبيهه بوجود طلبية تجاوزت وقت القبول وتم إلغاؤها. */