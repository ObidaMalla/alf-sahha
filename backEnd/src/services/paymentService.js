import { prisma } from "../config/prisma.js";
import { ApiError } from "../utils/ApiError.js";

import { createNotification } from "./notificationService.js";

// تعريف وتصدير دالة غير متزامنة لدفع الطلب تستقبل معرف الطلب ومعرف الزبون
export const payOrder = async (orderId, customerId) => {

  // فتح معاملة قاعدة بيانات (Transaction) لضمان تنفيذ كل العمليات بنجاح أو التراجع عنها معاً
  return prisma.$transaction(async (tx) => {

    // تنفيذ تحديث مشروط لجدول الطلبات لمنع تكرار الدفع (Idempotency / Race Condition)
    const updateResult = await tx.order.updateMany({

      // الشرط: يجب أن يكون الطلب بالمعرف المحدد، حالته ACCEPTED، ويخص هذا الزبون تحديداً
      where: { id: orderId, status: "ACCEPTED", customerId },

      // البيانات الجديدة: تغيير الحالة إلى PREPARING وتسجيل وقت الدفع الحالي
      data: { status: "PREPARING", paidAt: new Date() },
    });

    // التحقق مما إذا تم تعديل أي سجل (إذا كان 0 فهذا يعني أن الشرط لم يتحقق والطلب تم معالجته مسبقاً أو غير صالح)
    if (updateResult.count === 0) {

      // البحث عن الطلب في قاعدة البيانات لمعرفة سبب الفشل بالتحديد
      const order = await tx.order.findUnique({ where: { id: orderId } });

      // إذا لم يتم العثور على الطلب نهائياً، رمي خطأ 404
      if (!order) throw new ApiError(404, "الطلب غير موجود أصلاً");

      // إذا كان الطلب يعود لزبون آخر، رمي خطأ 403
      if (order.customerId !== customerId) throw new ApiError(403, "هذا الطلب ليس لك");

      // إذا كان بحالة غير ACCEPTED، رمي خطأ 409
      throw new ApiError(409, "الطلب مش بحالة تسمح بالدفع احتمال  انرفض، أو اندفع مسبقاً");
    }

    // جلب بيانات الطلب الكاملة بعد التأكد من نجاح التحديث الأولي
    const order = await tx.order.findUnique({ where: { id: orderId } });

    // جلب بيانات الزبون للتحقق من رصيده المالي
    const customer = await tx.user.findUnique({ where: { id: customerId } });

    // مقارنة رصيد الزبون مع السعر الإجمالي للطلب
    if (Number(customer.walletBalance) < Number(order.totalPrice)) {

      // رمي خطأ 400 وتفعيل Rollback تلقائي للترانزاكشن إذا كان الرصيد غير كافٍ
      throw new ApiError(400, "رصيدك غير كافٍ لإتمام عملية الدفع");
    }

    // جلب بيانات المطعم لمعرفة معرف المالك (ownerId)
    const restaurant = await tx.restaurant.findUnique({ where: { id: order.restaurantId } });

    // خصم المبلغ من رصيد الزبون
    await tx.user.update({

      // تحديد الزبون المراد تعديل رصيده
      where: { id: customerId },

      // خصم السعر الإجمالي من رصيد الزبون
      //decrement خاصية جاهزة في prisma ORM للتنقيص بال DB
      data: { walletBalance: { decrement: order.totalPrice } },
    });

    // إضافة المبلغ إلى رصيد صاحب المطعم
    await tx.user.update({

      // تحديد مالك المطعم المراد زيادة رصيده
      where: { id: restaurant.ownerId },

      // إضافة السعر الإجمالي إلى رصيد المالك
      data: { walletBalance: { increment: order.totalPrice } },
    });

    // إنشاء سجل معاملة مالية جديدة في جدول المعاملات للأرشفة
    await tx.transaction.create({

      // تمرير بيانات المعاملة المالية
      data: {
        // معرف الطلب المرتبط بالدفع
        orderId,
        // معرف المستخدم المرسل للمبلغ (الزبون)
        fromUserId: customerId,
        // معرف المستخدم المستقبل للمبلغ (مالك المطعم)
        toUserId: restaurant.ownerId,
        // قيمة المبلغ المدفوع
        amount: order.totalPrice,
        // تحديد نوع المعاملة كدفع طلب
        type: "ORDER_PAYMENT",
      },
    });
    if (order.handledByUserId) {
  await createNotification(
    {
      userId: order.handledByUserId,
      orderId: order.id,
      type: "PAYMENT_RECEIVED",
      message: "تم الدفع للطلبية، جهزها",
    },
    tx
  );
}

    // إرجاع كائن الطلب بعد اكتمال المعاملة بنجاح
    return order;
  });
};