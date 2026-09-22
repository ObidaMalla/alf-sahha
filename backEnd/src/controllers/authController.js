import { prisma } from "../config/prisma.js"; // 👈 تأكد موجودة

import { asyncHandler } from "../utils/asyncHandler.js"; // استيراد دالة لتغليف العمليات غير المتزامنة والتقاط الأخطاء تلقائياً
import { ApiError } from "../utils/ApiError.js"; // استيراد فئة لإدارة وإنشاء أخطاء HTTP المخصصة
import { successHandler } from "../handlers/successHandler.js"; // استيراد دالة موحدة لتنسيق وإرسال الردود الناجحة
import {
  registerUser,
  loginUser,
  logoutUser,
} from "../services/authService.js"; // استيراد دوال منطق المصادقة والعمليات الخاصة بالمستخدمين من ملف الخدمة
import { createNotification } from "../services/notificationService.js"; // 👈 جديد، ضيفها إذا مش موجودة
// دالة التحكم الخاصة بإنشاء حساب جديد
export const register = asyncHandler(async (req, res) => {
  const { name, email, password } = req.body; // استخراج الاسم والبريد الإلكتروني وكلمة المرور من جسم الطلب

  if (!name || !email || !password) { // التحقق من وجود الحقول الأساسية
    throw new ApiError(400, "يجب ادخال الاسم و البريد الإلكتروني والباسورد ");
  }

  const user = await registerUser(name, email, password); // استدعاء خدمة التسجيل لإنشاء المستخدم في قاعدة البيانات
  return successHandler(res, 201, "تم إنشاء الحساب بنجاح", user); 
});

// دالة التحكم الخاصة بتسجيل الدخول
export const login = asyncHandler(async (req, res) => {
  const { email, password, fcmToken } = req.body;

  if (!email || !password) {
    throw new ApiError(400, "يجب ادخال الاسم و البريد الإلكتروني والباسورد ");
  }

  const result = await loginUser(email, password); // استدعاء خدمة تسجيل الدخول للتحقق وتوليد التوكن

  // 👇 جديد — تخزين fcmToken إذا انبعت مع الطلب
  if (fcmToken) {
    await prisma.user.update({
      where: { id: result.user.id },
      data: { fcmToken },
    });
  }

  // 👇 جديد — إشعار ترحيبي عند كل تسجيل دخول
  await createNotification({
    userId: result.user.id,
    type: "WELCOME",
    message: `أهلاً وسهلاً بك في تطبيق ألف صحة يا ${result.user.name}! 👋`,
  });

  return successHandler(res, 200, "تم تسجيل الدخول بنجاح", result); // إرجاع رد ناجح برمز 200 مع التوكن والبيانات
});

// دالة التحكم الخاصة بتسجيل الخروج وإبطال التوكن
export const logout = asyncHandler(async (req, res) => {
  // req.user و req.token يتم جلبهما مسبقاً من الـ middleware الخاص بحماية المسارات (protect)
  await logoutUser(req.token, req.user.exp); // حفظ التوكن في القائمة السوداء لمنع استخدامه لاحقاً
  return successHandler(res, 200, "تم تسجيل الخروج بنجاح"); // إرجاع رد نجاح برمز 200
});
