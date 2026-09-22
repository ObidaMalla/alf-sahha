import { asyncHandler } from "../utils/asyncHandler.js";
import { ApiError } from "../utils/ApiError.js";
import { successHandler } from "../handlers/successHandler.js";
import {
  createOrder,
  acceptOrder,
  rejectOrder,
  listRestaurantOrders,
  listCustomerOrders, 
} from "../services/orderService.js";
import { payOrder } from "../services/paymentService.js";
import { completeOrder } from "../services/orderService.js";


// تعريف دالة إنشاء طلب جديد وتصديرها، مغلفة بـ asyncHandler
export const create = asyncHandler(async (req, res) => {
  // 🛑 التحقق من أن المستخدم زبون حصراً (منع الموظفين أو المالكين من الطلب)
  if (req.user.role !== 'CUSTOMER') {
    throw new ApiError(403, "عذراً، الحسابات الإدارية أو حسابات الموظفين لا يمكنها إنشاء طلبات");
  }

  // استخراج معرف المطعم وقائمة الأصناف من جسم الطلب
  const { restaurantId, items } = req.body;

  if (!restaurantId) throw new ApiError(400, "مطلوب المعرف الخاص بالمطعم");
  
  // استدعاء خدمة إنشاء الطلب في قاعدة البيانات
  const order = await createOrder(req.user.id, restaurantId, items);

  return successHandler(res, 201, "تم إرسال الطلب بنجاح", order);
});
export const accept = asyncHandler(async (req, res) => {
      //Calling the order accept service and passing  OrderID and RestaurantID For the current employee's
  const order = await acceptOrder(req.params.id, req.user.id, req.user.restaurantId);

  return successHandler(res, 200, "تم قبول الطلب الخاص بك", order);

}); 

export const reject = asyncHandler(async (req, res) => {

  //Extracting the reason for the order rejection
  const { reason } = req.body|| {};

  const order = await rejectOrder(req.params.id, req.user.restaurantId, reason);

  return successHandler(res, 200, "تم رفض الطلب الخاص بك ", order);

}); 
export const listForRestaurant = asyncHandler(async (req, res) => {

  // استخراج حالة الطلب (إن وجدت) من معاملات الرابط (Query Parameters)
  const { status } = req.query;

  // استدعاء خدمة جلب طلبات المطعم وتمرير معرف المطعم وحالة التصفية
  const orders = await listRestaurantOrders(req.params.id, status);

  return successHandler(res, 200, "تم جلب  كل الطلبات بنجاح", orders);

}); 

//import { payOrder } from "../services/paymentService.js";

export const pay = asyncHandler(async (req, res) => {
  const order = await payOrder(req.params.id, req.user.id);
  return successHandler(res, 200, "تم الدفع بنجاح", order);
});

export const complete = asyncHandler(async (req, res) => {
  const order = await completeOrder(req.params.id, req.user.id, req.user.restaurantId);
  return successHandler(res, 200, "تم تجهيز الطلب", order);
});

//فكرة اثناء التطوير
export const listMyOrders = asyncHandler(async (req, res) => {
  const customerId = req.user.id; // من الـ JWT بعد protect
  const { status } = req.query; // فلترة اختيارية عبر ?status=PENDING مثلاً

  const orders = await listCustomerOrders(customerId, status);
  return successHandler(res, 200, "طلباتك", orders);
});