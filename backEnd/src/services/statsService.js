import { prisma } from "../config/prisma.js";
import { ApiError } from "../utils/ApiError.js";

// دالة لجلب إحصائيات المطعم (مثل عدد الطلبات حسب حالتها وإجمالي الأرباح)
export const getRestaurantStats = async (restaurantId, ownerId) => {
  
  // 1. التحقق من وجود المطعم وأن المستخدم الحالي هو المالك الحقيقي له
  const restaurant = await prisma.restaurant.findUnique({ where: { id: restaurantId } });
  if (!restaurant || restaurant.ownerId !== ownerId) {
    throw new ApiError(403, "هذا المطعم ليس لك");
  }

  // 2. تجميع عدد الطلبات بناءً على حالتها (PENDING, ACCEPTED, إلخ) باستخدام groupBy
  const counts = await prisma.order.groupBy({
    by: ["status"],
    where: { restaurantId },
    _count: { status: true },
  });

  // تهيئة كائن افتراضي يحتوي على جميع الحالات بصفر كقيمة أوليّة
  const ordersByStatus = {
    PENDING: 0,
    ACCEPTED: 0,
    PREPARING: 0,
    COMPLETED: 0,
    REJECTED: 0,
    EXPIRED: 0,
  };

  // 3. تعبئة الأعداد الفعلية المسترجعة من قاعدة البيانات وتثبيتها في الكائن
  let totalOrders = 0;
  for (const c of counts) {
    ordersByStatus[c.status] = c._count.status;
    //عدد كل الطلبات الموجودة
    totalOrders += c._count.status;
  }

  // 4. حساب إجمالي الأرباح (الإيرادات) للطلبات التي تم إكمالها فقط (COMPLETED)
  const revenue = await prisma.order.aggregate({
    where: { restaurantId, status: "COMPLETED" },
    _sum: { totalPrice: true },
  });

  // 5. إرجاع النتائج النهائية منظمة (حالات الطلبات، المجموع الكلي، وإجمالي الأرباح)
  return {
    ordersByStatus,
    totalOrders,
    totalRevenue: revenue._sum.totalPrice ?? 0,
  };
}