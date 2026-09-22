import { prisma } from "../config/prisma.js";
import { ApiError } from "../utils/ApiError.js";

import { createNotification } from "./notificationService.js";

//Defining a function to create a new order and export it
export const createOrder = async (customerId, restaurantId, items) => {
  //check if the array items is found or empty
  if (!items || items.length === 0) {
    throw new ApiError(400, "☺️يجب أن يحتوي صنف واحد على الأقل بالطلب");
  } 

  // استخراج معرفات الأصناف فقط من المصفوفة المرسلة
  const menuItemIds = items.map((i) => i.menuItemId);
  // البحث في قاعدة البيانات عن الأصناف التي تطابق المعرفات وتنتمي لنفس المطعم ومتاحة حالياً
  const menuItems = await prisma.menuItem.findMany({
    //in: in SQL Mean is Matchting any element within the list
    where: { id: { in: menuItemIds }, restaurantId, isAvailable: true },
  });

  // التحقق من أن عدد الأصناف التي تم العثور عليها يطابق عدد المعرفات المرسلة
  if (menuItems.length !== menuItemIds.length) {
    throw new ApiError(400, "في صنف أو أكتر مش موجود أو مو متاح حاليًا بهاد المطعم");
  } 
  // إنشاء خريطة (Map) لتسهيل الوصول لكل صنف باستخدام معرفه
  const menuItemMap = new Map(menuItems.map((m) => [m.id, m]));

  // تعريف متغير لتخزين السعر الإجمالي للطلب وبدايته صفر
  let totalPrice = 0;

  // تجهيز بيانات عناصر الطلب وحساب السعر الكلي
  const orderItemsData = items.map((i) => {

    // جلب بيانات الصنف من الخريطة باستخدام معرّفه
    const menuItem = menuItemMap.get(i.menuItemId);

    // تحديد الكمية المطلوبة (وإذا لم تكن محددة فتعتبر 1)
    const quantity = i.quantity ?? 1;

    // إضافة سعر الأصناف مضروباً في الكمية إلى السعر الإجمالي
    totalPrice += Number(menuItem.price) * quantity;

    // إرجاع كائن يمثل عنصر الطلب لـ Prisma
    return {
      menuItemId: menuItem.id,
      quantity,
      unitPrice: menuItem.price, // Price Snapshotting - حفظ السعر الحالي وقت الطلب
      note: i.note ?? null,
    }; 

  }); 

  // إنشاء الطلب الجديد في قاعدة البيانات مع حفظ العناصر المرتبطة به
  const order = await prisma.order.create({
    data: {
      customerId,
      restaurantId,
      totalPrice,
      items: { create: orderItemsData },
    },
    include: { items: true },
  });

  // إرجاع الطلب الذي تم إنشاؤه للعميل
  return order;

}; 
// Defining a  function to accepted the order and exported it
export const acceptOrder = async (orderId, employeeUserId, employeeRestaurantId) => {

  // البحث عن الطلب في قاعدة البيانات باستخدام معرفه
  const order = await prisma.order.findUnique({ where: { id: orderId } });

  if (!order) throw new ApiError(404, "الطلب الذي تبحث عنه غير موجود");

  // التحقق من أن الطلب ينتمي لنفس مطعم الموظف الحالي
  if (order.restaurantId !== employeeRestaurantId) {
    throw new ApiError(403, "هاد الطلب غير تابعك مطعمك");
  }

  // تحديث حالة الطلب بشرط أن يكون حالياً بحالة PENDING (منع Race Condition)

  /*الفرق بين update و updateMany في Prisma:

  دالة update العادية بترجع لك كائن السجل نفسه بعد التعديل.

  أما دالة updateMany بترجع لك كائن (Object) يحتوي على خاصية اسمها count بتمثل عدد الصفوف التي تم تعديلها فعلياً في قاعدة البيانات. */
 
  /*كيف بتمنع الـ Race Condition؟
  أنت بتقول لقاعدة البيانات: "عدّلي الطلب الذي يحمل الـ id هذا، بشرط أن تكون حالته الحالية تساوي PENDING".

  لو في موظفين اتنين ضغطوا "قبول" على نفس الطلب بنفس اللحظة:
  *الموظف الأول الطلب بيكون حالته PENDING، فراح يتحدث ويصير ACCEPTED (بيرجع count: 1).

  الموظف الثاني، لما يوصل طلبه بنفس الثانية، راح تبحث القاعدة عن طلب الـ id تبعه كذا وحالته PENDING فلم تجده (لأن الأول غيّر حالته)، فراح ترجع count: 0، والكود عندك بيعطيه خطأ 409 وبيقوله: "الطلب ما عاد بحالة قيد الانتظار". */

  const result = await prisma.order.updateMany({
    where: { id: orderId, status: "PENDING" },
    data: {
      status: "ACCEPTED",
      acceptedAt: new Date(),
      handledByUserId: employeeUserId, //  هون بنسجل مين قبل الطلب بالضبط
    },
  });

  // إذا لم يتم تحديث أي سجل فهذا يعني أن حالته تغيرت مسبقاً
  if (result.count === 0) {
    throw new ApiError(409, "هاد الطلب لم يعد بحالة قيد الانتظار (قبلو موظف تاني أو انتهت مهلته)");
  }

  await createNotification({
    userId: order.customerId,
    orderId: order.id,
    type: "ORDER_ACCEPTED",
    message: "طلبك مقبول — ادفع مشان نبعتها عالمطبخ",
  });

  // إرجاع الطلب بعد تحديثه
  return prisma.order.findUnique({ where: { id: orderId } });
};

//Defining a  function to rejected the order and exported it

export const rejectOrder = async (orderId, employeeRestaurantId, reason) => {

  // التحقق من أن سبب الرفض مرسل وليس فارغاً
  if (!reason || reason.trim() === "") {

    throw new ApiError(400, "سبب الرفض مطلوب");

    }
  // البحث عن الطلب في قاعدة البيانات باستخدام معرفه
  const order = await prisma.order.findUnique({ where: { id: orderId } });

  if (!order) throw new ApiError(404, "الطلب الذي تريد  رفضه غير موجود");

  // التحقق من أن الطلب ينتمي لنفس مطعم الموظف الحالي
  if (order.restaurantId !== employeeRestaurantId) {

    throw new ApiError(403, "هاد الطلب غير تابع إلى مطعمك فلا يمكنك رفضه");

    }
  // تحديث حالة الطلب إلى REJECTED بشرط أن يكون حالياً بحالة PENDING
  const result = await prisma.order.updateMany({
    where: { id: orderId, status: "PENDING" },
    data: { status: "REJECTED", rejectedAt: new Date(), rejectionReason: reason },
  });

  // إذا لم يتم تحديث أي سجل فهذا يعني أن حالته تغيرت مسبقاً
  if (result.count === 0) {

    throw new ApiError(409, "هاد الطلب لم يعاد بحالة قيد الانتظار (ممكن كان اتقبل أو انتهت مهلته مسبقاً)");
    }
await createNotification({
  userId: order.customerId,
  orderId: order.id,
  type: "ORDER_REJECTED",
  message: `تم رفض طلبك: ${reason}`,
});

  //return the order before rejected
  return prisma.order.findUnique({ where: { id: orderId } });

}; 

// تعريف دالة استعراض  كافة طلبات المطعم وتصديرها
export const listRestaurantOrders = async (restaurantId, status) => {

  // جلب الطلبات من قاعدة البيانات مع تصفيتها حسب المطعم والحالة (إن وجدت) وترتيبها من الأحدث للأقدم
  return prisma.order.findMany({
    where: { restaurantId, ...(status ? { status } : {}) },
    include: { items: { include: { menuItem: true } } },
    orderBy: { createdAt: "desc" },
  });

}; 
// تعريف دالة غير متزامنة لإكمال الطلب وتغيير حالته إلى مكتمل/جاهز
export const completeOrder = async (orderId, employeeUserId, employeeRestaurantId) => {
  
  // 1. البحث عن الطلب في قاعدة البيانات باستخدام معرف الطلب للتأكد من وجوده
  const order = await prisma.order.findUnique({ where: { id: orderId } });
  
  if (!order) throw new ApiError(404, "الطلب غير موجود");

  // 2. التحقق من الصلاحيات: هل مطعم الموظف الحالي يطابق مطعم الطلب؟
  if (order.restaurantId !== employeeRestaurantId) {
    throw new ApiError(403, "😊هاد الطلب مو تابع لك");
  }

  // التحقق من أن الموظف الحالي هو نفسه من قام بقبول الطلب مسبقاً
  if (order.handledByUserId !== employeeUserId) {
    throw new ApiError(403, "بس الموظف يلي قبل الطلب هو يلي فيه يكمّلها");
  }

  // 3. تحديث حالة الطلب إلى مكتمل (COMPLETED) وتسجيل وقت الإكمال، بشرط أن يكون بحالة التحضير (PREPARING) مسبقاً
  const result = await prisma.order.updateMany({
    where: { id: orderId, status: "PREPARING" },
    data: { status: "COMPLETED", completedAt: new Date() },
  });

  // 4. التحقق مما إذا تم تعديل أي سجل (إذا كان عدد السجلات المعدلة 0، فهذا يعني أن الطلب لم يكن بحالة التحضير)
  if (result.count === 0) {
    throw new ApiError(409, "الطلب لازم يكون بحالة التحضير لتستطيع أن تكمله");
  }

  // 5. إنشاء وإرسال إشعار للزبون صاحب الطلب لإعلامه بأن وجبته أصبحت جاهزة
  await createNotification({
    userId: order.customerId,
    orderId: order.id,
    type: "ORDER_READY",
    message: "طلبك جاهز، تفضل استلمو",
  });

  // 6. جلب بيانات الطلب المحدثة وإرجاعها كنتيجة نهائية للدالة
  return prisma.order.findUnique({ where: { id: orderId } });
};



//فكرة اضافية اثناء التطوير 
// تعريف دالة استعراض طلبات الزبون نفسه
export const listCustomerOrders = async (customerId, status) => {
  return prisma.order.findMany({
    where: { customerId, ...(status ? { status } : {}) },
    include: { items: { include: { menuItem: true } } },
    orderBy: { createdAt: "desc" },
  });
};