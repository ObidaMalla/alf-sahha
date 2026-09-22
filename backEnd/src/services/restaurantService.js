import { prisma } from "../config/prisma.js"; // استدعاء كائن للاتصال بال DB
import { ApiError } from "../utils/ApiError.js";
import { generateToken } from "./authService.js"; // استيراد دالة توليد التوكن

// دالة إنشاء مطعم جديد وترقية دور المستخدم إلى OWNER
export const createRestaurant = async (userId, { name, description, address, imageUrl }) => {
  // البحث عن المستخدم للتأكد من دوره الحالي
  const user = await prisma.user.findUnique({ where: { id: userId } });

  // التحقق مما إذا كان المستخدم يملك دوراً مسبقاً (ليس CUSTOMER)
  if (user.role !== "CUSTOMER") {
    throw new ApiError(409, "عندك دور مسبقاً لا يمكنك ان تنشئ مطعم لأنك إما مدير أو موظف في محل آخر");
  }

  // تنفيذ معاملة (Transaction) لإنشاء المطعم وتحديث دور المستخدم في نفس الوقت لضمان السلامة
  const { restaurant, updatedUser } = await prisma.$transaction(async (tx) => {
    const restaurant = await tx.restaurant.create({
      data: { ownerId: userId, name, description, address, imageUrl },
    });

    const updatedUser = await tx.user.update({
      where: { id: userId },
      data: { role: "OWNER" },
    });

    return { restaurant, updatedUser };
  });

  // توليد توكن جديد يتضمن الدور الجديد OWNER ومعرف المطعم restaurantId، ثم إرجاعه مع النتيجة
  const token = generateToken(updatedUser, restaurant.id);

  return { restaurant, token };
};

// دالة جلب قائمة بجميع المطاعم مع الحقول الأساسية فقط
export const listRestaurants = async () => {
  return prisma.restaurant.findMany({
    select: { id: true, name: true, description: true, address: true, imageUrl: true },
  });
};

// دالة جلب تفاصيل مطعم معين بواسطة الـ ID
export const getRestaurantById = async (id) => {
  const restaurant = await prisma.restaurant.findUnique({ where: { id } });
  if (!restaurant) {
    throw new ApiError(404, "المطعم غير موجود");
  }
  return restaurant;
};