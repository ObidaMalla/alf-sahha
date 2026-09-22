import { prisma } from "../config/prisma.js";
import { ApiError } from "../utils/ApiError.js";
import bcrypt from "bcrypt";

export const getProfile = async (userId) => {
  const user = await prisma.user.findUnique({
    where: { id: userId },
    select: {
      id: true,
      name: true,
      email: true,
      role: true,
      walletBalance: true,
      createdAt: true,
    },
  });

  if (!user) throw new ApiError(404, "المستخدم غير موجود");
  return user;
};

export const updateProfile = async (userId, { email, currentPassword, newPassword }) => {
  if (!email && !newPassword) {
    throw new ApiError(400, "لازم تحدد إيميل جديد أو كلمة سر جديدة على الأقل");
  }

  if (!currentPassword) {
    throw new ApiError(400, "كلمة السر الحالية مطلوبة للتأكيد");
  }

  const user = await prisma.user.findUnique({ where: { id: userId } });
  if (!user) throw new ApiError(404, "المستخدم غير موجود");

  const isMatch = await bcrypt.compare(currentPassword, user.passwordHash);
  if (!isMatch) {
    throw new ApiError(401, "كلمة السر الحالية غير صحيحة");
  }

  const dataToUpdate = {};

  if (email && email !== user.email) {
    const existing = await prisma.user.findUnique({ where: { email } });
    if (existing) throw new ApiError(409, "هاد الإيميل مستخدم من حساب تاني");
    dataToUpdate.email = email;
  }

  if (newPassword) {
    dataToUpdate.passwordHash = await bcrypt.hash(newPassword, 10);
  }

  return prisma.user.update({
    where: { id: userId },
    data: dataToUpdate,
    select: {
      id: true,
      name: true,
      email: true,
      role: true,
      walletBalance: true,
      createdAt: true,
    },
  });
};