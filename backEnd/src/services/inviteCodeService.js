import { prisma } from "../config/prisma.js"; 
import { ApiError } from "../utils/ApiError.js"; 
import { generateToken } from "./authService.js"; 
import { generateInviteCode } from "../utils/generateCode.js"; 
const CODE_EXPIRY_HOURS = 24; // تحديد مدة صلاحية كود الدعوة (24 ساعة)

// دالة إنشاء كود دعوة عام للمطعم بواسطة مالكه
export const createInviteCode = async (ownerId, restaurantId) => {
  // التحقق من وجود المطعم وأن المستخدم الحالي هو مالكه الفعلي
  const restaurant = await prisma.restaurant.findUnique({ where: { id: restaurantId } });
  if (!restaurant || restaurant.ownerId !== ownerId) {
    throw new ApiError(403, "هذا المطعم ليس لك 😁");
  }

  // حساب وقت انتهاء صلاحية الكود (الوقت الحالي مضافاً إليه 24 ساعة)
  const expiresAt = new Date(Date.now() + CODE_EXPIRY_HOURS * 60 * 60 * 1000);

  // إنشاء سجل كود الدعوة في قاعدة البيانات
  const inviteCode = await prisma.restaurantInviteCode.create({
    data: {
      code: generateInviteCode(),
      restaurantId,
      expiresAt,
    },
  });

  return inviteCode;
};

// دالة تفعيل كود الدعوة من قبل المستخدم ليصبح موظفاً في المطعم
export const redeemInviteCode = async (userId, code) => {
  // البحث عن كود الدعوة في قاعدة البيانات
  const inviteCode = await prisma.restaurantInviteCode.findUnique({ where: { code } });

  if (!inviteCode) {
    throw new ApiError(404, "كود الدعوة غير صحيح");
  }
  // التأكد أن حالة الكود لا تزال PENDING (لم تُستخدم من قبل أو لم تلغَ)
  if (inviteCode.status !== "PENDING") {
    throw new ApiError(409, "هاد الكود مستخدم مسبقاً أو منتهي");
  }
  // التحقق مما إذا كان الكود قد تخطى تاريخ انتهائه
  if (inviteCode.expiresAt < new Date()) {
    await prisma.restaurantInviteCode.update({
      where: { id: inviteCode.id },
      data: { status: "EXPIRED" },
    });
    throw new ApiError(410, " هاد الكود منتهي الصلاحية يرجى اعادة كود جديد من مدير المطعم و إدخاله");
  }

  // التأكد أن دور المستخدم الحالي يسمح له بأن يصبح موظفاً (CUSTOMER)
  const user = await prisma.user.findUnique({ where: { id: userId } });
  if (user.role !== "CUSTOMER") {
    throw new ApiError(409, "لا يمكن ان تكون موظف بهاد الحساب لأن لديك دور مسبقاً فيه ");
  }

  // تنفيذ معاملة (Transaction) متكاملة لربط الموظف بالمطعم وتحديث حالة الكود وترقية دور المستخدم
  const updatedUser = await prisma.$transaction(async (tx) => {
    // 1. إضافة المستخدم إلى جدول طاقم العمل في المطعم
    await tx.restaurantStaff.create({
      data: {
        userId,
        restaurantId: inviteCode.restaurantId,
        inviteCodeId: inviteCode.id,
      },
    });

    // 2. تحديث حالة كود الدعوة إلى مستخدم (USED) وتسجيل وقت الاستخدام
    await tx.restaurantInviteCode.update({
      where: { id: inviteCode.id },
      data: { status: "USED", usedAt: new Date() },
    });

    // 3. ترقية دور المستخدم في جدول المستخدمين إلى EMPLOYEE
    return tx.user.update({
      where: { id: userId },
      data: { role: "EMPLOYEE" },
    });
  });

  // توليد توكن جديد للمستخدم يتضمن دور EMPLOYEE ومعرف المطعم الجديد، ثم إرجاعه
  const token = generateToken(updatedUser, inviteCode.restaurantId);

  return { token, restaurantId: inviteCode.restaurantId };
};