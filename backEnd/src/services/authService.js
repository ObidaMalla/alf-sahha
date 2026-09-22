import { prisma } from "../config/prisma.js"; // استيراد كائن بريزما للاتصال بقاعدة البيانات
import { ApiError } from "../utils/ApiError.js"; // استيراد فئة إدارة الأخطاء المخصصة
import bcrypt from "bcrypt"; // استيراد مكتبة تشفير ومقارنة كلمات المرور
import jwt from "jsonwebtoken"; // استيراد مكتبة إنشاء وتوقيع توكنات JWT

const SIGNUP_BONUS_AMOUNT = 1000.0; // تحديد قيمة بونص التسجيل للمستخدم الجديد

// بتحدد أي مطعم مرتبط بالمستخدم حاليًا (Owner أو Employee) - null إذا Customer عادي
export const resolveRestaurantId = async (user) => {
  if (user.role === "OWNER") {
    const restaurant = await prisma.restaurant.findUnique({
      where: { ownerId: user.id },
      select: { id: true },
    });
    return restaurant?.id ?? null;
  }

  if (user.role === "EMPLOYEE") {
    const staff = await prisma.restaurantStaff.findUnique({
      where: { userId: user.id },
      select: { restaurantId: true },
    });
    return staff?.restaurantId ?? null;
  }

  return null; // CUSTOMER
};

// دالة لتوليد توكن JWT للمستخدم
export const generateToken = (user, restaurantId = null) => {
  return jwt.sign(
    { userId: user.id, role: user.role, restaurantId }, // البيانات المخزنة داخل التوكن (Payload)
    process.env.JWT_SECRET, // المفتاح السري المأخوذ من متغيرات البيئة
    { expiresIn: process.env.JWT_EXPIRY } // مدة صلاحية التوكن
  );
};

// دالة إنشاء حساب مستخدم جديد
export const registerUser = async (name, email, password) => {
  // التحقق مما إذا كان البريد الإلكتروني مسجلاً مسبقاً في قاعدة البيانات
  const existingUser = await prisma.user.findUnique({ where: { email } });
  if (existingUser) {
    throw new ApiError(409, "هذا البريد الاكتروني مسجل مسبقا يجب اختيار بريد غيره");
  }

  // تشفير كلمة المرور قبل حفظها
  const passwordHash = await bcrypt.hash(password, 10);

  // تنفيذ معاملة (Transaction) لضمان إنشاء الحساب وسجل البونص معاً بشكل آمن
  const user = await prisma.$transaction(async (tx) => {
    const newUser = await tx.user.create({
      data: { name, email, passwordHash },
    });

    await tx.transaction.create({
      data: {
        toUserId: newUser.id,
        amount: SIGNUP_BONUS_AMOUNT,
        type: "SIGNUP_BONUS",
      },
    });

    return newUser;
  });

  // إرجاع بيانات المستخدم آمنة دون كلمة المرور
  return {
    id: user.id,
    name: user.name,
    email: user.email,
    role: user.role,
    walletBalance: user.walletBalance,
    createdAt: user.createdAt,
  };
};

// دالة تسجيل الدخول
export const loginUser = async (email, password) => {
  // البحث عن المستخدم بواسطة البريد الإلكتروني
  const user = await prisma.user.findUnique({ where: { email } });
  if (!user) {
    throw new ApiError(401, "البريد الإلكتروني أو كلمة السر غير صحيحة");
  }

  // مقارنة كلمة المرور المدخلة مع كلمة المرور المشفرة المخزنة
  const isMatch = await bcrypt.compare(password, user.passwordHash);
  if (!isMatch) {
    throw new ApiError(401, "البريد الإلكتروني أو كلمة السر غير صحيحة");
  }

  const restaurantId = await resolveRestaurantId(user);

  // إرجاع التوكن وبيانات المستخدم الأساسية
  return {
    token: generateToken(user, restaurantId),
    user: {
      id: user.id,
      name: user.name,
      email: user.email,
      role: user.role,
      restaurantId,
    },
  };
};

// دالة تسجيل الخروج وحفظ التوكن في القائمة السوداء
export const logoutUser = async (token, decodedExp) => {
  await prisma.blacklistedToken.create({
    data: {
      token,
      expiresAt: new Date(decodedExp * 1000), // تحويل وقت الانتهاء من ثوانٍ إلى تاريخ ميلادي
    },
  });
};
